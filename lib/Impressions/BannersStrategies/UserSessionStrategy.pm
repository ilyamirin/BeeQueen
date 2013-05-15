package Impressions::BannersStrategies::UserSessionStrategy;

use strict;
use warnings;

use Moo;

with('Impressions::BannersStrategies::UserSessionStrategy');

=pod
=head1 Impressions::BannersStrategies::UserSessionStrategy
The strategy based on an user session. I.e. a customer can choose to not to
show the same banner for one person more than N times, and so on.
=cut


############################################
# Usage      : $banner = $strategy->pick_banner(\@banners_list, $user_id)
# Purpose    : pick banner from list according to it's weight
# Returns    : banner hash reference
# Parameters : banners list
# Throws     : no exceptions
# Comments   : ???
sub pick_banner(){
    my ($self, $banners_list) = @_;
    my $picked_banner = 0;
    if(defined $banners_list){
        my @banners_weights_list = $self->__get_banners_weights($banners_list);
        my $picked_index = $self->__get_random_banner_id_by_weight(\@banners_weights_list);
        $picked_banner = ${$banners_list}[$picked_index];
    }
    
    return $picked_banner;
}


1;