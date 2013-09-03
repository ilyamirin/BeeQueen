package BeeQueenOX;

use OX;
with('DependencyInjection::DependencyInjectionRole');

has controller => (
    is => 'ro',
    isa => 'Controllers::AdController',
    dependencies => {
    	impression_service => 'impression_service',
    	clicks_service => 'clicks_service',
    	events_service => 'events_service',
    }
);

1;
