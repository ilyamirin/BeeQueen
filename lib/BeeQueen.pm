package BeeQueen;
use Dancer ':syntax';
use MongoDB;
use DateTime;
use String::Random;

our $VERSION = '0.1';

our $random = String::Random->new;

our $client = MongoDB::MongoClient->new( host => 'localhost', port => 27017 );
our $database = $client->get_database( 'beequeen' );
our $impressions = $database->get_collection( 'impressions' );
our $clicks = $database->get_collection( 'clicks' );
our $events = $database->get_collection( 'events' );

sub determine_banners_for_impression {
    my ( $impression ) = @_;
    my @banners = ( 
        { 
            bannerid => $random->randregex('[0-9a-z]{36}'), 
            banner_picture => 'http://www.google.com/images/srpr/logo4w.png'
        }
    );
    \@banners;
};

sub get_url_for_banner {
    my $bannerid = shift;
    return 'http://www.google.com/';
};

get '/' => sub {
    { name => 'Cloud Advertisement Processor', now => DateTime->now };
};

any [ 'get', 'post' ] => '/impression' => sub {
    my $impr = {};
    $impr->{ $_ } = params->{ $_ } for qw{ userid targetid  };
    $impr->{ recieved_at } = DateTime->now; 
    $impr->{ banners } = determine_banners_for_impression( $impr );
    $impressions->insert( $impr );
    return $impr->{ banners };
};

any [ 'get', 'post' ] => '/click' => sub {
    my $click = {};
    $click->{ $_ } = params->{ $_ } for qw{ userid targetid bannerid };
    $click->{ recieved_at } = DateTime->now; 
    $click->{ redirected_to } = get_url_for_banner( $click->{ bannerid } ); 
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
