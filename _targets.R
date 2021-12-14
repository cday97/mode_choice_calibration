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
  tar_target(mnlevents, read_events("data/events/events-slc-mnl.csv", "https://app.box.com/index.php?rm=box_download_shared_file&shared_name=0onbva8sbsexojf4l5gu90uyudshbnpq&file_id=f_894947136745")),
  tar_target(pathevents, read_events("data/events/events-slc-path.csv", "https://app.box.com/index.php?rm=box_download_shared_file&shared_name=mdesd3skynuvuu0v5mlet5w7k1y47s0z&file_id=f_894947017290")),
  tar_target(personevents, read_events("data/events/events-slc-person.csv", "https://app.box.com/index.php?rm=box_download_shared_file&shared_name=87lf5uj7omu2h897oiml0owngkmfwtqn&file_id=f_894944293656")),
  tar_target(locationevents, read_events("data/events/events-slc-location.csv", "https://app.box.com/index.php?rm=box_download_shared_file&shared_name=rxukxgi9n2tloak3gbhuztk6p8p8ttkl&file_id=f_894945104546")),
  tar_target(allevents, read_events("data/events/events-slc-all.csv", "https://app.box.com/index.php?rm=box_download_shared_file&shared_name=1vk5rq1jsvdmb5wgiyiopuy3frhnbxbd&file_id=f_894945632456")),
  tar_target(wfrcdata, read_csv("data/wfrc-modalshares.csv")),
  
  #create basic modal split table objects
  tar_target(modalsplits,  make_modes_table(mnlevents, pathevents, personevents, locationevents, allevents, wfrcdata)),
  tar_target(toursplits, make_types_table(mnlevents, pathevents, personevents, locationevents, allevents, tourPurpose)),
  tar_target(vehsplits2, make_types_table(mnlevents, pathevents, personevents, locationevents, allevents, vehicleOwnership)),
  tar_target(wfrcTable, make_wfrc_table(wfrcdata)),
  tar_target(wfrcVehTable, make_wfrc_veh_table(wfrcdata))
)

graph_targets <- list(
  ##create modal split graphs
  tar_target(modalsplit_graph, build_modalsplit(modalsplits,wfrcTable)),
  tar_target(toursplit_graph, build_toursplit(toursplits)),
  tar_target(vehsplit_graph, build_vehsplit(vehsplits2,wfrcVehTable))
)

# End this file with a list of target objects.
list(
  data_targets,
  graph_targets
)
