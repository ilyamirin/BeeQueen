package Session::ImpressionsSession;

use strict;
use warnings;

use Moo;
use Digest::MD5 qw(md5_hex);
use JSON;

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
# Usage      : $status = $session->store_banner_display($user_id, $banner_id, 12);
# Purpose    : Store information about banner views count
# Returns    : banner hash reference
# Parameters : user_id - id of user to track session information
#              banner_id - identifyer of banner
#              banner views - number of views for givent banner
# Throws     : no exceptions
# Comments   : ???
sub store_banner_display(){
    my ($self, $user_id, $banner_id, $views_number) = @_;
    
    my $banner_views = {'id' => $banner_id, 'views' => $views_number};
    my $banner_views_json = encode_json($banner_views);
    my $key = $self->_get_user_key($user_id);
    #store value with expire
    $self->redis->multi();
    $self->redis->sadd($key, $banner_views_json);
    $self->redis->expire($key, $self->expire_time);
    $self->redis->exec();
    
    my $status = 1;    
    return $status;
}

sub _get_user_key(){
	my ($self, $user_id) = @_;
	my $user_key = 'sess:impr:' . md5_hex($user_id) .'set';
	return $user_key;
}

############################################
# Usage      : @banners_view = $session->get_displayed_banners($user_id);
# Purpose    : Returns information about banners views for givent user
# Returns    : banners views array [{'id' => banner_id, 'views' => 54}, ... ]
# Parameters : user_id - id of user to track session information
# Throws     : no exceptions
# Comments   : ???
sub get_displayed_banners(){
	my ($self, $user_id) = @_;
	
	my $key = $self->_get_user_key($user_id);
	my @displayed_banners_json = $self->redis->smembers($key);
	my @banners_views = ();
	for my $banner_views_json (@displayed_banners_json){
		my $banner_view = decode_json($banner_views_json);
		push @banners_views, $banner_view;
	}
	
	return @banners_views;
}

1;