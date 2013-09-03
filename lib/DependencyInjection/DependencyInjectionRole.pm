package DependencyInjection::DependencyInjectionRole;

use Bread::Board::Declare;
use Moose::Role;


has mongo =>(
    is => 'ro',
    isa => 'MongoDB::MongoClient'
);

has mongo_database_name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    value => 'development'
);

has test_database => (
    is => 'ro',
    #isa => 'Misc::MongoDatabase',
    block => sub{
    	my $s = shift;
    	Misc::MongoDatabase->get_database(
    	   $s->param('mongo'), 
    	   $s->param('database_name')
    	);
    },
    dependencies => {
    	'mongo' => 'mongo',
    	'database_name' => 'mongo_database_name'
    }
);

has redis_connection =>(
    is => 'ro',
    isa => 'Redis',
    dependencies =>{
    	server => dep(value => 'localhost:6379'),
    	#encoding => dep(value => undef),
    	reconnect => dep(value => 60),
    }
);        

has session_impression_redis => (
    is => 'ro',
    isa => 'Session::Impressions::Redis',
    dependencies => {
    	redis => 'redis_connection',
        expire_time => dep(value => 2)
    }
);


has impression_registrar => (
    is => 'ro',
    isa => 'Impressions::ImpressionStatistics',
    dependencies =>{
        database => 'test_database'        	
    }
);
has random_strategy =>( 
    is => 'ro',
    isa => 'Impressions::BannersStrategies::RandomStrategy',
);  
has weights_bassed_strategy => (
    is => 'ro',
    isa => 'Impressions::BannersStrategies::WeightBasedStrategy'
);
has user_session_strategy => (
    is => 'ro',
    isa =>  'Impressions::BannersStrategies::UserSessionStrategy',
    dependencies => {
        banners_strategy => 'weights_bassed_strategy',
        session => 'sessions_impressions_redis',
        default_max_views => dep(value => 5),
    }
);

has banners_query_builder => (
    is => 'ro',
    isa => 'Impressions::BannersQueryBuilder'
);               

has impression_service => (
    is => 'ro',
    isa => 'Impressions::Impression',
    dependencies => {
        database => 'test_database',
        banners_strategies => {
        	random => 'random_strategy', 
        	weight_based => 'weights_bassed_strategy',
        	user_session => 'user_session_strategy' 
        },
        impression_registrar => 'impression_registrar',
        banners_query_builder => 'banners_query_builder',
    }
);
has clicks_service => (
    is => 'ro',
    isa => 'Clicks::ClicksService',
    dependencies => {
        database => 'test_database'    	
    }
);
has events_service =>( 
    is => 'ro',
    isa => 'Events::EventsService',
    dependencies => {
        database => 'test_database'
    }
);
1;

