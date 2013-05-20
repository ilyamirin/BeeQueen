use Test::Simple tests=> 1;
use warnings;
use strict;

use Redis;
use Session::Impressions::Redis;

my $redis = Redis::Client->new( host => 'localhost', port => 6379 );

my $session = Session::Impressions::Redis->new({
	'redis' => $redis,
	'expire_time' => 2,
});

my $user_id = 'user_id_1';
my $banner_id = 'banner_id_1';
my $banner_views = 2;

$session->store_banner_display($user_id, $banner_id, $banner_views);
my @banners_views = $session->get_displayed_banners($user_id);

ok($banners_views[0]->{'id'} eq $banner_id, 'Banner id is the same');
ok($banners_views[0]->{'views'} == $banner_views, 'Banner vies is the same');