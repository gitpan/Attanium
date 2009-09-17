package MyApp1::C::Home;

use warnings;
use strict;
use base 'MyApp1';

=head1 NAME

MyApp1::C::Home

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
	title   => 'C::Home'
		  });
    return $c->tt_process();
    
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
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MyApp1>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SEE ALSO

L<CGI::Application>, L<Titanium>


=head1 AUTHOR

gordon, C<< <gordon at minipeg.net> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2009 gordon, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1;    # End of 

__END__
