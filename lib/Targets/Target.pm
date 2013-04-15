package Targets::Target;

use warnings;
use strict;

use Moo;

=pod
=head1 Targets::Target
This is simple dataholder to store target information

This dataholder will have structure presented below
targets:
  - id: 23gfh3j9hf3xm8fm38yxgfm38xmbf3c
    name: Big banner with girls
    bannersIds: 1, 2, 4 (but in terms of mongo objects)
=cut

has 'id' => (
	is => 'ro',
);

has 'name' => (
	is => 'ro',
);

has 'banners_ids' => (
	is => 'ro'
);


has 'banners_strategy' => (
	is => 'ro'
);

1;