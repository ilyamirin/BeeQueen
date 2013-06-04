use Test::Simple tests=> 1;
use warnings;
use strict;
use Test::MockObject;
use MongoDB::OID;
use Impressions::BannersStrategies::UserSessionStrategy;
use Impressions::BannersStrategies::PickSecondStrategy;

my @banners_list = (
    {'_id' => MongoDB::OID->new('value' => 'banner_1'), 'prob'=> 0.1, 'max_views' => 4},
    {'_id' => MongoDB::OID->new('value' => 'banner_2'), 'prob'=> 0.2, 'max_views' => 2},
);

my $pick_second_strategy = Impressions::BannersStrategies::PickSecondStrategy->new();
my $session = Test::MockObject->new();
$session->set_isa('Session::Impressions::Redis');
$session->set_true('does');
$session->mock('get_displayed_banners', sub{
	return ('banner_1' => 4);
});
$session->set_true('incr_banner_display');
my $user_session_based_strategy = Impressions::BannersStrategies::UserSessionStrategy->new({
	'banners_strategy' => $pick_second_strategy,
	'session' => $session,
	'default_max_views' => 1,
});
my $user_id = 'test_user_id';
my $picked_bannner = $user_session_based_strategy->pick_banner(\@banners_list, $user_id);

ok( $picked_bannner->{'_id'} eq 'banner_1' || $picked_bannner->{'_id'} eq 'banner_2'  
, 'Works without errors this is good');