package Impressions::BannersStrategies::WeightBasedStrategy;


use strict;
use warnings;

use Moo;

with('Impressions::BannersStrategies::StrategyRole');

=pod
=head1 Impressions::BannersStrategies::WeightBasedStrategy
Pick banner strategy that depends only on weights of banners, i.e. banner
will be picked according it's weight and no other data. If there is not one banner in 
the target, user can receive one even if he already seen it if random sayd so
=cut


############################################
# Usage      : $banner = $strategy->pick_banner(\@banners_list)
# Purpose    : pick banner from list according to it's weight
# Returns    : banner hash reference
# Parameters : banners list
# Throws     : no exceptions
# Comments   : ???
sub pick_banner(){
    my ($self, $banners_list) = @_;
    my $picked_banner = 0;
    if(defined $banners_list){
        my $list_last_index = $#{$banners_list};
        my $picked_index = int(rand($list_last_index));
        $picked_banner = ${$banners_list}[$picked_index];
    }
    
    return $picked_banner;
}

sub __get_random_banner_id_by_weight(){
	my ($self, $banners_weights) = @_;
	
	my $last_index = $#{$banners_weights};
	my $last_weight = ${$banners_weights}[$last_index];
	
	my $random_value = rand($last_weight);
	my $picked_banner_index = 0;
	for my $weight_boundary (@{$banners_weights}){
		if($weight_boundary > $random_value){
			last; 
		}
		$picked_banner_index++;
	} 
}

############################################
# Usage      : @banners_weight_boundaries = $self->__get_banners_weights(\@banners_list)
# Purpose    : get banners weights boundaries
# Returns    : [weight_1, (weight_1 + weight_2), (... + weight_3)]
# Parameters : banners list
# Throws     : no exceptions
# Comments   : ???
sub __get_banners_weights(){
	my ($self, $banners_list) = @_;
	my @banner_weights = ();
	my $prob_summ = 0;
	for my $banner (@{$banners_list}){
		my $weight = $banner->{'prob'};
		$prob_summ += $weight;
		push @banner_weights, $prob_summ;
	}
	
	return @banner_weights;
}

1;