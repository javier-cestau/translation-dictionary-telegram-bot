library(dplyr)
library(rvest)
library(stringi)

translate <- function(url){
  site <- read_html(iconv(url, to = "UTF-8"), encoding = "utf8")
  
  from_word <- site %>%
    html_nodes('#articleWRD table.WRD:first-of-type .even .FrWrd strong') %>%
    html_text()
  
  to_word <- site %>% 
    html_nodes('#articleWRD table.WRD:first-of-type .even .ToWrd') %>%
    html_nodes(xpath = 'text()') %>%
    html_text()
  
  if (length(to_word) == 1) {
    assign("to_word", URLencode(to_word),  envir = .GlobalEnv)
  } else {
    assign("to_word", sapply(to_word, URLencode),  envir = .GlobalEnv)
  }

  if (length(from_word) == 1) {
    assign("from_word", URLencode(from_word),  envir = .GlobalEnv)
  } else {
    assign("from_word", sapply(from_word, URLencode),  envir = .GlobalEnv)
  }
}
