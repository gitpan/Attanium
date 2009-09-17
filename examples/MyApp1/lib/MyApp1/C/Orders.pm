package MyApp1::C::Orders;

use warnings;
use strict;
use base 'MyApp1';

=head1 NAME

MyApp1::C::Orders

=head1 DESCRIPTION

Overview of functionality and purpose of
web application module ...

=head1 METHODS

=head2 SUBCLASSED METHODS

=head3 setup

Override or add to configuration supplied by MyApp1::cgiapp_init.

TODO: change all these values to ones more appropriate for your application.

=cut

sub setup {
    my ($self) = @_;

}

=pod

TODO: Other methods inherited from CGI::Application go here.

=head2 RUN MODES

=head3 index

  * Purpose
  * Expected parameters
  * Function on success
  * Function on failure

TODO: Describe index1 here. 

=cut

sub index: StartRunmode {
    my ($c) = @_;
    $c->tt_params({
	message => 'Hello world!',
	title   => 'C::Orders'
		  });
    return $c->tt_process();
    
}

sub example: Runmode{
    my $c = shift;

    my $customer = $c->resultset("MyApp1::DB::Result::Customer")->find(1);
    $c->tt_params(customer=>$customer);

    my $order1 = $c->resultset("MyApp1::DB::Result::Orders")->find(1);
    $c->tt_params(order1 => $order1);
    return $c->tt_process();
}


sub form: Runmode{
    my $c    = shift;
    my $errs = shift;

    # Use superform plugin to create a select list
    # of customers.
    my @customers = $c->resultset("MyApp1::DB::Result::Customer")->all;
    my @cust_ids = map { $_->id } @customers;
    my %cust_lbls = map {$_->id => $_->last_name.", ".$_->first_name} @customers;

    my $select = $c->superform->select(
	name    => 'customer',
	default => 0,
	values  => \@cust_ids,
	labels  => \%cust_lbls,
	);
    $c->tt_params(customer_select => $select);
    
   
    # return the error page (from check_rm) if errors were found.
    if ($errs) {
	$c->tt_params($errs);
	return $c->tt_process();
    }
    
    # check for id param and fill the form if found.
    return $c->tt_process();
}

sub add: Runmode{
	my $c = shift;

	my ( $results, $err_page ) = $c->check_rm( 'form', '_dfv_profile' );
	return $err_page if $err_page;
	$DB::single=2;

	my $cust_id   = $c->query()->param("customer");

	my $customer = $c->resultset("MyApp1::DB::Result::Customer")->find($cust_id);
	# do something if not found.
	$customer->create_related("orders",{order_status => "OPEN"});

	# send to example page where they can see new order
	return $c->redirect( $c->query()->url() . "/orders/example");
}


sub _dfv_profile{
    my $c = shift;
    return { required => [ 'customer' ] };
}


=head3 example

A stub for adding a runmode. Runmodes are declared with the ': Runmode' modifier.
NOTE: Only one method can be marked as 'StartRunmode'.

=cut

#sub example: Runmode{
#	my $c = shift;
#	# do something
#	# set $c->tt_params
#	# return $c->tt_process();
#}




# TODO: Private methods go here. Start their names with an _ so they are skipped
# by Pod::Coverage.

#
#sub _non_runmode_util_subroutine{
#	# no self = shift!
#	...
#}
#
#sub _non_runmode_util_method{
#	my $c = shift;
#	...
#}
#


=head1 BUGS AND LIMITATIONS

There are no known problems with this module.

Please report any bugs or feature requests to
C<bug- at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SEE ALSO

L<CGI::Application>, L<Titanium>


=head1 AUTHOR

, C<< <> >>

=head1 LICENSE AND COPYRIGHT

Copyright  , all rights reserved.



=cut

1;    # End of 

__END__
