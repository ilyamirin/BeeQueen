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
my $target_id = 'target od 2';
my $target_name = 'target_name 2';
my $random_strategy_name = 'random';
my $target_oid = $test_utils->create_target($target_id, $target_name);
$test_utils->set_target_banner_strategy($target_id, $random_strategy_name);

my $banner_url = 'fancy banner url';
my $banner_prob = 0.2;
my $redirect_url = 'redirect url';
my $banner_oid = $test_utils->create_banner($target_id, $banner_url, $banner_prob, $redirect_url);


my $t = Test::Mojo->new('BeeQueen');

#==================DEFINE TEST========================
sub test_impression(){
    $t->post_ok( '/impression' => form => 
                                { 
                                	target_id => $target_id,
                                	banner_id => $banner_oid,
                                	user_id => 'some_user', 
                                	
                                } )
   ->status_is(200)
    
  ->header_is( 'X-Powered-By' => 'Mojolicious (Perl)' )
  ->header_isnt( 'X-Bender' => 'Bite my shiny metal ass!' )
  ->json_is( 'url' => $banner_url );
    
}

#==================RUN TEST========================
test_impression();
$test_utils->clear_collections();#clear dataset after testing


done_testing();
