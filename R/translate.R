library(dplyr)
library(rvest)
library(stringi)

translate <- function(url){
  site <- read_html(url)
  
  from_word <- site %>%
    html_nodes('#articleWRD table.WRD:first-of-type .even .FrWrd strong') %>%
    html_text()
  
  to_word <- site %>% 
    html_nodes('#articleWRD table.WRD:first-of-type .even .ToWrd') %>%
    html_nodes(xpath = 'text()') %>%
    html_text()
  
  assign("to_word", sapply(to_word, URLencode),  envir = .GlobalEnv)
  assign("from_word", sapply(from_word, URLencode),  envir = .GlobalEnv)
}

