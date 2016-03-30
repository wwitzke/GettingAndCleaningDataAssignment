#!/usr/bin/R --silent -f

#   Globals
#   Change these to change some minor aspects of program behavior in both
#   run_analysis.R and clean.R.
data.dir = "data";
output.dir = "out";
download.method = "auto";

download.destfile = "RawDataset.zip";
timestamp.file = "Timestamp.txt";
output.destfile = "TidyDataset.txt";
