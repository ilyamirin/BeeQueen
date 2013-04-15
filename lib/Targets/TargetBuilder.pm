package Targets::TargetBuilder;

use warnings;
use strict;

use Moo;
use Targets::Target;

=pod
=head1 Targets::TargetBuilder
Builder for target dataholder
=cut

has 'id' => (
	is => 'rw',
);

has 'name' => (
	is => 'rw',
);

has 'banners_ids' => (
	is => 'rw'
);


has 'banners_strategy' => (
	is => 'rw'
);

sub clear_builder(){
	my($self) = @_;
	$self->id = 0;
	$self->name = 0;
	$self->banners_ids = 0;
	$self->banner_strategy = 0;
	
	return $self;
}

sub fill_builder_with_target(){
	my ($self, $target) = @_;
	
	$self->id = $target->get_id();
	$self->name = $target->get_name();
	$self->banners_ids = $target->get_banners_ids();
	$self->banner_strategy = $target->get_banner_strategy();
	
	return $self;
}

sub build(){
	my ($self) = @_;
	my $target = new Targets::Target({
		'id'=> $self->id,
		'name' => $self->name,
		'banners_ids' => $self->banners_ids,
		'banner_strategy' => $self->banner_strategy, 
	});
	
	return $target;
}

sub set_id(){
	my ($self, $id) = @_;
	$self->id = $id;
	return $self;
}
sub set_name(){
	my ($self, $name) = @_;
	$self->name = $name;
	return $self;
}
sub set_banners_ids(){
	my ($self, $banners_ids) = @_;
	$self->banners_ids = $banners_ids;
	return $self;
}
sub set_banners_strategy(){
	my ($self, $banner_strategy) = @_;
	$self->banner_strategy = $banner_strategy;
	return $self;
}

1;