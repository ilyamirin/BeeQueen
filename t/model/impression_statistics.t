use Test::Simple tests=> 1;
use warnings;
use strict;


use Impressions::ImpressionStatistics; 

use MongoDB;
use MongoDB::MongoClient;
use MongoDB::OID;
use TestUtils::TestUtilsMongo;


my $mongo = MongoDB::MongoClient->new;
my $test_database = $mongo->get_database('test');

#==================PREPARE DATA====================
my $test_utils = TestUtils::TestUtilsMongo->new({'database' => $test_database});

$test_utils->clear_collections();#clear dataset before testing

#==================DEFINE TEST========================
sub test_update_view_statistics(){
	my $impression_stat = Impressions::ImpressionStatistics->new({'database' => $test_database});
	my $target_id = 'target_id_1';
	my $banner_id = 'banner_id_1';
	my $user_id = 'user_id_';
	foreach my $update_couner (1..4){
		my $user_id_iter = $user_id . $update_couner;
	    $impression_stat->register_impression_stat($target_id, $banner_id);
	}
	my @impressions = $impression_stat->find_by_target_banner($target_id, $banner_id);
	ok(@impressions == 4, 'Impression size is ok');
}

#==================RUN TEST========================
test_update_view_statistics();
$test_utils->clear_collections();#clear dataset after testing
