package Web::REST::Targets;
use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';

=head3
Controller responsible for handling actions related to targets procession
=cut

=pod
This function handles
=cut
sub show_impression(){
	my $self = shift;

    my $tartget_id = $self->param('target_id') || '';
    my $user_id = $self->param('user_id') || '';
    
    #$self->mongo->get_collection('impressions')->insert({'bar'=>'baz'});
    return 'Hello';
}

1;