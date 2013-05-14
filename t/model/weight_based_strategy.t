use Test::Simple tests=> 1;
use warnings;
use strict;

use Impressions::BannersStrategies::WeightBasedStrategy;

my @banners_list = (
    {'_id' => 'banner_1', 'prob'=> 0.1},
    {'_id' => 'banner_2', 'prob'=> 0.2},
);

my $weight_based_strategy = Impressions::BannersStrategies::WeightBasedStrategy->new();

my $picked_bannner = $weight_based_strategy->pick_banner(\@banners_list);

ok( $picked_bannner->{'_id'} eq 'banner_1' || $picked_bannner->{'_id'} eq 'banner_2'  
, 'Works without errors this is good');