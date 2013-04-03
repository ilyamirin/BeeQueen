package Targets::TargetsRepository;

use warnings;
use strict;

use Moo;

=pod
=head1 Targets::TargetsRepositiry
This class will provide access to targets

=cut

has 'database' => (is => 'ro',);

has 'target_builder' => (is => 'ro');

our $TARGETS_COLLECTION_NAME = 'targets';

sub getTargetById(){
	my ($self, $id) = @_;
	
	my $targets_collection = $self->database->get_collection($TARGETS_COLLECTION_NAME);
	my $target_cursor = $targets_collection->find({'target_id' => $id});
	my $target = 0;
	if($target_cursor->count > 0){
		my $doc = $target_cursor->next;
		$target = $self->target_builder->clear_builder()
					->set_id($doc->{'id'})
					->set_name($doc->{'name'})
					->set_banners_ids($doc->{'banners_ids'})
					->set_banners_strategy($doc->{'banners_strategy'})
					;
		
	}
	
	return $target;
}

1;