package Session::ImpressionsSession;

use strict;
use warnings;

use Moo;

with('Impressions::BannersStrategies::StrategyRole');

#redis connection
has 'redis' => ('is' => 'ro');
#expire time
has 'expire_time' => ('is' => 'ro');

=pod
=head1 Session::ImpressionsSession
This session stores ingormation about showed banners for user
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
sub store_banner_display(){
    my ($self, $user_id, $banner_id, $displays_number) = @_;
    
    my $status = 1;    
    return $status;
}

sub get_displayed_banners(){
	my ($user_id) = @_;
	
	my @displayed_banners = ();
}

1;