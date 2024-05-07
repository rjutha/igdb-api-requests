# Cleaning functions for my purposes.
# Kept the api helpers generalized but these clean for how I want to use the data.
# one function for each variable to be cleaned

clean_igdb_first_release_date <- function(data){
  # Unix Time Stamp to Date
  # 28/09/2018 <-> 1538129354
  # as_datetime(1538129354) %>% as_date()
  data %>%
    mutate(first_release_date = as_datetime(first_release_date) %>% as_date())
}

clean_igdb_genres <- function(data, genre_lookup){
  max_genres <- data %>% pull(genres) %>% map(length) %>% unlist() %>% max()
  cols = paste0('g', 1:max_genres)
  
  genre_lookup %>% pull(genre) -> lookup
  names(lookup) = genre_lookup %>% pull(id)
  
  data %>% 
    rowwise() %>% 
    mutate(genres = paste(genres, collapse='xxx')) %>% 
    ungroup() %>% 
    separate(genres, cols, sep = 'xxx') %>%
    mutate(across('g1':paste0('g',max_genres), parse_integer)) %>%
    # https://github.com/tidyverse/dplyr/issues/3899 (how to use a named vector in recode)
    mutate(across('g1':paste0('g',max_genres), recode, !!!lookup)) %>%
    unite("Genres", 'g1':paste0('g',max_genres), sep = ' | ', remove = FALSE, na.rm = TRUE) %>%
    return()
}

clean_igdb_platforms <- function(data, platforms_lookup){
  max_platforms <- data %>% pull(platforms) %>% map(length) %>% unlist %>% max()
  cols = paste0('p', 1:max_platforms)
  
  platforms_lookup %>% pull(abbreviation) -> lookup
  names(lookup) = platforms_lookup %>% pull(id)
  
  data %>%
    mutate(platforms = platforms %>% str_replace_all('c|[:punct:]', "") %>% str_replace_all('[:space:]', 'xxx')) %>%
    ungroup() %>%
    separate(platforms, cols, sep = 'xxx') %>%
    mutate(across('p1':paste0('p',max_platforms), recode, !!!lookup)) %>%
    unite("Platforms", 'p1':paste0('p',max_platforms), sep = ' | ', remove = FALSE, na.rm = TRUE) %>%
    return()
}

clean_igdb_involved_companies <- function(data){
  
  test <- data %>% pull(involved_companies) %>% unlist() %>% head(50)
  test1 <- paste(test, collapse = ',')
  body = paste0('fields *;where id = (', test1, ');limit 500;')
  
  get_igdb_involved_companies(client_id, bearer_token, body) -> ic_data
  
  test3 = ic_data %>% pull(company) %>% unique() %>% paste(collapse = ',')
  body = paste0('fields *;where id = (', test3, ');limit 500;')
  
  get_igdb_company(client_id, bearer_token, body) -> company_lookup
  # recode company -> group by game -> create porting publisher supporting columns
  
  company_lookup %>% pull(name) -> lookup
  names(lookup) = company_lookup %>% pull(id)
  
  ic_data %>% mutate(company1 = recode(company, !!!lookup)) %>% select(id, company, company1, game, porting, publisher, developer, supporting) %>%
    group_by(game) %>%
    mutate(
      publisher1 = case_when(
        developer == TRUE paste()
      )
    )
}
