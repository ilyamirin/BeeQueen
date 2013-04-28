BEGIN {
  $ENV{MOJO_MODE}    = 'testing';
}

use Test::More;
use Test::Mojo;
use MongoDB;
use MongoDB::MongoClient;
use MongoDB::OID;
use TestUtils::TestUtilsMongo;
use BeeQueen;


my $mongo = MongoDB::MongoClient->new;
my $test_database = $mongo->get_database('test');

#==================PREPARE DATA====================
my $test_utils = TestUtils::TestUtilsMongo->new({'database' => $test_database});

$test_utils->clear_collections();#clear dataset before testing
my $target_name = 'target_name 2';
my $random_strategy_name = 'random';
my $target_oid = $test_utils->create_target($target_name);
my $target_id = $target_oid->to_string;
$test_utils->set_target_banner_strategy($target_id, $random_strategy_name);

my $banner_url = 'fancy banner url';
my $banner_prob = 0.2;
my $redirect_url = '/blankpage';
my $banner_oid = $test_utils->create_banner($target_id, $banner_url, $banner_prob, $redirect_url);

my $event_name = "fancy event _name";
my $event_oid = $test_utils->create_event_description($event_name);
my $event_id = $event_oid->to_string();

my $t = Test::Mojo->new('BeeQueen');
#=====Targets bundle==============
my $targets_bundle_oid = $test_utils->create_target_bundle('bundle name');
my @targets_oids = ($target_oid, $target_oid, $target_oid);
$test_utils->tie_targets_to_bundle($targets_bundle_oid, \@targets_oids);


#==================DEFINE TEST========================
sub test_impression(){
    $t->post_ok( '/impression' => form => 
                                { 
                                	target_id => $target_id,                                	
                                	user_id => 'some_user', 
                                	
                                } )
   ->status_is(200)
    
  ->header_is( 'X-Powered-By' => 'Mojolicious (Perl)' )
  ->json_content_is( {'url' => $banner_url} );
    
}

sub test_impression_bundle(){
	$t->post_ok( '/impression/bundle' => form => 
                                { 
                                    bundle_id => $target_id,                                    
                                    user_id => 'some_user', 
                                    
                                } )
   ->status_is(200)
    
  ->header_is( 'X-Powered-By' => 'Mojolicious (Perl)' )
  ->json_content_is( {$target_id => $banner_url} );
}

sub test_click(){
    $t->post_ok( '/click' => form => 
                                { 
                                	target_id => $target_id,
                                	banner_id => $banner_oid->to_string(),
                                	user_id => 'some_user', 
                                	
                                } )
   ->status_is(302)    
  ->header_is( 'X-Powered-By' => 'Mojolicious (Perl)' );
  
  $t->ua->max_redirects(10);
  $t->post_ok( '/click' => form => 
                                { 
                                	target_id => $target_id,
                                	banner_id => $banner_oid->to_string(),
                                	user_id => 'some_user', 
                                	
                                } )
   ->status_is(200)
    
  ->header_is( 'X-Powered-By' => 'Mojolicious (Perl)' )
  ->json_content_is( {'blank_page' => 'ok'} );
    
}

sub test_event(){
	$t->post_ok( '/event' => form => 
                                { 
                                    event_id => $event_id,
                                    banner_id => $banner_oid->to_string(),
                                    user_id => 'some_user', 
                                    
                                } )
   ->status_is(200)
    
  ->header_is( 'X-Powered-By' => 'Mojolicious (Perl)' )
  ->json_content_is( {'status' => 'ok'} );
}
#==================RUN TEST========================
test_impression();
test_impression_bundle();
test_click();
test_event();
$test_utils->clear_collections();#clear dataset after testing


done_testing();
