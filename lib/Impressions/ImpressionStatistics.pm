package Impressions::ImpressionStatistics;

use strict;
use warnings;
use Moo;
use MongoDB::BSON;
$MongoDB::BSON::looks_like_number = 1;

use constant IMPR_STAT_NAME_COLLECTION_NAME =>'impr_stat';

has 'database' => (is => 'ro');

#########################################################################
# Usage      : $status = register_impression_stat($target_id, $banner_id, $user_id);
# Purpose    : update banner statistics for given target
# Returns    : operation status 1 if ok and 0 otherwise 
# Parameters : target_id - id of a target
#               banner_id - id of  a banner
#               user_id - id of an uesr 
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub register_impression_stat(){
	my ($self, $target_id, $banner_id, $user_id) = @_;
	
	my $impressions_collection = $self->database->get_collection(IMPR_STAT_NAME_COLLECTION_NAME);
    my $status = $impressions_collection->insert({
    	'target_id' => $target_id, 
    	'banner_id' => $banner_id,
    	'user_id' => $user_id,
    	'time' => time()
    });
    return $status;   
	
}

#########################################################################
# Usage      : $statistics = find_by_target_banner($target_id, $banner_id);
# Purpose    : get all impressions records in database by target and banner ids
#              initally this method is targeted to be used only in tests 
# Returns    : array of hashes ({target_id => '', banner_id, user_id, time}, ...) 
# Parameters : target_id - id of target
#               banner_id - id of banner 
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub find_by_target_banner(){
	my ($self, $target_id, $banner_id) = @_;
	
	my $impressions_collection = $self->database->get_collection(IMPR_STAT_NAME_COLLECTION_NAME);
	my @impressions = $impressions_collection->find({
		'target_id' => $target_id,
		'banner_id' => $banner_id
	})->all();
	
	return @impressions;
}

1;