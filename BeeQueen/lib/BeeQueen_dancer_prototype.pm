package BeeQueen;
use Dancer ':syntax';
use MongoDB;
use DateTime;
use String::Random;
use Data::Dumper;

our $VERSION = '0.1';

our $random = String::Random->new;

our $client = MongoDB::MongoClient->new( host => 'localhost', port => 27017 );
our $database = $client->get_database( 'beequeen' );

our $impressions = $database->get_collection( 'impressions' );
our $clicks = $database->get_collection( 'clicks' );
our $events = $database->get_collection( 'events' );

our $targets = $database->get_collection( 'targets' );
our $banners = $database->get_collection( 'banners' );

sub determine_banners_for_impression {
    my $impression = shift;

    my $query = { _id => MongoDB::OID->new(value => $impression->{ targetid }) };
    my $target = $targets->find( $query )->next;
   
    #TODO:: show one user no more times than?
    #TODO:: roulette them?

    $query = { _id => { '$in' => $target->{ banners } } };
    my @banners = $banners->find( $query )->all;
    info scalar @banners  . ' banners found for impression';
    \@banners;
};

sub get_url_for_banner_with_id {
    my $banner = $banners->findOne({ 
            _id => MongoDB::OID->new(value => shift) 
    });
    return $banner->{ url };
};

get '/' => sub {
    { name => 'Cloud Advertisement Processor', now => DateTime->now->datetime() };
};

any [ 'get', 'post' ] => '/impression' => sub {
    my $impr = {};
    $impr->{ $_ } = params->{ $_ } for qw{ userid targetid  };
    $impr->{ recieved_at } = DateTime->now; 
    $impr->{ banners } = determine_banners_for_impression( $impr );
    $impressions->insert( $impr );
    #let client see the banners URLs list
    return [ map { $_->{ url } } @{ $impr->{ banners } } ];
};

any [ 'get', 'post' ] => '/click' => sub {
    my $click = {};
    $click->{ $_ } = params->{ $_ } for qw{ userid targetid bannerid };
    $click->{ recieved_at } = DateTime->now; 
    $click->{ redirected_to } = get_url_for_banner_with_id( $click->{ bannerid } ); 
    $clicks->insert( $click );
    redirect $click->{ redirected_to };
};

any [ 'get', 'post' ] => '/event' => sub {
    my $event = {};
    $event->{ $_ } = params->{ $_ } for qw{ userid type };
    $event->{ recieved_at } = DateTime->now; 
    $events->insert( $event );
    return;
};

true;
