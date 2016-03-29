#!/usr/bin/R --slave -f

#   Grab some global definitions.
source("globals.R");

unlink( file.path( data.dir, download.destfile ) );
result = file.remove( data.dir );

unlink( file.path( output.dir, output.destfile ) );
result = file.remove( output.dir );
