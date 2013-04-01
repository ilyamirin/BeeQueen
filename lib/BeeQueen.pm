package BeeQueen;

#use lib 'lib'
use Mojo::Base 'Mojolicious';
use Mojolicious::Plugin::Mongodb;

=head3 
This class is the entry point to CAP provider 
=cut

=head3 
Initialyse application 
=cut 
  
  sub startup {
	my $self = shift;
	$self->plugin(
		'mongodb',
		{
			host   => 'localhost',
			port   => 27017,
			helper => 'mongo',
		}
	);
}

1;
