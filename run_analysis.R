#!/usr/bin/R --silent -f

#   Grab some global definitions.
source( "globals.R" );

if ( !dir.exists( data.dir ) )
{
    dir.create( data.dir, recursive=TRUE );
}

if ( !dir.exists( output.dir ) )
{
    dir.create( data.dir, recursive=TRUE );
}

if ( !file.exists( file.path(data.dir,download.destfile) ) )
{
    download.file(
	url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
	destfile=file.path(data.dir,download.destfile),
	method=download.method
    );
}
