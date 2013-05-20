use Test::Simple tests=> 2;
use warnings;
use strict;

use Redis;
use Session::Impressions::Redis;


my $redis = Redis->new( server => 'localhost:6379', encoding => undef );

my $session = Session::Impressions::Redis->new({
	'redis' => $redis,
	'expire_time' => 2,
});

my $user_id = 'user_id_1';
my $banner_id = 'banner_id_1';
my $banner_views = 2;

$session->incr_banner_display($user_id, $banner_id, $banner_views);
$session->incr_banner_display($user_id, $banner_id, $banner_views);
my %banners_views = $session->get_displayed_banners($user_id);

ok((keys %banners_views)[0] eq $banner_id, 'Banner id is the same');
ok((values %banners_views)[0] == $banner_views * 2, 'Banner views increased as expected');