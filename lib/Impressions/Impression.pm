package Impressions::Impression;

use strict;
use warnings;

use Moo;
use MongoDB::OID;

=pod
=head1 Impressions::Impression
A class to deal with impressins. Depending on input data and user defined banners 
strategies this class picks banner for given target, and saves information about it
in database.
=cut

use constant TARGET_COLLECTION_NAME => 'targets';
use constant BANNERS_COLLECTION_NAME => 'banners';
use constant TARTGET_BUNDLE_COLLECTION_NAME => 'target_bundles';

 #database handler
 has 'database' => (is => 'ro',);
 #banners_strategies hash reference {'banner_strategy_name' => $banners_strategy}
 has 'banners_strategies' => (
    'is' => 'ro',
 );
 #service to register impression statistics
 has 'impression_registrar' => (is => 'ro');
 #query builder
 has 'banners_query_builder' => (is => 'ro');
 
############################################
# Usage      : $url = get_banner('target_12', 'some_user_id', \%auxiliary_parameters);
# Purpose    : get bunner url depending on target and users ids and database
# Returns    : hash {'url' => 'banner_url', 'banner_id' => 'banner_id'}
# Parameters : target_id - id of target ot get url for
#			   user_id - id of an user, this is optional parameter and can
#			   be ommited in some cercumstancess
#              auxiliary parameters - hash reference for unnecessary parameters that can be used 
#              in banners selection process. E.g. geobinding
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
 sub get_banner(){
 	my ($self, $target_id, $user_id, $auxiliary_parameters) = @_;
 	
 	my $targets_collection = $self->database->get_collection( TARGET_COLLECTION_NAME );#obtain targets collection
 	my $target = $targets_collection->find_one({'_id' => MongoDB::OID->new('value' => $target_id)});
 	
 	my %banners_info = $self->__get_bunner_for_target($target, $user_id, $auxiliary_parameters);
 	return %banners_info;
 }


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
    
    my $targets_collection = $self->database->get_collection(TARGET_COLLECTION_NAME );#obtain targets collection
    my $targets_cursor = $targets_collection->find({
        'target_bundles' => MongoDB::OID->new('value' => $targets_bundle_id)});
    my %targets_banners_map = ();
    while(my $target = $targets_cursor->next ){
    	my %banners_info = $self->__get_bunner_for_target($target, $user_id); 
        $targets_banners_map{$target->{'_id'}->to_string()} = \%banners_info;                    
    }
    
    return %targets_banners_map;
} 

############################################
# Usage      : $bundle_banners = __get_bunner_for_target($target_id, $user_id, \%aux_params);
# Purpose    : get banner information for one trget and banner
# Returns    : Hash {url => 'banner url', 'id' => 'banner id'}
# Parameters : target_id - id of target to get banners info for
#              user_id - id of an user, this is optional parameter and can
#              be ommited in some cercumstancess
#              auxiliary parameters - hash reference for unnecessary parameters that can be used 
#              in banners selection process. E.g. geobinding
# Throws     : no exceptions
# Comments   : ???
sub __get_bunner_for_target(){
	my ($self, $target, $user_id, $auxiliary_parameters) = @_;
	my %banner_info = ();
	if(defined $target){#if we have something in our output, take the doc
        #get target banners list
        my @banners_list = $self->__get_banners_list($target, $auxiliary_parameters);
        my $banner_pick_strategy = $target->{'banner_strategy'};
        my $banner = $self->__pick_right_banner(\@banners_list, $banner_pick_strategy, $user_id);
        
        if(defined $banner && $banner){
            $banner_info{'url'} = $banner->{'url'};
            $banner_info{'id'} = $banner->{'_id'}->to_string();
            $self->impression_registrar->register_impression_stat($target->{'_id'}, $banner->{'_id'}, $user_id);
        }
    } 
    return %banner_info;  
}

############################################
# Usage      : $url = __get_banners_list($target_hash_ref);
# Purpose    : get bunner list for given target
# Returns    : banners list
# Parameters : target - hash reference that contains element with key 'banners' 
#              auxiliary parameters - hash reference for unnecessary parameters that can be used 
#              in banners selection process. E.g. geobinding
# Throws     : no exceptions
# Comments   : ???
# See Also   : get_banner function
 sub __get_banners_list(){
 	my ($self, $target, $auxiliary_parameters) = @_;
 	my @banners = ();
 	if(exists($target->{'banners'})){
	 	my $banners_query = $self->banners_query_builder->clear_builder()
	 	                           ->set_target_banners($target->{ 'banners' })
	 	                           ->build();
		my $banners_collection = $self->database->get_collection(BANNERS_COLLECTION_NAME);
	    @banners = $banners_collection->find( $banners_query )->all();
 	}
    return @banners;
 }
 
############################################
# Usage      : $banner = __pick_right_banner(\@banners, 'random_one_strategy', 'some_user_id');
# Purpose    : get bunner depending on banners strategy and factors for that strategy
# Returns    : banners list
# Parameters : target - hash that contains element with key 'banners' 
# Throws     : no exceptions
# Comments   : if no strategy would be presented I think it would be safe enough to pick first one
#				banner and return in
# See Also   : n/a
 sub __pick_right_banner(){
 	my ($self, $banners_list_ref, $banners_strategy_name,$user_id) = @_;
 	
 	
 	my $banner = 0;
 	if(defined($banners_strategy_name) && 
 	   exists( $self->banners_strategies->{$banners_strategy_name} )){
 		my $banners_strategy = $self->banners_strategies->{$banners_strategy_name};
 		$banner = $banners_strategy->pick_banner($banners_list_ref, $user_id);
 	}else{
 		if(@{$banners_list_ref} > 0){
 			$banner = @{$banners_list_ref}[0];
 		}
 	}
 	
 	return $banner;
 }
 
 1;
 