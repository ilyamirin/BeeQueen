use TAP::Harness;

use MongoDB;
use MongoDB::MongoClient;
use MongoDB::OID;
use File::Basename;

my $harness_working_directory  = dirname(__FILE__);

my %args = (
    verbosity => 1,
    lib     => [ 'lib', $harness_working_directory .'/../lib','blib/lib', 'blib/arch' ],
 );
 my $harness = TAP::Harness->new( \%args );
 
 
 ################Prepare some data#################
 
 
 my @tests = (
    $harness_working_directory . '/model/impressions.t', 
    $harness_working_directory . '/model/impression_statistics.t', 
    $harness_working_directory . '/model/clicks_service.t',
    $harness_working_directory . '/model/events_service.t',
    $harness_working_directory . '/web/rest_test.t'
 );
 $harness->runtests(@tests);
 
 