library(dplyr)
library(rvest)
library(stringr)

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
  
  language_source <- site %>%
    html_node(xpath = '/html/head/meta[3]') %>%
    html_attr('content')
  
  if (language_source %in% c("en,es", "es,en")) {
    language_translation <- str_split(language_source, ",")[[1]][2]
    language_source <- str_split(language_source, ",")[[1]][1] 
  } else {
    lang <- site %>% html_node('#nav > a') %>% html_attr("href")
    language_source <- lang %>% str_sub(start = 2, end = -4)
    language_translation <- lang %>% str_sub(start = 4, end = -2)
  }
  
  assign("language_source", language_source, envir = .GlobalEnv)
  assign("language_translation", language_translation, envir = .GlobalEnv)
  
}