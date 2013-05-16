package Session::ImpressionsSession;

use strict;
use warnings;

use Moo;

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
sub pick_banner(){
    my ($self, $banners_list) = @_;
    my $picked_banner = 0;
    if(defined $banners_list){
        $picked_banner = $self->banners_strategy->pick($banners_list);
    }
    
    return $picked_banner;
}


1;