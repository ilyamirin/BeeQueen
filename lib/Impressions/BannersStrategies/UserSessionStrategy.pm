package Impressions::BannersStrategies::UserSessionStrategy;

use strict;
use warnings;

use Moo;

with('Impressions::BannersStrategies::StrategyRole');

#strategy thet will pick a banner according to its weight or something else
has 'banners_strategy' => ('is' => 'ro');
#redis connection
has 'session' => (
    'is' => 'ro',
    'isa' => sub{
    	if(! $_[0]->does('Session::Impressions::ImpressionSessionRole')){
    		die "session is not implements Session::Impressions::ImpressionSessionRole";
    	}
    }
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
    my ($self, $banners_list) = @_;
    my $picked_banner = 0;
    if(defined $banners_list){
        $picked_banner = $self->banners_strategy->pick($banners_list);
    }
    
    return $picked_banner;
}


1;