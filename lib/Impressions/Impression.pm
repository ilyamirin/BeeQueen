package Impressions::Impression;

use strict;
use warnings;

use Moo;


 has 'connection' => (
    is => 'ro',   
 );

 
 sub getBanner(){
 	my ($self, $target_id, $user_id) = @_;
 	
 	$self->
 }