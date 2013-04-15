package Misc::MongoDatabase;

use Moo;


sub get_database(){
	my ($self, $mongo_client, $database_name) = @_; 
	return $mongo_client->get_database($database_name);
}
1;