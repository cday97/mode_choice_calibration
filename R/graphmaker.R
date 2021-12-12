
# creates a line chart of total modes across each model type
build_modalsplit <- function(modalsplits,wfrcTable){
  ggplot(modalsplits) + 
    aes(x = model, y = pct, color = mode, shape = ModelType) + 
    labs(fill='Mode', y = 'Percentage', x = 'Model') +
    geom_point(size = 2.5) +  
    scale_fill_brewer(palette = "Pastel2") +
    scale_shape_manual(values = c(16,17,8)) +
    geom_hline(aes(yintercept = pct, color = mode, linetype = "Target Share"), data = wfrcTable) +
    theme_bw()
}

# creates a line chart of total modes for each tour purpose across each model type
build_toursplit <- function(splits){
  splits1 <- splits %>% filter(tourPurpose != "atwork")
  ggplot(splits1) + 
  aes(x = model, y = pct, color = mode, shape = ModelType) + 
  labs(fill='Mode', y = 'Percentage', x = 'Model') +
  geom_point()+  
  scale_fill_brewer(palette = "Pastel2") + 
  scale_shape_manual(values = c(16,17,8)) +
  facet_wrap(~ tourPurpose) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
}

# creates a line chart of total modes for each vehicle ownership across each model type
build_vehsplit <- function(splits,wfrcTable){
  ggplot(splits) + 
    aes(x = model, y = pct, color = mode, shape = ModelType) + 
    labs(fill='Mode', y = 'Percentage', x = 'Model') +
    geom_point()+  
    scale_fill_brewer(palette = "Pastel2") + 
    scale_shape_manual(values = c(16,17,8)) +
    facet_wrap(~ vehicleOwnership) +
    geom_hline(aes(yintercept = pct, color = mode, linetype = "Target Share"), data = wfrcTable) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 
}