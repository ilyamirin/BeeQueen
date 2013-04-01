package BeeQueen;

#use lib 'lib'
use Mojo::Base 'Mojolicious';
use Mojolicious::Plugin::Mongodb;

use Cwd ( 'abs_path', 'getcwd' );

=head3 
This class is the entry point to CAP provider 
=cut

=head3 
Initialyse application 
=cut 
  
  sub startup {
	my $self = shift;
	
	my $current_working_directory = getcwd();
	my $config = $self->plugin->register(Mojolicious->new, 
		{
			file => $current_working_directory . "/../conf"
		});
	
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
