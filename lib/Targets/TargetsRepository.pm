package Targets::TargetsRepository;

use warnings;
use strict;

use Moo;

=pod
=head1 Targets::TargetsRepositiry
This class will provide access to targets

=cut

has 'connection' => (is => 'ro',);

our $TARGETS_COLLECTION_NAME = 'targets';

sub getTargetById(){
	my ($self, $id) = @_;
	
	$self->connection
}