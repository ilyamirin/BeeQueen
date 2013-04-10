package BeeQueen;

use lib './lib';
use Mojo::Base 'Mojolicious';
use Mojolicious::Plugin::BeamWire;

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
    
    $self->plugin('BeamWire',
        {
        	'beans_conf' => $current_working_directory . "/../conf/beans.yml"
        }
    );
    
    my $r = $self->routes;
    
     $r->any('/impression' => sub {
      my $self = shift;

      my $target_id = $self->param('target_id') || '';
      my $user_id = $self->param('user_id') || '';
      
      my $impression_service = $self->get_bean('impression_service');
      my $target_url = $impression_service->get_banner_url($target_id, $user_id);
      $self->render(json => {
      	url => $target_url, 
      });      
    } => 'index');	
}



1;
