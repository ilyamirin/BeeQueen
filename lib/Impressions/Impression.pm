package Impressions::Impression;

use strict;
use warnings;

use Moo;


 has 'database' => (is => 'ro',);
 has 'banners_strategies_hash' => (is => 'ro');
 
 our $TARGET_COLLECTION_NAME = 'targets';
 our $BANNERS_COLLECTION_NAME = 'banners';

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
 sub get_banner(){
 	my ($self, $target_id, $user_id) = @_;
 	
 	my $targets_collection = $self->database->get_collection( $TARGET_COLLECTION_NAME );#obtain targets collection
 	my $target_cursor = $targets_collection->find({'target_id' => $target_id});
 	
	if($target_cursor->count > 0){#if we have something in our output, take the doc
		my $target = $target_cursor->next;
		#get target banners list
		
    	my $banner_pick_strategy = $target->{'banner_strategy'};
	}
 	
 }

############################################
# Usage      : $url = __get_banners_list($target_hash_ref);
# Purpose    : get bunner list for given target
# Returns    : banners list
# Parameters : target - hash reference that contains element with key 'banners' 
# Throws     : no exceptions
# Comments   : ???
# See Also   : get_banner function
 sub __get_bunners_list(){
 	my ($self, $target) = @_;
 	my $banners_query = { '_id' => { '$in' => $target->{ 'banners' } } };
	my $banners_collection = $self->database->get_collection($BANNERS_COLLECTION_NAME);
    my @banners = $banners_collection->find( $banners_query )->all();
    
    return @banners;
 }
 
############################################
# Usage      : $banner = __pick_right_banner(\@banners, 'rundom_one', 'some_user_id');
# Purpose    : get bunner depending on banners strategy and factors for that strategy
# Returns    : banners list
# Parameters : target - hash that contains element with key 'banners' 
# Throws     : no exceptions
# Comments   : if no strategy would be presented I think it would be safe enough to pick first one
#				banner and return in
# See Also   : n/a
 sub __pick_right_banner(){
 	my ($self, $banners_list_ref, $banners_strategy_name,$user_id) = @_;
 	
 	
 }
 
 