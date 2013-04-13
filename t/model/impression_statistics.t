use Test::Simple tests=> 3;
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
	    $impression_stat->update_impression_stat($target_id, $banner_id);
	}
	
}

#==================RUN TEST========================

$test_utils->clear_collections();#clear dataset after testing
