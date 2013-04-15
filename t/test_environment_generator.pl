#!/usr/bin/perl 

=pod
=head1 SIPNOPSYS
This script goal is to initiate some data in a database in order to perform
interface and load testing. 
=cut

use strict;
use warnings;

use MongoDB;
use TestUtils::TestUtilsMongo;

my $mongo         = MongoDB::MongoClient->new;
my $test_database = $mongo->get_database('development');

my $test_utils =
  TestUtils::TestUtilsMongo->new( { 'database' => $test_database } );
$test_utils->clear_collections();    #clear dataset before testing

my $target_id   = 'target_id_1';
my $target_name = 'target name simple';
my $target_oid  = $test_utils->create_target( $target_id, $target_name );

foreach my $banners_iter ( 1 .. 25 ) {

	my $random_strategy_name      = 'random';
	my $pick_second_strategy_name = 'pick_second';

	my $banner_url  = 'fancy banner url' . $banners_iter;
	my $banner_prob = 0.2;
	my $banner_oid =
	  $test_utils->create_banner( $target_id, $banner_url, $banner_prob );

}
