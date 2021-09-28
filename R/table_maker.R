

asim_table <- function(asim_tour_coeffs,purpose){
  asim1<- asim_tour_coeffs %>% select(Variable, {{purpose}}) %>% 
    slice(1:9,14:19) %>%
    mutate (
      term = case_when(grepl("ivt",Variable) ~ "ivtt", TRUE ~ Variable)
    ) %>%
    select(term,{{purpose}}) %>% 
    group_by(term) %>%
    summarize(estimate = {{purpose}}, ave:= mean({{purpose}}), std.error = sd({{purpose}})) %>%
    mutate(
      estimate := case_when(term == "ivtt" ~ ave,TRUE ~ estimate)
    ) %>% 
    distinct() %>% 
    select(-ave)
}

ivtt_ratio_grapher <- function(purp,asim){
  list(
    "ActivitySim" = asim
  ) %>%
  bind_rows(.id = "model") %>%
  dwplot(dot_args = list(size=2)) + 
  ggtitle(paste0(purp," Utility Parameter Values")) +
  xlab("(Coeff Value) / IVTT") + ylab("Path Variables in BEAM") +
  scale_x_continuous(trans = "log10", labels = function(x) format(x, scientific = FALSE)) +
   theme_bw()
}
  


weird <- scales::trans_new("neg_log2",
                           transform=function(x) log(abs(x)),
                           inverse=function(x) exp(abs(x))
                           #breaks = breaks_log())
)