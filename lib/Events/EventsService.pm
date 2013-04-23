package Events::EventsService;

use strict;
use warnings;
use Moo;
use MongoDB::OID;
=pod
=head1 Events::EventsService
This class only purpose is to register data about event into database
=cut

 #database handler
 has 'database' => (is => 'ro',);
 
use constant EVENTS_COLLECTION_NAME => 'events';
use constant EVENTS_DESCRIPTION_COLLECTION_NAME => 'events_desciption'; 

#########################################################################
# Usage      : $status = register_event($event_id,$banner_id, $user_id);
# Purpose    : register event in database
# Returns    : status of operation 1 if success and 0 otherwise 
# Parameters : event_id - id of a target
#              user_id - id of an user 
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub register_event(){
    my ($self, $event_id, $banner_id, $user_id) = @_;
    
    my $events_collection = $self->database->get_collection(EVENTS_COLLECTION_NAME);
    my $event_oid = $events_collection->insert({
        'event_id' => MongoDB::OID->new('value' => $event_id), 
        'banner_id' => MongoDB::OID->new('value' => $banner_id),
        'user_id' => $user_id,
        'time' => time()
    });
    return 1;      
}

#########################################################################
# Usage      : @cliks = $events_service->find_by_event($event_id);
# Purpose    : get all events records from collection by event id
#              initally this method is targeted to be used only in tests 
# Returns    : array of hashes ({event_id => '', banner_id => 'sdf', user_id => , time}, ...) 
# Parameters : event_id - id of an event 
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub find_by_event(){
    my ($self, $event_id) = @_;
    
    my $events_collection = $self->database->get_collection(EVENTS_COLLECTION_NAME);
    my @clicks = $events_collection->find({
        'event_id' => MongoDB::OID->new('value' => $event_id),
    })->all();
    
    return @clicks;
}


1;
