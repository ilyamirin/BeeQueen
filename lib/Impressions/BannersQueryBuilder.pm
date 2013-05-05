package Impressions::BannersQueryBuilder;

=pod
=head1 Impressions::BannersQueryBuilder
This module provided ability to build different kind of querys for banners 
extraction, depending on input parameters.
=head2 Example
 $query_builder = Impressions::BannersQueryBuilder->new;
 $query = $query_builder->clear_builder
                ->set_target_banners($target->{banners})
                ->build();
=cut

use warnings;
use strict;
use Moo;

#oid of given target banners
has 'target_banners_oids' => (is => 'rwp');



############################################
# Usage      : $query = $query_builder->build()
# Purpose    : get resulted query from builder parameters
# Returns    : hash reference that can be used as query for mongo db
#               {'target_id' => '1231231kjlkjl1323', 'geo' => 'GB'}
# Parameters : none
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub build(){
	my ($self) = shift;
	
	my %query = ();
	if(defined $self->target_banners_oids){
		$query{'_id'} = { '$in' => $self->target_banners_oids};
	}
	
	return \%query;
}


############################################
# Usage      : $query = $query_builder->clear_builder()
# Purpose    : returns builder state to initial state.
# Returns    : $self - this object.
# Parameters : none
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub clear_builder(){
    my ($self) = shift;
    
    $self->target_banners_oids = undef;
    
    return $self;	
}

############################################
# Usage      : $query = $query_builder->set_target_banners($target->{'banners'})
# Purpose    : set target banners
# Returns    : $self - this object.
# Parameters : target banners oid array
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub set_target_banners(){
	my ($self, $target_banners) = @_;
	
	$self->set_target_banners_oids($target_banners);
	
	return $self;
}

1;
