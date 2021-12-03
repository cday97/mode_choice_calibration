
# creates a line chart of total modes across each model type
build_modalsplit <- function(modalsplits){
  ggplot(modalsplits) + 
    aes(x = model, y = pct, color = mode) + 
    labs(fill='Mode', y = 'Count', x = 'Model') +
    geom_point()+  
    geom_line(aes(group = mode)) + 
    #geom_bar(position="stack", stat = "identity") + 
    scale_fill_brewer(palette = "Pastel2")
}

# creates a line chart of total modes for each tour purpose across each model type
build_toursplit <- function(splits){
  splits1 <- splits %>% filter(tourPurpose != "atwork")
  ggplot(splits1) + 
  aes(x = model, y = pct, color = mode) + 
  labs(fill='Mode', y = 'Count', x = 'Model') +
  geom_point()+  
  geom_line(aes(group = mode)) + 
  scale_fill_brewer(palette = "Pastel2") + 
  facet_wrap(~ tourPurpose)
}

# creates a line chart of total modes for each vehicle ownership across each model type
build_vehsplit <- function(splits){
  ggplot(splits) + 
    aes(x = model, y = pct, color = mode) + 
    labs(fill='Mode', y = 'Count', x = 'Model') +
    geom_point()+  
    geom_line(aes(group = mode)) + 
    scale_fill_brewer(palette = "Pastel2") + 
    facet_wrap(~ vehicleOwnership)
}