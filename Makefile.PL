#!/usr/bin/perl

use ExtUtils::MakeMaker;

WriteMakefile
  ( NAME         => 'Lyrics::Fetcher',
    AUTHOR       => 'Sir Reflog <reflog@mail15.com>',
    ABSTRACT     => 'Module for fetching song lyrics from websites.',
    VERSION_FROM => 'Fetcher.pm',
    dist         => { COMPRESS => 'gzip -9',
                      SUFFIX   => 'gz',
                    },
  );
