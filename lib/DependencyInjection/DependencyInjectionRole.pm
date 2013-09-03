package DependencyInjection::DependencyInjectionRole;

use Moose;
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
    }
    dependencies => {
    	'mongo' => 'mongo'
    	'database_name' => 'mongo_database_name'
    }
);

has redis_connection =>(
    is => 'ro',
    isa => 'Redis',
    dependencies =>{
    	server => dep(value => 'localhost:6379'),
    	encoding => dep(value => undef),
    	reconnect => dep(value => 60),
    }
);        

has session_impression_redis => (
    is => 'ro',
    isa => 'Session::Impressions::Redis',
    dependencies => {
    	redis => redis_connection,
        expire_time => dep(value => 2)
    }
);


has impression_registrar => (
    is => 'ro',
    isa => 'Impressions::ImpressionStatistics'
    dependencies =>{
        database => 'test_database'        	
    }
);
#random_strategy: 
#    class: 'Impressions::BannersStrategies::RandomStrategy'  
#weights_bassed_strategy:
#    class: 'Impressions::BannersStrategies::WeightBasedStrategy'
#user_session_strategy:
#    class: 'Impressions::BannersStrategies::UserSessionStrategy'
#    args:
#        banners_strategy: {ref: 'weights_bassed_strategy'}
#        session: {ref: 'sessions_impressions_redis'}
#        default_max_views: 5
#           
#banners_query_builder:
#    class: 'Impressions::BannersQueryBuilder'               
#impression_service:
#    class: 'Impressions::Impression'
#    args:
#        database: {ref: 'test_database'}
#        banners_strategies : {random:  {ref : 'random_strategy'}, weight_based: {ref: 'weights_bassed_strategy'}, user_session: {ref: 'user_session_strategy'} }
#        impression_registrar: {ref: 'impression_registrar'}
#        banners_query_builder: {ref: 'banners_query_builder'}
#clicks_service:
#    class: 'Clicks::ClicksService'
#    args:
#        database: {ref: 'test_database'}
#events_service:
#    class: 'Events::EventsService'
#    args:
#        database: {ref: 'test_database'}


