package Impressions::BannersStrategies::UserSessionStrategy;

use strict;
use warnings;

use Moo;

with('Impressions::BannersStrategies::StrategyRole');

#strategy thet will pick a banner according to its weight or something else
has 'banners_strategy' => (
    'is' => 'ro',
    'required' => 1,
);
#redis connection
has 'session' => (
    'is' => 'ro',
    'isa' => sub{
    	if(! $_[0]->does('Session::Impressions::ImpressionSessionRole')){
    		die "session is not implements Session::Impressions::ImpressionSessionRole";
    	}
    },
    'required' => 1,
);
has 'default_max_views' => (
    'is' => 'ro',
    'required' => 1,    
);
=pod
=head1 Impressions::BannersStrategies::UserSessionStrategy
The strategy based on an user session. I.e. a customer can choose to not to
show the same banner for one person more than N times, and so on.
=cut


############################################
# Usage      : $banner = $strategy->pick_banner(\@banners_list, $user_id)
# Purpose    : pick a banner from list according to user session information
#              and weight of that banner
# Returns    : banner hash reference
# Parameters : banners list
#              user_id - id of user to track session information
# Throws     : no exceptions
# Comments   : ???
sub pick_banner(){
    my ($self, $banners_list, $user_id) = @_;
    
    my @reduced_banners_list = $self->__reduce_banners_from_list($banners_list, $user_id);
    my $picked_banner = 0;
    if(defined $banners_list){
        $picked_banner = $self->banners_strategy->pick(\@reduced_banners_list);
    }
    
    $self->session->incr_banner_display($user_id, $picked_banner->{'_id'}->to_string(), 1);
    
    return $picked_banner;
}

############################################
# Usage      : $banner = $self->__reduce_banners_from_list(\@banners_list, $user_id);
# Purpose    : reduce banners list with banners that were already shown too many times
# Returns    : reduced banners list
# Parameters : banners list array reference
#              user_id - id of user to track session information
# Throws     : no exceptions
# Comments   : ???
sub __reduce_banners_from_list(){
	my ($self, $banners_list, $user_id) = @_;
	my %shown_banners_views = $self->session->get_displayed_banners($user_id);
	my @banners_accepted_to_show = ();
	for my $banner (@{$banners_list}){
		my $banner_max_views = $banner->{'max_views'} ? $banner->{'max_views'} : $self->default_max_views;
		my $banner_id = $banner->{'_id'}->to_string();
		if(!(exists $shown_banners_views{$banner_id}
		   && $shown_banners_views{$banner_id} > $banner_max_views)){
			push @banners_accepted_to_show, $banner;
		}
	} 
	
	return @banners_accepted_to_show;
}

1;