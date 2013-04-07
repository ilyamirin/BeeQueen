package TestUtils::TestUtilsMongo;

use Moo;

use MongoDB;
use MongoDB::MongoClient;
use MongoDB::OID;


 #database handler
 has 'database' => (is => 'ro',);
 
 sub create_target(){
 	my ($self, $target_id, $target_name) = @_;
 	my $targets_collection = $self->database->get_collection('targets');
 	my $target_oid = $targets_collection
 						->insert({ 'target_id' => $target_id, 'target_name' => $target_name });
 	return $target_oid;
 }

sub create_banner(){
	my ($self, $target_id, $banner_url, $banner_prob) = @_;
 	my $banners_collection = $self->database->get_collection('banners');
 	my $banner_oid = $banners_collection
 					->insert({ 'url' => $banner_url, 'prob' => $banner_prob });
 	
 	my $targets_collection = $self->database->get_collection('targets');
 	$targets_collection->update({'target_id' => $target_id}, 
 								{'$push' => {'banners' => $banner_oid}});
 	return $banner_oid;
}

1;

