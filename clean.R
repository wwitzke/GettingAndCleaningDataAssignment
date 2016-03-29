#!/usr/bin/R --slave -f

#   Grab some global definitions.
source("globals.R");

unlink( file.path( data.dir, download.destfile ) );
unlink( data.dir );

unlink( file.path( output.dir, output.destfile ) );
unlink( output.dir );
