#!perl -T
#
# $Id: test-app.t 52 2009-01-06 03:22:31Z jaldhar $
#
use strict;
use warnings;
use Test::More tests => 1;
use Test::WWW::Mechanize::CGIApp;
use MyApp1;

my $mech = Test::WWW::Mechanize::CGIApp->new;

$mech->app('MyApp1');

$mech->get_ok();

