args <- commandArgs(trailingOnly = TRUE)

source("/backup/sodermand/mergedFiles/TopDom.R")
TopDom(args[1],args[2],args[3],args[4]);
