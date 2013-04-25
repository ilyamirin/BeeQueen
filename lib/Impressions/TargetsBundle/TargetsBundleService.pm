package Impressions::TargetsBundle::TargetsBundleService;

=pod
=head1 Impressions::TargetsBundle::TargetsBundleService
Class to present information for targets bundles.
=cut


use strict;
use warnings;

use Moo;
use MongoDB::OID;
use Impressions::Impression;

#database handler
has 'database' => (is => 'ro',);
#banners_strategies hash reference {'banner_strategy_name' => $banners_strategy}
has 'impression_service' => (is => 'ro');


############################################
# Usage      : $bundle_banners = get_bundle_banners($target_bundle_id, $user_id);
# Purpose    : get banner information fot full bundle of targets
# Returns    : Hash {target_id => banner_info}
# Parameters : target_bundle_id - id of target bundle to get banners info for
#              user_id - id of an user, this is optional parameter and can
#              be ommited in some cercumstancess
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub get_bundle_banners(){
	my ($self, $targets_bundle_id, $user_id) = @_;
	
	my $targets_collection = $self->database->get_collection( Impressions::Impression::TARGET_COLLECTION_NAME );#obtain targets collection
    my $targets_cursor = $targets_collection->find({
    	'target_bundles' => MongoDB::OID->new('value' => $targets_bundle_id)});
    my %targets_banners_map = ();
    while(my $target = $targets_cursor->next ){
    	my $target_oid = $target->{'_id'};
    	my $target_id = $target_oid->to_string();
    	my $banner_info = $self->impression_service->get_banner_url($target_id, $user_id);
    	$targets_banners_map{$target_id} = $banner_info;
    }
    
    return %targets_banners_map;
} 

1;