use TAP::Harness;

my %args = (
    verbosity => 1,
    lib     => [ 'lib', '../lib','blib/lib', 'blib/arch' ],
 );
 my $harness = TAP::Harness->new( \%args );
 
 my @tests = ();
 $harness->runtests(@tests);