use Test::Simple tests=> 8;
use warnings;
use strict;


use Events::EventsService; 

use MongoDB;
use MongoDB::MongoClient;
use MongoDB::OID;
use TestUtils::TestUtilsMongo;


my $mongo = MongoDB::MongoClient->new;
my $test_database = $mongo->get_database('test');

#==================PREPARE DATA====================
my $test_utils = TestUtils::TestUtilsMongo->new({'database' => $test_database});

$test_utils->clear_collections();#clear dataset before testing

my $event_name = "fancy event _name";
my $event_oid = $test_utils->create_event_description($event_name);
my $event_id = $event_oid->to_string();

my $banner_url = 'fancy banner url';
my $banner_prob = 0.2;
my $redirect_url = 'redirect url';
my $target_name = "target_name";
my $target_oid = $test_utils->create_target($target_name);
my $target_id = $target_oid->to_string();
my $banner_oid = $test_utils->create_banner($target_id, $banner_url, $banner_prob, $redirect_url);
my $banner_id = $banner_oid->to_string();

#==================DEFINE TEST========================
sub test_register_event(){
    my $events_service = Events::EventsService->new({'database' => $test_database});
    my $user_id = 'user_id_';
    foreach my $update_couner (1..4){
        my $user_id_iter = $user_id . $update_couner;
        my $status = $events_service->register_event($event_id, $banner_id, $user_id_iter);
        ok($status == 1, "Status ok");
    }
    my @events = $events_service->find_by_event($event_id);
    ok(@events == 4, 'Event statistics size is ok');
    ok(index($events[0]->{'user_id'}, $user_id) >= 0, 'User was registred');
    ok($events[0]->{'event_id'} eq $event_id, 'event id was registred');
    ok($events[0]->{'banner_id'} eq $banner_id, 'banner was registred');
}

#==================RUN TEST========================
test_register_event();
$test_utils->clear_collections();#clear dataset after testing

1;