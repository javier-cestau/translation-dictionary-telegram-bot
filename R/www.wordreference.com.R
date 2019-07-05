library(dplyr)
library(rvest)
library(stringr)
library(purrr)

translate <- function(url){
  site <- read_html(iconv(url, to = "UTF-8"), encoding = "utf8")
  
  from_word <- site %>%
    html_nodes('#articleWRD table.WRD:first-of-type .even .FrWrd strong, 
               #article table.WRD:first-of-type .even .FrWrd strong') %>%
    html_text() %>%
    str_remove_all("⇒")
  
  to_word <- site %>% 
    html_nodes('#articleWRD table.WRD:first-of-type .even .ToWrd, 
               #article table.WRD:first-of-type .even .ToWrd') %>%
    html_nodes(xpath = 'text()') %>%
    html_text() %>%
    str_remove_all("⇒")
  
  if (is_empty(c(from_word, to_word))) {
    
    script <- site %>%
      html_nodes("#articleHead > script") %>% 
      html_attr("src")
    
    suggestions <- read_html(script) %>%
      html_nodes("a") %>% 
      html_text()
    
    if (is_empty(suggestions)) {
      assign("suggestions", '', envir = .GlobalEnv)
    } else {
      assign("suggestions", suggestions, envir = .GlobalEnv)
    }
  }
  
  if (length(to_word) > 1) {
    assign("to_word", sapply(to_word, URLencode),  envir = .GlobalEnv)
  } else {
    global_to_word <- if ( length(to_word) == 1) URLencode(to_word) else ''
    assign("to_word", global_to_word,  envir = .GlobalEnv)
  }
  
  if (length(from_word) > 1) {
    assign("from_word", sapply(from_word, URLencode),  envir = .GlobalEnv)
  } else {
    global_from_word <- if ( length(from_word) == 1) URLencode(from_word) else ''
    assign("from_word", global_from_word,  envir = .GlobalEnv)
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