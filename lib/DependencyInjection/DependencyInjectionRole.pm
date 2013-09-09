package DependencyInjection::DependencyInjectionRole;

use Bread::Board::Declare;
use OX::Role;

use Misc::MongoDatabase;
use Impressions::Impression;

has mongo =>(
    is => 'ro',
    isa => 'MongoDB::MongoClient',
    lifecycle => 'Singleton',
);

has mongo_database_name => (
    is       => 'ro',
    isa      => 'Str',
    value => 'development',
    lifecycle => 'Singleton',
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
    },
    lifecycle => 'Singleton',
    
);

has redis_connection =>(
    is => 'ro',
    isa => 'Redis',
    dependencies =>{
    	server => dep(value => 'localhost:6379'),
    	#encoding => dep(value => undef),
    	reconnect => dep(value => 60),
    },
    lifecycle => 'Singleton',
);        

has session_impression_redis => (
    is => 'ro',
    isa => 'Session::Impressions::Redis',
    dependencies => {
    	redis => 'redis_connection',
        expire_time => dep(value => 2)
    },
    lifecycle => 'Singleton',
);


has impression_registrar => (
    is => 'ro',
    isa => 'Impressions::ImpressionStatistics',
    dependencies =>{
        database => 'test_database'        	
    },
    lifecycle => 'Singleton',
);
has random_strategy =>( 
    is => 'ro',
    isa => 'Impressions::BannersStrategies::RandomStrategy',
    lifecycle => 'Singleton',
);  
has weights_bassed_strategy => (
    is => 'ro',
    isa => 'Impressions::BannersStrategies::WeightBasedStrategy',
    lifecycle => 'Singleton',
);
has user_session_strategy => (
    is => 'ro',
    isa =>  'Impressions::BannersStrategies::UserSessionStrategy',
    dependencies => {
        banners_strategy => 'weights_bassed_strategy',
        session => 'session_impression_redis',
        default_max_views => dep(value => 5),
    },
    lifecycle => 'Singleton',
);

has banners_query_builder => (
    is => 'ro',
    isa => 'Impressions::BannersQueryBuilder',
    lifecycle => 'Singleton',
);               

has impression_service => (
    is => 'ro',
#    isa => 'Impressions::Impression',
    block => sub{
    	my $s = shift;
    	Impressions::Impression->new(
	    	database => $s->param('database'),
	        banners_strategies =>  {
	            random => $s->param( 'random'), 
	            weight_based => $s->param('weights_bassed'),
	            user_session => $s->param('user_session'), 
	        },
	        impression_registrar => $s->param('impression_registrar'),
	        banners_query_builder => $s->param('banners_query_builder'),
    	);
    },
    dependencies => {
        database => 'test_database',
        random => 'random_strategy', 
        weight_based => 'weights_bassed_strategy',
        user_session => 'user_session_strategy',
        impression_registrar => 'impression_registrar',
        banners_query_builder => 'banners_query_builder',
    },
    lifecycle => 'Singleton',
#    dependencies => {
#        database => 'test_database',
#        banners_strategies => dep(value => {
#        	random => 'random_strategy', 
#        	weight_based => 'weights_bassed_strategy',
#        	user_session => 'user_session_strategy' 
#        }),
#        impression_registrar => 'impression_registrar',
#        banners_query_builder => 'banners_query_builder',
#    }
);
has clicks_service => (
    is => 'ro',
    isa => 'Clicks::ClicksService',
    dependencies => {
        database => 'test_database'    	
    },
    lifecycle => 'Singleton',
);
has events_service =>( 
    is => 'ro',
    isa => 'Events::EventsService',
    dependencies => {
        database => 'test_database'
    },
    lifecycle => 'Singleton',
);
1;

