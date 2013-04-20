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


 #database handler
 has 'database' => (is => 'ro',);
 #banners_strategies hash reference {'banner_strategy_name' => $banners_strategy}
 has 'banners_strategies' => (is => 'ro');
 #service to register impression statistics
 has 'impression_registrar' => (is => 'ro');
 
############################################
# Usage      : $url = get_banner('target_12', 'some_user_id');
# Purpose    : get bunner url depending on target and users ids and database
# Returns    : banner url
# Parameters : target_id - id of target ot get url for
#			   user_id - id of an user, this is optional parameter and can
#			   be ommited in some cercumstancess
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
 sub get_banner_url(){
 	my ($self, $target_id, $user_id) = @_;
 	
 	my $targets_collection = $self->database->get_collection( TARGET_COLLECTION_NAME );#obtain targets collection
 	my $target = $targets_collection->find_one({'_id' => MongoDB::OID->new('value' => $target_id)});
 	
 	my $url = '';
	if(defined $target){#if we have something in our output, take the doc
		#get target banners list
		my @banners_list = $self->__get_banners_list($target);
    	my $banner_pick_strategy = $target->{'banner_strategy'};
    	my $banner = $self->__pick_right_banner(\@banners_list, $banner_pick_strategy, $user_id);
    	if(defined $banner && $banner){
    		$url = $banner->{'url'};
    		$self->impression_registrar->register_impression_stat($target->{'_id'}, $banner->{'_id'}, $user_id);
    	}
	} 	
 	return $url;
 }

############################################
# Usage      : $url = __get_banners_list($target_hash_ref);
# Purpose    : get bunner list for given target
# Returns    : banners list
# Parameters : target - hash reference that contains element with key 'banners' 
# Throws     : no exceptions
# Comments   : ???
# See Also   : get_banner function
 sub __get_banners_list(){
 	my ($self, $target) = @_;
 	my @banners = ();
 	if(exists($target->{'banners'})){
	 	my $banners_query = { '_id' => { '$in' => $target->{ 'banners' } } };
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
 