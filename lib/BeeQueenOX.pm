package BeeQueenOX;

use OX;
with('DependencyInjection::DependencyInjectionRole');

has controller => (
	is           => 'ro',
	isa          => 'Controllers::AdController',
	dependencies => {
		impression_service => 'impression_service',
		clicks_service     => 'clicks_service',
		events_service     => 'events_service',
	},
	 lifecycle => 'Singleton',
);

router as {
	route '/impression'  => 'controller.impression';
	route '/impression/bundle'  => 'controller.impression_bundle';
	route '/click'  => 'controller.click';
	route '/event'  => 'controller.event';
	
};

1;
