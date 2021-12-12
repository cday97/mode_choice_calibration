
# reads in the events csv files and filters it to ModeChoice Events
read_events <- function(raw_file, website){
  if(!file.exists(raw_file)){
    download.file(website, raw_file)
  }
  read_csv(raw_file, col_types = cols(.default = "c")) %>%
    filter(type == "ModeChoice") %>%
    group_by(mode) %>%
    select(person, tourIndex, tourPurpose, mode, income, vehicleOwnership, availableAlternatives, personalVehicleAvailable, length, time, type) %>%
    arrange(person) %>%
    mutate(
      mode = case_when(
        mode == "hov2_teleportation" ~ "sr2",
        mode == "hov3_teleportation" ~ "sr3p",
        TRUE ~ mode)
    )
}

make_wfrc_table<- function(wfrc) {
  wfrc %>% filter(purpose == "total") %>% 
    pivot_longer(!c(mode,purpose), names_to = "vehicleOwnership", values_to = "pct") %>%
    filter(vehicleOwnership == "total") %>%
    select(mode, pct) %>%
    mutate(model = "WFRC", pct = pct * 100)
}

# manipulates events file to create a modal split diagram
make_modes_table <- function(mnlevents,pathevents,personevents,locationevents,allevents,wfrcdata) {
  e1 <- pcttable(pathevents, "Path")
  e2 <- pcttable(personevents, "Person")
  e3 <- pcttable(locationevents, "Location")
  e4 <- pcttable(allevents, "All")
  e5 <- pcttable(mnlevents, "MNL")
  eventsfull <- rbind(e1,e2,e3,e4,e5) %>%
    mutate(ModelType = ifelse(model == "MNL","BEAM Default (Eq: 1)", "ActivitySim (Eq: 2-5)")) %>%
    mutate(model = fct_relevel(model, "MNL", "Path", "Person", "Location", "All"))
}

# a helper function used in the make_modes_table function
pcttable <- function(events, name){
  events %>%
    group_by(mode) %>% 
    summarise(cnt = n()) %>% 
    mutate(pct = cnt / sum(cnt) * 100) %>%
    mutate(model = name) %>%
    select(-cnt)
}

# manipulates the events file to create modal split based on specific variable type
make_types_table <- function(mnlevents,pathevents,personevents,locationevents,allevents,type){
  e1 <- pcttable2(pathevents, "Path", {{type}})
  e2 <- pcttable2(personevents, "Person", {{type}})
  e3 <- pcttable2(locationevents, "Location", {{type}})
  e4 <- pcttable2(allevents, "All", {{type}})
  e5 <- pcttable2(mnlevents, "MNL", {{type}})
  rbind(e1,e2,e3,e4,e5) %>%
    mutate(ModelType = ifelse(model == "MNL","BEAM Default (Eq: 1)", "ActivitySim (Eq: 2-5)")) %>%
    mutate(model = fct_relevel(model, "MNL", "Path", "Person", "Location", "All"))
}

make_wfrc_table<- function(wfrc) {
  wfrc %>% filter(purpose == "total") %>% 
    pivot_longer(!c(mode,purpose), names_to = "vehicleOwnership", values_to = "pct") %>%
    filter(vehicleOwnership == "total") %>%
    select(mode, pct) %>%
    mutate(model = "WFRC", pct = pct * 100)
}

make_wfrc_veh_table<- function(wfrc) {
  wfrc %>% filter(purpose == "total") %>% 
    pivot_longer(!c(mode,purpose), names_to = "vehicleOwnership", values_to = "pct") %>%
    filter(vehicleOwnership != "total") %>%
    select(mode, pct,vehicleOwnership) %>%
    mutate(model = "WFRC", pct = pct * 100)
}

# a helper function used in the make_types_table function
pcttable2 <- function(events, name, type){
  events %>%
    group_by({{type}}, mode) %>% 
    summarise(cnt = n()) %>% 
    mutate(pct = cnt / sum(cnt) * 100) %>%
    mutate(model = name) %>%
    select(-cnt)
}
