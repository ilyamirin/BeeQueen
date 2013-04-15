use Test::Simple tests=> 3;
use warnings;
use strict;
use Test::MockObject;

use Impressions::Impression; 

use MongoDB;
use MongoDB::MongoClient;
use MongoDB::OID;
use TestUtils::TestUtilsMongo;
use Impressions::BannersStrategies::PickSecondStrategy;

my $mongo = MongoDB::MongoClient->new;
my $test_database = $mongo->get_database('test');

#==================PREPARE DATA====================
my $test_utils = TestUtils::TestUtilsMongo->new({'database' => $test_database});

$test_utils->clear_collections();#clear dataset before testing
my $target_id = 'target_id_1';
my $target_name = 'target name simple';
my $target_oid = $test_utils->create_target($target_id, $target_name);
my $random_strategy_name = 'random';
my $pick_second_strategy_name = 'pick_second';

my $banner_url = 'fancy banner url';
my $banner_prob = 0.2;
my $banner_oid = $test_utils->create_banner($target_id, $banner_url, $banner_prob);

#===Data for test with numerious banners===
my $target_id2 = 'target od 2';
my $target_name2 = 'target_name 2';

my $target_oid2 = $test_utils->create_target($target_id2, $target_name2);
$test_utils->set_target_banner_strategy($target_id2, $pick_second_strategy_name);

$banner_oid = $test_utils->create_banner($target_id2, $banner_url, $banner_prob);
my $banner_url2 = 'new url';
my $banner_oid2 = $test_utils->create_banner($target_id2, $banner_url2, $banner_prob);

#===Data for test with one banner and pick second banner strategy===
my $target_id3 = 'target od 3';
my $target_name3 = 'target_name 3';

my $target_oid3 = $test_utils->create_target($target_id3, $target_name3);
$test_utils->set_target_banner_strategy($target_id3, $pick_second_strategy_name);

$banner_oid2 = $test_utils->create_banner($target_id3, $banner_url, $banner_prob);


my $impression_statistics = my $mock = Test::MockObject->new();
$impression_statistics->set_true( 'register_impression_stat' );
#==================DEFINE TEST========================
#if strategy is not set, pick first one banner and go on
sub test_without_strategies(){
    my $impression_obj = Impressions::Impression->new({
                    'database' => $test_database,
                    'banners_strategies' => {},
                    'impression_registrar' => $impression_statistics,
                }); 
	my $returned_url = $impression_obj->get_banner_url($target_id);	
	ok($returned_url eq $banner_url, 'Pick first one target banner if no strategy was not set');	    	
}


#test with random strategy and two banners
sub test_with_pick_second_strategy_and_many_banners(){
    my $impression_obj = Impressions::Impression->new({
                    'database' => $test_database,
                    'banners_strategies' => {
                    	$random_strategy_name => Impressions::BannersStrategies::PickSecondStrategy->new(),
                    	$pick_second_strategy_name => Impressions::BannersStrategies::PickSecondStrategy->new(),
                    },
                    'impression_registrar' => $impression_statistics,
                }); 
    my $returned_url = $impression_obj->get_banner_url($target_id2); 
    ok($returned_url eq $banner_url2, 'Pick second banner banner with pick_second_banner strategy');
}

#case when strategy can-not pick one banner
sub test_pick_no_banners_case(){
	    my $impression_obj = Impressions::Impression->new({
                    'database' => $test_database,
                    'banners_strategies' => {
                        $random_strategy_name => Impressions::BannersStrategies::PickSecondStrategy->new(),
                        $pick_second_strategy_name => Impressions::BannersStrategies::PickSecondStrategy->new(),
                    },
                    'impression_registrar' => $impression_statistics,
                }); 
    my $returned_url = $impression_obj->get_banner_url($target_id3); 
    ok($returned_url eq '', 'Return empty string if banner can not be found');
}

#==================RUN TEST========================
test_without_strategies();
test_with_pick_second_strategy_and_many_banners();
test_pick_no_banners_case();

$test_utils->clear_collections();#clear dataset after testing
