use BeeQueenOX;
use Plack::Middleware::Profiler::NYTProf;
my $app = BeeQueenOX->new()->to_app;
#$app = Plack::Middleware::Profiler::NYTProf->wrap($app);

$app;

