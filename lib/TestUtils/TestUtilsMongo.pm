package TestUtils::TestUtilsMongo;

use Moo;

use MongoDB;
use MongoDB::MongoClient;
use MongoDB::OID;
use Impressions::ImpressionStatistics;
use Impressions::Impression;
use Clicks::ClicksService;
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
 	my $banners_collection = $self->database->get_collection(Impressions::Impression::BANNERS_COLLECTION_NAME);
 	$banners_collection->drop();
 	my $impressions_collection = $self->database->get_collection(Impressions::ImpressionStatistics::IMPR_STAT_NAME_COLLECTION_NAME);
 	$impressions_collection->drop();
 	my $clicks_collection = $self->database->get_collection(Clicks::ClicksService::CLICKS_COLLECTION_NAME);
 	$clicks_collection->drop();
 	
 }
 
############################################
# Usage      : $test_utils->create_target($target_id, $target_name)
# Purpose    : Crates target in mongo db with given id and name
# Returns    : target OID
# Parameters : target id - id of target as a sting, target name - label of this target 
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
 sub create_target(){
 	my ($self, $target_name) = @_;
 	my $targets_collection = $self->database->get_collection('targets');
 	my $target_oid = $targets_collection
 						->save({'target_name' => $target_name });
 	return $target_oid;
 }

############################################
# Usage      : $test_utils->create_banner($target_id, $banner_url, $banner_prob)
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
 	my $banners_collection = $self->database->get_collection('banners');
 	my $banner_oid = $banners_collection
 					->insert({ 'url' => $banner_url, 
 						'prob' => $banner_prob,
 						'redirect_url' => $redirect_url
 						 });
 	print "Banner oid: $banner_oid\n";
 	my $targets_collection = $self->database->get_collection('targets');
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
	
	my $targets_collection = $self->database->get_collection('targets');
    $targets_collection->update({'_id' => MongoDB::OID->new('value' => $target_id)}, 
                                {'$set' => {'banner_strategy' => $strategy_name}});
}

1;

