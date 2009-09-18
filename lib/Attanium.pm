package Attanium;
use strict;
use warnings;
use base 'CGI::Application';

use vars qw($VERSION);
$VERSION = '0.003';


# Load recommended plugins by default. 
use CGI::Application::Plugin::Forward;
use CGI::Application::Plugin::Redirect;
use CGI::Application::Plugin::Session;
use CGI::Application::Plugin::ValidateRM; 
use CGI::Application::Plugin::ConfigAuto 'cfg';
use CGI::Application::Plugin::FillInForm 'fill_form';
use CGI::Application::Plugin::DBH 	  qw(dbh_config dbh); 
use CGI::Application::Plugin::LogDispatch;
use CGI::Application::Plugin::TT;
use CGI::Application::Plugin::AutoRunmode;
use CGI::Application::Plugin::SuperForm;
use CGI::Application::Plugin::DBIC::Schema qw/dbic_config schema resultset/;



#################### main pod documentation begin ###################

=head1 NAME

Attanium - A medium-weight, MVC, DB web framework.

=head2 SYNOPSIS

A simple, medium-weight, MVC web framework build on CGI::Application. The framework combines tested, well known plugins and helper scripts to provide a rapid development environment.

The bundled plugins mix the following methods into your controller runmodes:

    $c->forward(runmode)

    $c->redirect(url)

    $c->tt_param(name=>value)

    $c->tt_process()

    $c->schema()->resultset("Things")->find($id)

    $c->resultset("Things)->search({color=>"red"})

    $c->log->info('This also works')

    my $value = $c->session->param('key')

    my $conf_val = $c->cfg('field');

    my $select = $c->superform->select(
                        name    => 'select',
                        default => 2,
                        values  => [ 0, 1, 2, 3 ],
                        labels  => {
                                0 => 'Zero',
                                1 => 'One',
                                2 => 'Two',
                                3 => 'Three'
                        }
                );


    sub method: Runmode {my $c = shift; do_something();}

    $c->fill_form( \$template )

    my  $results = $ ->check_rm(
              'form_display','_form_profile') 
              || return $c->check_rm_error_page;



=head1 DESCRIPTION

Attanium is based on CGI::Application and includes a number of vetted CGIApp plugins.  This project is very similar
to, and inspired by, Mark Stosberg's L<Titanium> framework and Jaldhar H. Vyas's L<Module::Starter::Plugin::CGIApp> . 

I have taken to heart a comment by Mark Stosberg on the CGIApp mailing list:

=over 8

"Titanium is just one vision of what can be built on top of 
CGI::Application. Someone else could easily combine their own 
combination of CGI::Application and different favorite plugins, 
and publish that with a different name."     

=back

Titanium takes a very light-weight approach to make running in a CGI environment very fast. Attanium takes a slightly different approach and aims for:

=over 4

=item *

adequate performance under CGI, but with more focus speed of development.

=item *

a well-defined project structure with directories for model classes, controllers and view templates.

=item *

a powerful templating DSL via Template Toolkit integration.

=item *

a integrated Object Relational Mapper

=item *

no runmode configuration required.

=item *

integrated form building to simplify creation of complex HTML form elements.

=item *

clean url-to-controller mapping by default.


=back


Attanium is also different in that it generates a micro-architecture and helper scripts that work within that structure to speed development and maintain project structure. The helper scripts eliminate the tedium of error-prone manual creation of controllers, templates and database mappings.

L<Module::Starter::Plugin::Attanium> comes with the 'attanium-starter.pl' scriptwhich generates a runnable application skeleton.  attanium-starter.pl also generates a default 'Home' controller and a CGI::Application::Dispatch instance that is customized to default to the Home subclasses generated 'index' runmode.  

attainum-starter.pl also generates a couple helper scripts into your projects roo/scrip directory. The first, 'create_controller.pl', will assist the deveoper by generating controller subclasses of your base module with a default 'index' runmode and a 
default TT template for that runmode. A 'create_dbic_schema.pl' will also be created in the scripts directory and is used to generate a DBIx::Class::Schema subclass and a set of 
DBIx::Class::Result set subclasses for your database.

Finally Attanium aims to be as compatible as possible with L<Catalyst> which has plugins for a number of the modules used in Attanium.



=head1 Attanium Tutorial



In this tutorial we will build a simplistic database driven web application using Attanium to demonstrate using the starter and helper scripts as well as the minimal required configuration.

Attanium assumes that you have a database that you want to use with the web.  If you have a database you can use for this tutorial.  Otherwise, jump to the "Create The Example Database" section at the bottom of this page before starting the tutorial.


=cut

=head2 Installation

You will need to install L<Attanium> which provides the runtime requirements.  You will also need to install L<Module::Starter::Plugin::Attanium> which supplies the development environment.

    ~/dev$ sudo cpan
    cpan> install Attanium
          ... ok
    cpan> install Module::Starter::Plugin::Attanium
          ... ok
    cpan> exit

=cut 

=head2 Creating a Project


    ~/dev$ attanium-starter.pl --module=MyApp1 \
                               --author=gordon \
                               --email="vanamburg@cpan.org" \
                               --verbose
    Created MyApp1
    Created MyApp1/lib
    Created MyApp1/lib/MyApp1.pm                      # YOUR *CONTROLLER BASE CLASS* !
    Created MyApp1/t
    Created MyApp1/t/pod-coverage.t
    Created MyApp1/t/pod.t
    Created MyApp1/t/01-load.t
    Created MyApp1/t/test-app.t
    Created MyApp1/t/perl-critic.t
    Created MyApp1/t/boilerplate.t
    Created MyApp1/t/00-signature.t
    Created MyApp1/t/www
    Created MyApp1/t/www/PUT.STATIC.CONTENT.HERE
    Created MyApp1/templates/MyApp1/C/Home
    Created MyApp1/templates/MyApp1/C/Home/index.tmpl # DEFAULT HOME PAGE TEMPLATE
    Created MyApp1/Makefile.PL
    Created MyApp1/Changes
    Created MyApp1/README
    Created MyApp1/MANIFEST.SKIP
    Created MyApp1/t/perlcriticrc
    Created MyApp1/lib/MyApp1/C                       # YOUR CONTROLLERS GO HERE 
    Created MyApp1/lib/MyApp1/C/Home.pm               # YOUR *DEFAULT CONTROLLER SUBCLASS*
    Created MyApp1/lib/MyApp1/Dispatch.pm             # YOUR CUSTOM URL DISPATCHER
    Created MyApp1/config
    Created MyApp1/config/config-dev.pl               # YOU CONFIG -- MUST BE EDITED BY YOU!
    Created MyApp1/script
    Created MyApp1/script/create_dbic_schema.pl       # IMPORTANT HELPER SCRIPT
    Created MyApp1/script/create_controller.pl        # ANOTHER IMPORTANT HELPER SCRIPT.
    Created MyApp1/server.pl                          # SERVER USES YOUR CUSTOM DISPATCH.PM
    Created MyApp1/MANIFEST
    Created starter directories and files



=cut

=head2 Configure Your Database

Attanium is database centric in some sense and expects that you have a database.  Before running your
app via server.pl you need to configure your database access.

The example config is generated at MyApp1/config/config-dev.pl.  The contents are shown here.

	use strict;
	my %CFG;			

	$CFG{db_dsn} = "dbi:mysql:myapp1_dev";
	$CFG{db_user} = "root";
	$CFG{db_pw} = "root";
	$CFG{tt2_dir} = "templates";
	return \%CFG;

Using the root account is shown here as a worst-practice.  You should customize the file supplying the correct database dsn, user and passwords for your database.

If you do not have a database and want to use an example see "Create Example Database" below before continuing.

=cut

=head2 Generate A DBIx::Class Schema For Your Database

From your project root directory run the helper script to generate DBIx::Class::Schema and Resultset packages. This will use the configuration you supplied in config_dev.pl to produce a DB.pm in your apps lib/MAINMODULE directory

	~/dev/My-App1$ perl script/create_dbic_schema.pl 
	Dumping manual schema for DB to directory /home/gordon/dev/My-App1/script/../lib/My/App1 ...
	Schema dump completed.


Given the example database shown below your resulting DBIx::Class related files and folders would look like this:

    ~/dev/MyApp1$ find lib/MyApp1/ | grep DB
    lib/MyApp1/DB
    lib/MyApp1/DB/Result
    lib/MyApp1/DB/Result/Orders.pm
    lib/MyApp1/DB/Result/Customer.pm
    lib/MyApp1/DB.pm



=cut

=head2 Run Your App

Before running your app you will need to export the CONFIG_FILE pointing to your
dev config file. 


On linux you could use something like:

   ~/dev/MyApp1$ export CONFIG_FILE=/home/gordon/dev/MyApp1/config/config-dev.pl

On windows you could use something like:

    C:\Users\gordon\dev\MyApp1: set CONFIG_FILE=C:\Users\gordon\dev\MyApp1\config\config-dev.pl

Run the server:

    ~/dev/MyApp1$ perl server.pl 
    access your default runmode at /cgi-bin/index.cgi
    CGI::Application::Server: You can connect to your server at http://localhost:8060/

Open your browser and test at

    http://localhost:8060/cgi-bin/index.cgi


=cut

=head2 Create a new Submodule

This is where the create_controller.pl helper script comes in very handy.
As an example we can generate a new module to interact with the Orders table
of the example database.

    ~/dev/MyApp1$ perl script/create_controller.pl --name=Orders
    will try to create lib/MyApp1/C
    Created lib/MyApp1/C/Orders.pm
    will try to create template directory templates/MyApp1/C/Orders
    Created templates/MyApp1/C/Orders
    Created templates/MyApp1/C/Orders/index.tmpl
 

You can restart server.pl and view default output at:

    http://localhost:8060/cgi-bin/orders

Add a new runmode to lib/MyApp1/C/Orders.pm  to show the orders that we have from the example database.



    sub list: Runmode{
	my $c = shift;


	my @orders = $c->resultset("MyApp1::DB::Result::Orders")->all;

	$c->tt_params(orders =>\@orders);
	return $c->tt_process();

    }



Then add a template for this runmode at templates/MyApp1/C/Orders/list.tmpl with the following content:


    <h1>Order List</h1>
    <table>
      <tr><th>Cust No</th><th>Order No</th></tr>
      [% FOREACH order = orders %]
	 <tr>
	   <td>[% order.customer_id %]</td>
	   <td>[% order.id %]</td>
	 </tr>
      [% END %]
    </table>

Restart server.pl and visit page to see list of orders at:
    
  http://localhost:8060/cgi-bin/orders/list
    
 
=cut

=head2 Creating The Example Database (if you don't already have one)

The L<Attanium> distrubution contains an example sql file that you can use for this
example app.  Use the download link at L<Attanium> on CPAN, grab the archive and extract the file from the 'examples' directory of the distribution. 

The script will create the 'myapp1_dev' database, create 2 tables and load a few 
Notice that the create table statements end with 'engine=InnoDB'.  This is important since our DBIC generator script will create relationships on the perl side ased on the metadata in the database.  The default engine for mysql will not store the relationship metadata and you will then need to hand-craft the relationships at the botton of the generated DB::Result classes.

Example:

	~/dev/MyApp1$ mysql -u root -p < example_tables.mysql.ddl 
	

The contents of the example sql file are as follows:

	CREATE DATABASE myapp1_dev;
	USE myapp1_dev;

	CREATE TABLE customer(
	   id integer not null auto_increment PRIMARY KEY,
	   last_name varchar(25) null,
	   first_name varchar(25) not null
	)engine=InnoDB;

	CREATE TABLE orders(
	  id integer not null auto_increment PRIMARY KEY,
	  customer_id integer not null,
	  order_status varchar(10) default "OPEN" not null,	
	  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP not null,
	  CONSTRAINT orders_customer_id_fk FOREIGN KEY (customer_id) REFERENCES customer(id)
	)engine=InnoDB;

	INSERT INTO customer (last_name, first_name) VALUES("Doe","John");
	INSERT INTO orders (customer_id) VALUES(  1 );
	INSERT INTO orders (customer_id) VALUES(  1 );
	INSERT INTO orders (customer_id) VALUES(  1 );


If you did not use 'engine=InnoDB' or your database does not support relationships, you can paste the following in the bottom of your "MyApp/DB/Result/Orders.pm" to tell DBIx::Class how the example tables relate:


   # Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-09-15 16:05:33
   # DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:znOKfDkdRzpL0KHWpfpJ+Q

    __PACKAGE__->belongs_to(
      "customer",
      "MyApp1::DB::Result::Customer",
      { id => "customer" },
    );

See documentation for L<DBIx::Class::Manual> for more information on configuring and using relationships in your model.

=cut


=head1 Further Reading


See L<CGI::Application::Plugin::DBIC::Schema> for more information on accessing DBIx::Class from your Attanium modules.

See L<CGI::Application::Plugin::SuperForm> for form building support that is build into Attanium.

See L<DBIx::Class::Manual::Intro> for more information on using the powerful ORM included with Attanium.

See L<Titanium> and L<CGI::Application> for lots of good ideas and examples that will work with your Attanium app.


=head1 BUGS

There are no known bugs for this distribution.  


Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=<tmpl_var distro>>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.


=head1 SUPPORT

I recommend joining the cgi-application mailing list.

=head1 AUTHOR

    Gordon Van Amburg
    CPAN ID: VANAMBURG
    vanamburg at cpan.org

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


=cut

#################### main pod documentation end ###################

1;

# The preceding line will help the module return a true value
