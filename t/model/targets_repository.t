use Test::Simple tests=> 1;
use warnings;
use strict;

use lib '../../lib';

use Targets::TargetsRepository;
use Targets::TargetBuilder;

use MongoDB;
use MongoDB::MongoClient;
use MongoDB::OID;

my $mongo = MongoDB::MongoClient->new;
my $test_database = $mongo->get_database('test');

my $target_builder = Targets::TargetBuilder->new();
my $target_repoditory = Targets::TargetsRepository->new({
	'database' => $test_database,
	'target_builder' => $target_builder, 
});


my $target = $target_repoditory->getTargetById(1);
ok($target == 0, 'Find nothing it is okey');