use Test::Simple tests=> 1;
use warnings;
use strict;

use Impressions::BannersQueryBuilder;


my $query_builder = Impressions::BannersQueryBuilder->new();

my $target_banners = ['a', 'b', 'c'];


my $query_with_target_banners = $query_builder->clear_builder()
                ->set_target_banners($target_banners)
                ->build();
my $test_query = {'_id' => {'$in'=> $target_banners}};
ok(keys %{$test_query} == keys %{$query_with_target_banners}, 'builder ok');
              
