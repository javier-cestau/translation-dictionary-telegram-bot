library(dplyr)
library(rvest)
library(stringi)

translate <- function(url_request){
  conn <- url(url_request, 'rb')
  site <- read_html(conn, encoding = "utf8")
  
  from_word <- site %>%
    html_nodes('#articleWRD table.WRD:first-of-type .even .FrWrd strong') %>%
    html_text()
  
  to_word <- site %>% 
    html_nodes('#articleWRD table.WRD:first-of-type .even .ToWrd') %>%
    html_nodes(xpath = 'text()') %>%
    html_text()
  
  assign("to_word", URLencode(to_word),  envir = .GlobalEnv)
  assign("from_word", URLencode(from_word),  envir = .GlobalEnv)
}
