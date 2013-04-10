package Impressions::ImpressionStatistics;

use strict;
use warnings;
use Moo;

use constant DAY_STAT_COLLECTION_NAME = 'imp_dayly_stat';
use constant MONTH_STAT_COLLECTION_NAME = 'imp_dayly_stat';
use constant HOUR_STAT_COLLECTION_NAME = 'imp_dayly_stat';


#########################################################################
# Usage      : $status = update_impression_stat($target_id, $banner_id);
# Purpose    : update banner statistics for given target
# Returns    : operation status 1 if ok and 0 otherwise 
# Parameters : target_id - id of target
#               banner_id - id of banner 
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub update_impression_stat(){
	my ($self, $target_id, $banner_id) = @_;
}

1;