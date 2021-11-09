#' Get data and read
#' Build barcharts
#' 

# reads in the mode choice data and then pivots it to a longer format
read_mc_data<- function(raw_file,website){
  if(!file.exists(raw_file)){
    download.file(website, raw_file)
  }
  read_csv(raw_file) %>%
    pivot_longer(!iterations, names_to = "mode", values_to = "count")
}

# reads in the events csv files and filters it to ModeChoice Events
read_events <- function(raw_file, website){
  if(!file.exists(raw_file)){
    download.file(website, raw_file)
  }
  read_csv(raw_file, col_types = cols(.default = "c")) %>%
    filter(type == "ModeChoice") %>%
    group_by(mode) %>%
    select(person, tourIndex, tourPurpose, mode, income, vehicleOwnership, availableAlternatives, personalVehicleAvailable, length, time, type) %>%
    arrange(person)
}


# creates a stacked barchart of all modes across each iteration
build_barchart <- function(mcData, modelType){
  ggplot(mcData) + 
    aes(fill = forcats::fct_rev(mode), y = count, x = iterations) + 
    labs(fill='Mode', y = 'Count', x = 'Iterations') +
    ggtitle(paste0(modelType, " Modal Split Histogram")) +
    geom_bar(position="stack", stat = "identity") + 
    scale_fill_brewer(palette = "Pastel2")
}