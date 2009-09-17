package MyApp1;

use base 'Attanium';
use FindBin qw/$Bin/;
use  MyApp1::DB;


=head1 NAME

MyApp1 

=head1 SYNOPSIS

    A controller module for MyApp1.

=head1 DESCRIPTION

This module acts as the base class for Controllers for this app. Subclasses are found
in the MyApp1::C package.

=head1 METHODS

=head2 SUBCLASSED METHODS

=head3 error

This error page is suitable for development but you will want 
to customize this runmode for your application.

=cut 


=head3 setup

Initializes the Controller base class for app, configures DBIx::Class plugin,
sets an error mode and configures the TT template directory.

Use 'setup' in your subclasses to futher configure for each Controller 
subclass.  'setup' is called after 'cgiapp_init'.

TODO: change all these values to ones more appropriate for your application.

=cut


# ---------------------------------------------------------------------------------------- #
# init app here.  setup is called after so shouldput app instance specifics there
# ---------------------------------------------------------------------------------------- #
sub error {
	my $c = shift;
	
	my $result = "<h1>error</h1>";
	$result .= "<h2>$@</h2>";
	return $result;

}



sub cgiapp_init {
	my $self = shift;
	
	#
	# set a method to catch any unhandled errors
	#
	$self->error_mode("error");

	#
	# setup main tt2 template paths
	#
	my @template_paths = ($self->cfg("tt2_dir") );
	$self->tt_include_path( \@template_paths );

	
	#
	# Configure CGI::Application::Plugin::DBIC::Schema
	#
	
	# allow this statement even if MyApp::DB.pm has not
	# yet been created.

	$self->dbic_config(
	    {
		schema       => 'MyApp1::DB',
		connect_info => [
		    $self->cfg('db_dsn'), 
		    $self->cfg('db_user'),
		    $self->cfg('db_pw')
		    ]    # use same args as DBI connect
	    }
	    );
	

# ------------------------------------------------------- #
#    Optionally you can configire a wrapper template 
#    for all pages in the application.
#
#     $self->tt_config( 
#	TEMPLATE_OPTIONS => { WRAPPER => 'site_wrapper.tmpl' } );
#
# ------------------------------------------------------- #
#       SOME USEFUL CONFIGURATION OPTIONS FOR 
#       CGI::Application::Plugin::ValidateRM.
#
#	$self->param('dfv_defaults')
#	  || $self->param(
#		'dfv_defaults',
#		{
#			missing_optional_valid => 1,
#			filters                => 'trim',
#			msgs                   => {
#				any_errors => 'some_errors',
#				prefix     => 'err_',
#				invalid    => 'Invalid',
#				missing    => 'Missing',
#				format     => '<span class="dfv-errors">%s</span>',
#			},
#		}
#	  );
# ------------------------------------------------------- #


}

1;



=pod

TODO: Other methods in your public interface go here.

=cut

# TODO: Private methods go here. Start their names with an _ so they are skipped
# by Pod::Coverage.

=head1 BUGS AND LIMITATIONS

There are no known problems with this module.

Please report any bugs or feature requests to
C<bug-myapp1 at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MyApp1>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SEE ALSO

L<CGI::Application>

=head1 THANKS

List acknowledgements here or delete this section.

=head1 AUTHOR

gordon, C<< <gordon at minipeg.net> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2009 gordon, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut


__END__
