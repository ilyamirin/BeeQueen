package Clicks::ClicksService;

use strict;
use warnings;

use Moo;

=pod
=head1 Clicks::ClicksService
This class will deal with clicks transactions. It will receive information about click action 
and store it in database
=cut

 #database handler
 has 'database' => (is => 'ro',);
 
use constant CLICKS_COLLECTION_NAME => 'clicks';
 

#########################################################################
# Usage      : $status = register_click($target_id, $banner_id, $user_id);
# Purpose    : insert information about click into database
# Returns    : operation status 1 if ok and 0 otherwise 
# Parameters : target_id - id of a target
#               banner_id - id of a banner
#               user_id - id of an user 
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub register_click(){
    my ($self, $target_id, $banner_id, $user_id) = @_;
    
    my $impressions_collection = $self->database->get_collection(CLICKS_COLLECTION_NAME);
    my $status = $impressions_collection->insert({
        'target_id' => $target_id, 
        'banner_id' => $banner_id,
        'user_id' => $user_id,
        'time' => time()
    });
    return $status;   
    
}

1;