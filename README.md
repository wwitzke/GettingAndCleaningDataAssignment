# GettingAndCleaningDataAssignment

## Setting up the analysis to run

### Overview

All global options that can be (relatively) safely modified are found in
"globals.R". If you need to change minor aspects of behavior for this program
(such as where data is stored on your system or how files are downloaded or
other things that would not affect the analysis), then that file is the place
to do it. Modify other files at your own risk.

I want to say that this should not *normally* be necessary. In a just world,
this would certainly be the case.

### Options that can be changed in "globals.R"

`data.dir`

- This is the path to which raw data files will be downloaded
- By default this is "data"
- Note that downloaded data will be unzipped into this directory, which may
overwrite files if you are not careful about setting this global
- Also note that if you change this directory, you may also want to change the
".gitignore" file to reflect this change, or you might accidentally upload all
the data to your repository.

`output.dir`

- This is the path where the tidy data file will be created
- By default this is "out"
- Also note that if you change this directory, you may also want to change the
".gitignore" file to reflect your change, or you might accidentally upload all
the output data to your repository.

`download.method`

- This is the method that will be used to download files
- By default this is "auto"
- If you are using an Apple product, I am given to understand that you may need 
to change this to "curl"

`download.destfile`

- This is the local name to give to the downloaded file
- By default this is "RawDataset.zip"

`output.destfile`

- This is the name of the created tidy data file
- By default this is "TidyDataset.txt"

## Instructions to run

Set up "globals.R" and your system to run the analysis (see the previous section).

Load "run\_analysis.R" into RStudio and click the *Run* button.

OR

If you have your environment and permissions set up properly, you can run the
script from the command line. In Linux, `./run_analysis.R`

## Cleaning up your session for a new run

You can load and run "clean.R" to clean up data and prepare to run the analysis
again. The code will do its best to not destroy any of your files if you have
redefined any global variables, but if you make it very difficult for the code,
it will not be able to work miracles.

Normally, it is not necessary to use "clean.R" but it may be useful if you are
modifying the analysis, are worried about raw data corruption or trying the
analysis on a new version of the dataset.

Assuming you have your environment and permissions set up properly, you can run
this from the commmand line using `./clean.R`
