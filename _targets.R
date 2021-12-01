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
source("R/graphmaker.R")

# Targets necessary to build your data and run your model
data_targets <- list(
  #read in and create events data tables
  tar_target(mnlevents, read_events("data/events-slc-mnl.csv", "https://app.box.com/index.php?rm=box_download_shared_file&shared_name=l21hkh74pjoyeiqcak3bbulr0pquclhu&file_id=f_882996284526")),
  tar_target(pathevents, read_events("data/events-slc-path.csv", "https://app.box.com/index.php?rm=box_download_shared_file&shared_name=qcryd1cjoknzdwgparw82sbwiq1soroq&file_id=f_883000653673")),
  tar_target(personevents, read_events("data/events-slc-person.csv", "https://app.box.com/index.php?rm=box_download_shared_file&shared_name=0r5xvd63q1brcjwa8pe8ly2claa6ewl8&file_id=f_883005362878")),
  tar_target(locationevents, read_events("data/events-slc-location.csv", "https://app.box.com/index.php?rm=box_download_shared_file&shared_name=0r5xvd63q1brcjwa8pe8ly2claa6ewl8&file_id=f_883005362878")),
  tar_target(allevents, read_events("data/events-slc-all.csv", "https://app.box.com/index.php?rm=box_download_shared_file&shared_name=ckbeyzg2vdzz379alr6yf3ukefjknr51&file_id=f_883007864655")),
  tar_target(wfrcdata, read_csv("data/wfrc-modalshares.csv")),
  
  #create basic modal split table objects
  tar_target(modalsplits,  make_modes_table(mnlevents, pathevents, personevents, locationevents, allevents, wfrcdata)),
  tar_target(toursplits, make_types_table(mnlevents, pathevents, personevents, locationevents, allevents, tourPurpose)),
  tar_target(vehsplits, make_types_table(mnlevents, pathevents, personevents, locationevents, allevents, vehicleOwnership)),
  tar_target(vehsplits2, fix_veh_table(vehsplits,wfrcdata))
)

graph_targets <- list(
  ##create modal split graphs
  tar_target(modalsplit_graph, build_modalsplit(modalsplits)),
  tar_target(toursplit_graph, build_toursplit(toursplits,"Tour Purpose")),
  tar_target(vehsplit_graph, build_vehsplit(vehsplits2, "Vehicle Ownership"))
)

# Targets necessary to build the book / article
#book_targets <- list(
#  tar_target(report, rmarkdown::)
#)

# End this file with a list of target objects.
list(
  data_targets,
  graph_targets
  #book_targets
)


#download.file("https://app.box.com/index.php?rm=box_download_shared_file&shared_name=wxtrn5ycxsju0d10ewgm1va7bwqel69f&file_id=f_882973603197", "data/pathtest.csv")
#pathtest <- read_csv("data/pathtest.csv") %>% pivot_longer(!iterations, names_to = "mode", values_to = "count")
