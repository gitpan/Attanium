package MyApp1::DB::Result::Customer;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("customer");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "last_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 25,
  },
  "first_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 25,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "orders",
  "MyApp1::DB::Result::Orders",
  { "foreign.customer" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-09-15 16:05:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LaoEzc1IFH6xzE8HvLmMcw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
