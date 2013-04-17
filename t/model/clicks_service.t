use Test::Simple tests=> 4;
use warnings;
use strict;


use Clicks::ClicksService; 

use MongoDB;
use MongoDB::MongoClient;
use MongoDB::OID;
use TestUtils::TestUtilsMongo;


my $mongo = MongoDB::MongoClient->new;
my $test_database = $mongo->get_database('test');

#==================PREPARE DATA====================
my $test_utils = TestUtils::TestUtilsMongo->new({'database' => $test_database});

$test_utils->clear_collections();#clear dataset before testing
my $target_id = 'sdfdfs';
my $banner_url = 'fancy banner url';
my $banner_prob = 0.2;
my $redirect_url = 'redirect url';
my $banner_oid = $test_utils->create_banner($target_id, $banner_url, $banner_prob, $redirect_url);


#==================DEFINE TEST========================
sub test_test_process_click(){
    my $clicks_service = Clicks::ClicksService->new({'database' => $test_database});
    my $target_id = 'target_id_1';
    my $banner_id = 'banner_id';
    my $user_id = 'user_id_';
    foreach my $update_couner (1..4){
        my $user_id_iter = $user_id . $update_couner;
        $clicks_service->process_click($target_id, $banner_id, $user_id_iter);
    }
    my @clicks = $clicks_service->find_by_target_banner($target_id, $banner_id);
    ok(@clicks == 4, 'Clicks  size is ok');
    ok(index($clicks[0]->{'user_id'}, $user_id) >= 0, 'User was registred');
    ok($clicks[0]->{'target_id'} eq $target_id, 'target was registred');
    ok($clicks[0]->{'banner_id'} eq $banner_id, 'banner was registred');
}

#==================RUN TEST========================
test_test_process_click();
$test_utils->clear_collections();#clear dataset after testing
