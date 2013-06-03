use Test::Simple tests=> 1;
use warnings;
use strict;
use Test::MockObject;

use Impressions::BannersStrategies::UserSessionStrategy;
use Impressions::BannersStrategies::PickSecondStrategy;

my @banners_list = (
    {'_id' => 'banner_1', 'prob'=> 0.1, 'max_views' => 4},
    {'_id' => 'banner_2', 'prob'=> 0.2, 'max_views' => 2},
);

my $pick_second_strategy = Impressions::BannersStrategies::PickSecondStrategy->new();
my $session = Test::MockObject->new();
$session->set_isa('Session::Impressions::Redis');
$session->set_true('does');

my $user_session_based_strategy = Impressions::BannersStrategies::UserSessionStrategy->new({
	'banners_strategy' => $pick_second_strategy,
	'session' => $session,
	'default_max_views' => 1,
});

my $picked_bannner = $user_session_based_strategy->pick_banner(\@banners_list);

ok( $picked_bannner->{'_id'} eq 'banner_1' || $picked_bannner->{'_id'} eq 'banner_2'  
, 'Works without errors this is good');