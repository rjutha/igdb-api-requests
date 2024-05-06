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
  
  platforms_lookup %>% pull(abbreviation) -> look
}
