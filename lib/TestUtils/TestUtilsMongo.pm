package TestUtils::TestUtilsMongo;

use Moo;

use MongoDB;
use MongoDB::MongoClient;
use MongoDB::OID;
use Impressions::ImpressionStatistics;
use Impressions::Impression;
use Clicks::ClicksService;
use Events::EventsService;
=pod
=head1 TestUtils::TestUtilsMongo
This module is just set of procedures that can help to create test entities in database
=cut

 #database handler
 has 'database' => (is => 'ro',);
 
############################################
# Usage      : $test_utils->clear_colelctions()
# Purpose    : This funciton drops collections for targets and banners
# Returns    : none
# Parameters : none 
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
 sub clear_collections(){
 	my ($self) = @_;
 	my $targets_collection = $self->database->get_collection(Impressions::Impression::TARGET_COLLECTION_NAME);
 	$targets_collection->drop();
 	my $targets_bundles_collection = $self->database->get_collection(Impressions::Impression::TARTGET_BUNDLE_COLLECTION_NAME);
 	$targets_bundles_collection->drop();
 	my $banners_collection = $self->database->get_collection(Impressions::Impression::BANNERS_COLLECTION_NAME);
 	$banners_collection->drop();
 	my $impressions_collection = $self->database->get_collection(Impressions::ImpressionStatistics::IMPR_STAT_NAME_COLLECTION_NAME);
 	$impressions_collection->drop();
 	my $clicks_collection = $self->database->get_collection(Clicks::ClicksService::CLICKS_COLLECTION_NAME);
 	$clicks_collection->drop();
 	my $events_desc_collection = $self->database->get_collection(Events::EventsService::EVENTS_DESCRIPTION_COLLECTION_NAME);
 	$events_desc_collection->drop();
 	my $events_collection = $self->database->get_collection(Events::EventsService::EVENTS_COLLECTION_NAME);
 	$events_collection->drop();
 	
 }
 
############################################
# Usage      : $target_oid = $test_utils->create_target($target_name)
# Purpose    : Crates target in mongo db with given name
# Returns    : target OID
# Parameters : target name - label of this target 
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
 sub create_target(){
 	my ($self, $target_name) = @_;
 	my $targets_collection = $self->database->get_collection(Impressions::Impression::TARGET_COLLECTION_NAME);
 	my $target_oid = $targets_collection
 						->save({'target_name' => $target_name });
 	return $target_oid;
 }

############################################
# Usage      : $bundle_oid = $test_utils->create_target_bundle($bundle_name)
# Purpose    : Crates description for targets bundle in a mongo db with given name
# Returns    : bundle OID
# Parameters : bundle name - label of this targts bundle 
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a 
 sub create_target_bundle(){
 	my ($self, $target_bundle_name) = @_;
    my $targets_collection = $self->database->get_collection(Impressions::Impression::TARTGET_BUNDLE_COLLECTION_NAME);
    my $bundle_oid = $targets_collection
                        ->save({'name' => $target_bundle_name });
    return $bundle_oid;
 }

 ############################################
# Usage      : $test_utils->tie_targets_to_bundle($targets_bundle_oid, \@targets_oids)
# Purpose    : Tie targets to target bundle by setting property
# Returns    : none
# Parameters : MongoDB::OID targets bundle oid, 
#               array reference to targets oids - reference to an array of targets bundles 
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
 sub tie_targets_to_bundle(){
 	my ($self, $bundle_oid, $targets_aref) = @_;
 	my $targets_collection = $self->database->get_collection(Impressions::Impression::TARGET_COLLECTION_NAME);
    my $status = $targets_collection->update({'_id' => {'$in' => $targets_aref} }, 
                                {
                                	'$push' => {'target_bundles' => $bundle_oid}
                                });
    return $status;                            
 }

############################################
# Usage      : $test_utils->create_banner($target_id, $banner_url, $banner_prob, $redirect_url)
# Purpose    : Creates banner in database and adds it to a given target
# Returns    : banner OID
# Parameters : target id - id of target as a sting, 
#               banner url - label of this target
#               probability of given banner - number
#               redirect_url - url to redirect user after click on this banner 
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub create_banner(){
	my ($self, $target_id, $banner_url, $banner_prob, $redirect_url) = @_;
 	my $banners_collection = $self->database->get_collection(Impressions::Impression::BANNERS_COLLECTION_NAME);
 	my $banner_oid = $banners_collection
 					->insert({ 'url' => $banner_url, 
 						'prob' => $banner_prob,
 						'redirect_url' => $redirect_url
 						 });
 	print "Banner oid: $banner_oid\n";
 	my $targets_collection = $self->database->get_collection(Impressions::Impression::TARGET_COLLECTION_NAME);
 	$targets_collection->update({'_id' => MongoDB::OID->new('value' => $target_id)}, 
 								{'$push' => {'banners' => $banner_oid}});
 	return $banner_oid;
}

############################################
# Usage      : $test_utils->set_target_banner_strategy($target_id, $strategy_name)
# Purpose    : Set strategy name for banner
# Returns    : none
# Parameters : target id - an id of target as a sting, 
#               strategy_name - a string that represents strategy name in system 
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub set_target_banner_strategy(){
	my ($self, $target_id, $strategy_name) = @_;
	
	my $targets_collection = $self->database->get_collection(Impressions::Impression::TARGET_COLLECTION_NAME);
    $targets_collection->update({'_id' => MongoDB::OID->new('value' => $target_id)}, 
                                {'$set' => {'banner_strategy' => $strategy_name}});
}

############################################
# Usage      : $event_description_oid = $test_utils->create_event_description($event_name)
# Purpose    : Create event description object for test purposes from this object we need only 
#              oid
# Returns    : none
# Parameters : event_name - fake name for event, used just to put something miningful in database 
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub create_event_description(){
	my ($self, $event_name) = @_;
    my $events_descriptions_collection = $self->database->get_collection(Events::EventsService::EVENTS_DESCRIPTION_COLLECTION_NAME);
    my $event_description_oid = $events_descriptions_collection
                        ->save({'name' => $event_name });
    return $event_description_oid;
}

1;

