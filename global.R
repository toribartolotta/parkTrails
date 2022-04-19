# load dplyr library
library(dplyr)

# read in AllTrails national park dataset
dataset <- read.csv("npdata.csv")

# get each different national park name
parks <- unique(dataset$area_name)

# put parks in abc order
parks <- sort(parks)
