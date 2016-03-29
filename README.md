# GettingAndCleaningDataAssignment

## Setting up the analysis to run

### Overview

All global options that can be safely modified are found in "globals.R". If you
need to change minor aspects of behavior for this program (such as where data
is stored on your system or how files are downloaded or other things that would
not affect the analysis), then that file is the place to do it. Modify other
files at your own risk.

### Options that can be changed in "globals.R"

- data.dir
-- This is the path to which raw data files will be downloaded
-- By default this is "data"
- output.dir
-- This is the path where the tidy data file will be created
-- By default this is "out"
- download.method
-- This is the method that will be used to download files
-- By default this is "auto"
-- If you are using an Apple product, I am given to understand that you may
need to change this to "curl".
