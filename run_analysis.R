#!/usr/bin/R --silent -f

#   Our libraries.
library( stringr );
suppressWarnings( library( dplyr ) );

#   Grab some global definitions.
source( "globals.R" );

#   This is where the real file processing work gets done. Normally we won't
#   be able to just read the files and be done with it, and that is true in
#   this case, but just barely. We really just need to make sure and skip the
#   files we don't care about here.
#
#   This function takes a vector of file paths and returns a list of data
#   frames for the files that the function actually reads in.
ProcessFiles = function( filelist )
{
    #	These are the files we do not care about.
    dnc = "features_info.txt|README.txt|Inertial Signals";

    filelist = filelist[!str_detect(filelist, dnc)];

    retval = list();

    for( ff in filelist )
    {
	retval[[ff]] = read.table( ff, stringsAsFactors = FALSE );
    }

    return( invisible( retval ) );
}

#   Here we are setting up directories to store our input and output datasets.
#   Note that this uses variables defined in "globals.R" to determine both the
#   input "data" directory and "output" directory.
SetUpDirectories = function()
{
    if ( !dir.exists( data.dir ) )
    {
	dir.create( data.dir, recursive=TRUE );
    }

    if ( !dir.exists( output.dir ) )
    {
	dir.create( output.dir, recursive=TRUE );
    }
}

#   This gets the data from the remote host (if necessary) and writes a
#   timestamp to a text file describing when the file was downloaded (if the
#   download was necessary). It returns the time stamp describing when the file
#   was downloaded (this may have been read from an existing file if no
#   download was necessary).
#
#   Note that this uses variables set in "globals.R" to determine the local
#   input data directory, the method of download, and the name of the
#   timestamp file. It also takes a path to the input file as an argument.
GetData = function( input.file )
{
    my_timestamp = file.path( data.dir, timestamp.file );

    if ( !file.exists( input.file ) )
    {
	#write.table(" ", file=file.path(data.dir,download.destfile) );
	retval = date();
	download.file(
	    url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
	    destfile = input.file,
	    method = download.method
	);
	writeLines( retval, my_timestamp );

	return( retval );
    }
    else
    {
	return( readLines( my_timestamp, n=1 ) );
    }
}

#   Assuming that the raw data file exists, this function will extract it,
#   prepare the appropriate data tables, clean up the extracted files, and then
#   return the created data tables. It also takes the path to the input file as
#   an argument.
PrepareData = function( input.file )
{
    #	So, we're going to just fail if we find that the temporary zip
    #   directory already exists. This seems like the safest alternative. Other
    #	options, including attempting to use file.remove to avoid the
    #	destruction of existing user files, are far more complicated and just
    #	not worth it when this method will make a user's files COMPLETELY safe.
    zip.filelist = unzip( input.file, overwrite = FALSE, list = TRUE );

    created.dir = str_match(
		    zip.filelist[1]$Name,
		    paste("^(.*?)", .Platform$file.sep, sep="" )
		  )[1,2];

    temp.dir = file.path( data.dir, created.dir );

    if ( file.exists( temp.dir ) )
    {
	stop( "Unzip directory location already exists. Stopping for safety." );
    }

    zip.filelist = unzip( input.file, overwrite = FALSE, exdir = data.dir );

    #	Here we do the real work on getting the data. This call should return
    #	a list of data tables by filename, one for each file. I don't want to
    #	care about which file, or what format, or any of that here. So I won't.
    retval = ProcessFiles( zip.filelist );

    unlink( temp.dir, recursive=TRUE );

    return( invisible( retval ) );
}

SetUpDirectories();

input.file = file.path( data.dir, download.destfile );

download.timestamp = GetData( input.file );

raw.tables = PrepareData( input.file );

column.names = raw.tables[[2]][,2];

testData = tbl_df( raw.tables[[4]] );
trainData = tbl_df( raw.tables[[7]] );

names( testData ) = column.names;
names( trainData ) = column.names;

testData = testData[, grepl( "mean|std", names( testData ) ) ];
trainData = trainData[, grepl( "mean|std", names( trainData ) ) ];

names( raw.tables[[5]] ) = "activity";
names( raw.tables[[8]] ) = "activity";

names( raw.tables[[3]] ) = "subjectid";
names( raw.tables[[6]] ) = "subjectid";

testData = tbl_df( cbind( raw.tables[[5]], testData ) );
trainData = tbl_df( cbind( raw.tables[[8]], trainData ) );

testData = tbl_df( cbind( raw.tables[[3]], testData ) );
trainData = tbl_df( cbind( raw.tables[[6]], trainData ) );

testData = tbl_df( cbind( setname = "test", testData ) );
trainData = tbl_df( cbind( setname = "train", trainData ) );

allData = tbl_df( rbind( testData, trainData ) );

allData$activity = factor( allData$activity, labels = raw.tables[[1]][,2] );

names( allData ) =
    tolower( 
	str_replace_all( names( allData ), "-|\\(|\\)", "" )
    );

names( allData ) =
    tolower( 
	str_replace_all( names( allData ), "^t", "time" )
    );

names( allData ) =
    tolower( 
	str_replace_all( names( allData ), "^f", "frequency" )
    );

allData = 
    summarize_each(
	group_by( allData, setname, subjectid, activity ),
	funs( mean ),
	-(setname:activity)
    );

#   Looks like the data is pretty clean, otherwise, so just write it out, I
#   guess. . ?
write.table(
    allData,
    file = file.path( output.dir, output.destfile ),
    row.names = FALSE
);
