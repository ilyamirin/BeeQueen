use TAP::Harness;

use MongoDB;
use MongoDB::MongoClient;
use MongoDB::OID;

my %args = (
    verbosity => 1,
    lib     => [ 'lib', '../lib','blib/lib', 'blib/arch' ],
 );
 my $harness = TAP::Harness->new( \%args );
 
 
 ################Prepare some data#################
 
 
 my @tests = ('model/impressions.t', 'model/impression_statistics.t');
 $harness->runtests(@tests);
 
 