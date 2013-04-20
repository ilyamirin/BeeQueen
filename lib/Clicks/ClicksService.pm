package Clicks::ClicksService;

use strict;
use warnings;
use Moo;
use Impressions::Impression;
use MongoDB::OID;
=pod
=head1 Clicks::ClicksService
This class will deal with clicks transactions. It will receive information about click action 
and store it in database
=cut

 #database handler
 has 'database' => (is => 'ro',);
 
use constant CLICKS_COLLECTION_NAME => 'clicks';
 

#########################################################################
# Usage      : $status = process_click($target_id, $banner_id, $user_id);
# Purpose    : get banner redirect url and insert information about click into database
# Returns    : url to redirect user to 
# Parameters : target_id - id of a target
#               banner_id - id of a banner
#               user_id - id of an user 
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub process_click(){
    my ($self, $target_id, $banner_id, $user_id) = @_;
    
    my $redirect_url = $self->__find_url_to_redirect_for_banner($banner_id);
    my $status = $self->__register_click($target_id, $banner_id, $user_id);
    return $redirect_url;      
}


#########################################################################
# Usage      : @cliks = find_by_target_banner($target_id, $banner_id);
# Purpose    : get all clicks records in database by target and banner ids
#              initally this method is targeted to be used only in tests 
# Returns    : array of hashes ({target_id => '', banner_id, user_id, time}, ...) 
# Parameters : target_id - id of target
#               banner_id - id of banner 
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub find_by_target_banner(){
	my ($self, $target_id, $banner_id) = @_;
    
    my $clicks_collection = $self->database->get_collection(CLICKS_COLLECTION_NAME);
    my @clicks = $clicks_collection->find({
        'target_id' => $target_id,
        'banner_id' => $banner_id
    })->all();
    
    return @clicks;
}

#########################################################################
# Usage      : $status = __register_click($target_id, $banner_id, $user_id);
# Purpose    : insert information about click into database
# Returns    : operation status 1 if ok and 0 otherwise 
# Parameters : target_id - id of a target
#               banner_id - id of a banner
#               user_id - id of an user 
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub __register_click(){
	my ($self, $target_id, $banner_id, $user_id) = @_;
    
    my $clicks_collection = $self->database->get_collection(CLICKS_COLLECTION_NAME);
    my $status = $clicks_collection->insert({
        'target_id' => $target_id, 
        'banner_id' => $banner_id,
        'user_id' => $user_id,
        'time' => time()
    });
    return $status;
}

#########################################################################
# Usage      : $url_to_redirect = __find_url_to_redirect_for_banner($banner_id);
# Purpose    : get url to redirect user it for a particular banner
# Returns    : string for full url to redirect (http://some.domain/route) 
# Parameters : banner_id - id of a banner
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub __find_url_to_redirect_for_banner(){
	my ($self, $banner_id) = @_;
	
    my $banners_collection = $self->database->get_collection(Impressions::Impression::BANNERS_COLLECTION_NAME);
    my $banner_oid = MongoDB::OID->new('value' => $banner_id);
    my $banner = $banners_collection->find_one({_id => $banner_oid});
    my $redirect_url = "";
    if($banner){    	
    	$redirect_url = $banner->{'redirect_url'};
    }	
    
    return $redirect_url;
}


1;