package Impressions::BannersQueryBuilder;

=pod
=head1 Impressions::BannersQueryBuilder
This module provided ability to build different kind of querys for banners 
extraction, depending on input parameters.
=cut

use warnings;
use strict;
use Moo;

############################################
# Usage      : $query = $query_builder->build()
# Purpose    : get resulted query from builder parameters
# Returns    : hash that can be used as query for mongo db
#               {'target_id' => '1231231kjlkjl1323', 'geo' => 'GB'}
# Parameters : none
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub build(){
	
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
	
}

1;
