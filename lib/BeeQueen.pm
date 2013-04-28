package BeeQueen;

use lib './lib';
use Mojo::Base 'Mojolicious';
use Mojolicious::Plugin::BeamWire;

use File::Basename;

=head3 
This class is the entry point to CAP provider 
=cut

my $BEANS_CONF_PATH = "/../conf/beans.yml";

sub testing_mode(){
	my $self = shift;
	$BEANS_CONF_PATH = "/../conf/beans_test.yml";
}

=head3 
Initialyse application 
=cut   
  sub startup {
	my $self = shift;
	
	my $current_working_directory  = dirname(__FILE__);
    
    $self->plugin('BeamWire',
        {
        	'beans_conf' => $current_working_directory . $BEANS_CONF_PATH,
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
     
     $r->any('/impression/bundle' => sub {
      my $self = shift;

      my $bundle_id = $self->param('bundle_id') || '';
      my $user_id = $self->param('user_id') || '';
      
      my $impression_service = $self->get_bean('impression_service');
      my %bundle_data = $impression_service->get_bundle_banners($bundle_id, $user_id);
      $self->render(json => \%bundle_data);      
    });	
     
     $r->any('/click' => sub {
      my $self = shift;
      
      my $banner_id = $self->param('banner_id');
      if($banner_id){
	      my $target_id = $self->param('target_id') || '';
	      my $user_id = $self->param('user_id') || '';
	      
	      my $clicks_service = $self->get_bean('clicks_service');
	      my $redirect_url = $clicks_service->process_click($target_id, $banner_id, $user_id);
	      $self->redirect_to($redirect_url); 
      }    
    });	
     
     $r->any('/event' => sub {
      my $self = shift;
      
      my $event_id = $self->param('event_id');
      if($event_id){
	      my $banner_id = $self->param('banner_id') || '';
	      my $user_id = $self->param('user_id') || '';
	      
	      my $events_service = $self->get_bean('events_service');
	      my $status = $events_service->register_event($event_id, $banner_id, $user_id);
	      my $status_lit = $status ? 'ok' : 'error'; 
          $self->render(json => {
            'status' => $status_lit,            
          });       
      }    
    });	
    
    $r->any('/blankpage'=> sub {
    	my $self = shift;
        
        $self->render('json'=>{
        	'blank_page' => 'ok',
        });	
    });
}



1;
