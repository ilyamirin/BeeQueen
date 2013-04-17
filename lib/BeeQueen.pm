package BeeQueen;

use lib './lib';
use Mojo::Base 'Mojolicious';
use Mojolicious::Plugin::BeamWire;

use File::Basename;

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
    });	
     
     $r->any('/click' => sub {
      my $self = shift;
      
      my $banner_id = $self->param('banner_id');
      if($banner_id){
	      my $target_id = $self->param('target_id') || '';
	      my $user_id = $self->param('user_id') || '';
	      
	      my $clicks_service = $self->get_bean('clicks_service');
	      my $redirect_url = $clicks_service->process_click($target_id, $banner_id, $user_id);
#	      $self->redirect_to($redirect_url); 
          $self->render(json => {
            'redirect_url' => $redirect_url, 
          });       
      }    
    });	
}



1;
