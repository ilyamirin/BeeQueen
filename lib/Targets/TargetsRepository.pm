package Targets::TargetsRepository;

use warnings;
use strict;

use Moo;

=pod
=head1 Targets::TargetsRepositiry
This class will provide access to targets

=cut

has 'database' => (is => 'ro',);

our $TARGETS_COLLECTION_NAME = 'targets';

sub getTargetById(){
	my ($self, $id) = @_;
	
	$self->database->get_collection($TARGETS_COLLECTION_NAME);
	
}