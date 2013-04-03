use Test::Simple tests=> 1;
use warnings;
use strict;
use Targets::TargetsRepository;

use MongoDB::MongoClient;

my $mongo = MongoDB::MongoClient->new;
$mongo->set_database('test');

my $targetRepoditory = Targets::TargetsRepository->new($mongo);