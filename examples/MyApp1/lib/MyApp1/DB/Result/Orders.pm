package MyApp1::DB::Result::Orders;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("orders");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "customer",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "order_status",
  {
    data_type => "VARCHAR",
    default_value => "OPEN",
    is_nullable => 0,
    size => 10,
  },
  "order_date",
  {
    data_type => "TIMESTAMP",
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
    size => 14,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "customer",
  "MyApp1::DB::Result::Customer",
  { id => "customer" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-09-15 16:05:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:znOKfDkdRzpL0KHWpfpJ+Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
