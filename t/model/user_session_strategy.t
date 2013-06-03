use Test::Simple tests=> 1;
use warnings;
use strict;

use Impressions::BannersStrategies::UserSessionStrategy;

my @banners_list = (
    {'_id' => 'banner_1', 'prob'=> 0.1, 'max_views' => 4},
    {'_id' => 'banner_2', 'prob'=> 0.2, 'max_views' => 2},
);

my $pick_second_strategy = Impressions::BannersStrategies::PickSecondStrategy->new();
my $session = "";

my $user_session_based_strategy = Impressions::BannersStrategies::UserSessionStrategy->new({
	'banners_strategy' => $pick_second_strategy,
	'session' => $session,
	'default_max_views' => 1,
});

my $picked_bannner = $user_session_based_strategy->pick_banner(\@banners_list);

ok( $picked_bannner->{'_id'} eq 'banner_1' || $picked_bannner->{'_id'} eq 'banner_2'  
, 'Works without errors this is good');