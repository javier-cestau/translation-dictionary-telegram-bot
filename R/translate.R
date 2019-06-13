library(dplyr)
library(rvest)
library(stringi)
library(curl)

translate <- function(url){
  download.file(url, destfile = "scrapedpage.html", quiet=TRUE)

  site <- read_html("scrapedpage.html", encoding = "utf8")
  
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