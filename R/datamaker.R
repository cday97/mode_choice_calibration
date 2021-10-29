#' Get data and read
#' Build barcharts
#' 

# reads in the mode choice data and then pivots it to a longer format
read_mc_data<- function(raw_file){
  if(!file.exists(raw_file)){
    download.file("https://byu.app.box.com/folder/121998673825", raw_file)
  }
  read_csv(raw_file) %>%
    pivot_longer(!iterations, names_to = "mode", values_to = "count")
}

# creates a stacked barchart of all modes across each iteration
build_barchart <- function(mcData, modelType){
  ggplot(mcData) + 
    aes(fill = forcats::fct_rev(mode), y = count, x = iterations) + 
    labs(fill='Mode', y = 'Count', x = 'Iterations') +
    ggtitle(paste0(modelType, " Mode Choice Histogram")) +
    geom_bar(position="stack", stat = "identity") + 
    scale_fill_brewer(palette = "Pastel2")
}