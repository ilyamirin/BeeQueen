package Impressions::BannersStrategies::RandomStrategy;

use strict;
use warnings;

use Moo;
use Moo::Role;

with('Impressions::BannersStrategies::StrategyRole');

sub pick_banner(){
	my ($self, $banners_list) = @_;
	$picked_banner = 0;
	if(defined $banners_list){
		my $list_last_index = $#{banners_list};
		my $picked_index = int(rand($list_last_index));
		$picked_banner = ${$banners_list}[$picked_index];
	}
	
	return $picket_banner;
}