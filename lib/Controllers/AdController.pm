package Controllers::AdController;
use Moose;
use JSON qw(encode_json);

has impression_service => (
    'is' => 'ro',
    'isa' => 'Impressions::Impression',
    
);



sub impression() {
      my ($self, $request) = @_;

      my $target_id = $request->param('target_id') || '';
      my $user_id = $request->param('user_id') || '';
      
      #my $impression_service = $self->get_bean('impression_service');
      my %banner_info = $self->impression_service->get_banner($target_id, $user_id);
      # $self->render(json => \%banner_info );
      return encode_json(\%banner_info);      
} 
     
sub impression_bundle(){
      my ($self, $request) = @_;

      my $bundle_id = $request->param('bundle_id') || '';
      my $user_id = $request->param('user_id') || '';
      
      #my $impression_service = $self->get_bean('impression_service');
      my %bundle_data = $self->impression_service->get_bundle_banners($bundle_id, $user_id);
      return encode_json(\%bundle_data);       
}
     
     $r->any('/click' => sub {
      my $self = shift;
      
      my $banner_id = $self->param('banner_id');
      if($banner_id){
          my $target_id = $self->param('target_id') || '';
          my $user_id = $self->param('user_id') || '';
          
          my $clicks_service = $self->get_bean('clicks_service');
          my $redirect_url = $clicks_service->process_click($target_id, $banner_id, $user_id);
          $self->redirect_to($redirect_url); 
      }else{
        $self->render(text => 'No banner id');
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

