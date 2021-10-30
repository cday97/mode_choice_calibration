library(targets)
library(tarchetypes)
# This is an example _targets.R file. Every
# {targets} pipeline needs one.
# Use tar_script() to create _targets.R and tar_edit()
# to open it again for editing.
# Then, run tar_make() to run the pipeline
# and tar_read(summary) to view the results.

# Set target-specific options such as packages.
tar_option_set(packages = c("tidyverse", "bookdown"))

# Define custom functions and other global objects.
# This is where you write source(\"R/functions.R\")
# if you keep your functions in external scripts.
source("R/datamaker.R")

# Targets necessary to build your data and run your model
data_targets <- list(
  #read in and create data tables
  tar_target(mnldata, read_mc_data("data/modeChoice-slc-mnl.csv")),
  tar_target(pathdata, read_mc_data("data/modeChoice-slc-path.csv")),
  tar_target(persondata, read_mc_data("data/modeChoice-slc-person.csv")),
  tar_target(locationdata, read_mc_data("data/modeChoice-slc-location.csv")),
  tar_target(alldata, read_mc_data("data/modeChoice-slc-all.csv")),
  
  #create modal split graphs
  tar_target(mnlgraph, build_barchart(mnldata, "MNL")),
  tar_target(pathgraph, build_barchart(pathdata, "Path")),
  tar_target(persongraph, build_barchart(mnldata, "Person")),
  tar_target(locationgraph, build_barchart(pathdata, "Location")),
  tar_target(allgraph, build_barchart(pathdata, "All"))
  
)

# Targets necessary to build the book / article
#book_targets <- list(
#  tar_target(report, rmarkdown::)
#)

# End this file with a list of target objects.
list(
  data_targets
  #book_targets
)
