package BeeQueen;

#use lib 'lib'
use Mojo::Base 'Mojolicious';
use Mojolicious::Plugin::Mongodb;

use File::Basename;
my $dirname = dirname(__FILE__);

=head3 
This class is the entry point to CAP provider 
=cut

=head3 
Initialyse application 
=cut 
  
  sub startup {
	my $self = shift;
	
	my $current_working_directory  = dirname(__FILE__);

	my $config = $self->plugin('Config', 
		{
			file => $current_working_directory . "/../conf/bee_queen.conf"
		});
	
	$self->plugin(
		'mongodb',
		{
			host   => $config->{'host'},
			port   => $config->{'port'},
			helper => 'mongo',
		}
	);
	
	
}



1;
