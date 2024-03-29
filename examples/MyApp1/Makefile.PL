#
# $Id: Makefile.PL 52 2009-01-06 03:22:31Z jaldhar $
#
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'MyApp1',
    AUTHOR              => 'gordon <gordon@minipeg.net>',
    VERSION_FROM        => 'lib/MyApp1.pm',
    ABSTRACT_FROM       => 'lib/MyApp1.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'CGI::Application'              => 4.04,
        'File::Find'                    => 0,
        'HTML::Template'                => 0,
        'Pod::Coverage'                 => 0.18,
        'Pod::Usage'                    => 0,
        'Test::More'                    => 0,
        'Test::Pod'                     => 1.22,
        'Test::Pod::Coverage'           => 1.08,
        'Test::WWW::Mechanize::CGIApp'  => 0,
    },
    SIGN => 1,
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'MyApp1-*' },
);
