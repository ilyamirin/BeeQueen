package Impressions::BannersStrategies::PickSecondStrategy;

=pod
=head1 Impressions::BannersStrategies::PickSecondStrategy
This strategy is for tests purposeonly. It will pick second banner from dataset if two banners are presented 
and would pick no banner if only one is presented.
=cut

use Moo;
use strict;
use warnings;

use Moo;

with('Impressions::BannersStrategies::StrategyRole');

sub pick_banner(){
    my ($self, $banners_list) = @_;
    my $picked_banner = 0;
    if(defined $banners_list && @{$banners_list} > 1){
        $picked_banner = ${$banners_list}[1];   #pick second one if presented     
    }
    
    return $picked_banner;
}

1;