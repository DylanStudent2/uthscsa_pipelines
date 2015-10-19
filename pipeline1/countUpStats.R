#!/usr/bin/env Rscript


#Arguments : <.csv file>  
#Produces: "Rplots.pdf"

args <- commandArgs(trailingOnly=TRUE)

table <- read.csv(args[1])


#The "O:O" value is much higher than the total number of promoters.
#So "O:O" will be ignored for the sake of a better looking graph.
counts <- vector("integer", 8) 
names(counts) <- c("PP1", "PN1", "PD1", "PF1","PP2","PN2","PD2","PF2")


for(item in table$label){
   counts[item] <- counts[item] + 1
}


dotchart(counts, gdata=counts)
barplot(counts)
counts


