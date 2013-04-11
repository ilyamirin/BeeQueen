package Impressions::ImpressionStatistics;

use strict;
use warnings;
use Moo;

use constant DAY_STAT_COLLECTION_NAME =>'imp_dayly_stat';
use constant MONTH_STAT_COLLECTION_NAME => 'imp_dayly_stat';
use constant HOUR_STAT_COLLECTION_NAME => 'imp_dayly_stat';

has 'database' => (is => 'ro');

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
	my $hour_status = $self->__update_hour_stat($target_id, $banner_id);
	my $day_status = $self->__update_day_stat($target_id, $banner_id);
	my $week_status = $self->__update_month_stat($target_id, $banner_id);
}

sub __update_month_stat(){
	my ($self, $target_id, $banner_id) = @_;
    my $month_collection = $self->database->get_collection(MONTH_STAT_COLLECTION_NAME);
    my $status = $month_collection->update({'target_id' => $target_id, 'banner_id' => $banner_id},
                                {'$inc' => {'count' => 1}},
                                {'upsert' => 1}
                            );
    return $status;   
}

sub __update_day_stat(){
	my ($self, $target_id, $banner_id) = @_;
	my $day_collection = $self->database->get_collection(DAY_STAT_COLLECTION_NAME);
    my $status = $day_collection->update({'target_id' => $target_id, 'banner_id' => $banner_id},
                                {'$inc' => {'count' => 1}},
                                {'upsert' => 1}
                            );
    return $status;
}

sub __update_hour_stat(){
	my ($self, $target_id, $banner_id) = @_;
	my $hour_collection = $self->database->get_collection(MONTH_STAT_COLLECTION_NAME);
    my $status = $hour_collection->update({'target_id' => $target_id, 'banner_id' => $banner_id},
                                {'$inc' => {'count' => 1}},
                                {'upsert' => 1}
                            );
    return $status;
}


1;