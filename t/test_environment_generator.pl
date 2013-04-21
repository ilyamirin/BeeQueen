#!/usr/bin/perl 

=pod
=head1 SIPNOPSYS
This script goal is to initiate some data in a database in order to perform
interface and load testing. 
=cut

use strict;
use warnings;

use MongoDB;
use Beam::Wire;
use File::Basename;
use TestUtils::TestUtilsMongo;


my $current_working_directory  = dirname(__FILE__);
my $beans_file = $current_working_directory . "/../conf/beans.yml";

my $wire  = Beam::Wire->new( {'file' => $beans_file} );

my $test_database = $wire->get('test_database');

my $test_utils =
  TestUtils::TestUtilsMongo->new( { 'database' => $test_database } );
$test_utils->clear_collections();    #clear dataset before testing

my $target_name = 'target name simple';
my $random_strategy_name = 'random';
my $target_oid  = $test_utils->create_target($target_name );
my $target_id   = $target_oid->to_string();
print "Target ID $target_id\n";
$test_utils->set_target_banner_strategy($target_id, $random_strategy_name);

foreach my $banners_iter ( 1 .. 25 ) {

	my $random_strategy_name      = 'random';
	my $pick_second_strategy_name = 'pick_second';

	my $banner_url  = 'fancy banner url' . $banners_iter;
	my $banner_prob = 0.2;
	my $banner_redirect_url = "http://localhost/";
	my $banner_oid =
	  $test_utils->create_banner( $target_id, $banner_url, $banner_prob, $banner_redirect_url );

}
