# Cleaning functions for my purposes.
# Kept the api helpers generalized but these clean for how I want to use the data.

igdb_clean_games <- function(data, genre_lookup){
  max_genres <- data %>% pull(genres) %>% map(length) %>% unlist() %>% max()
  cols = paste0('g', 1:max_genres)
  
  genre_lookup %>% pull(genre) -> lookup
  names(lookup) = genre_lookup %>% pull(id)
  
  data %>%
    select(Game = name,  release_date = first_release_date, summary, involved_companies, genres) %>%
    rowwise() %>%
    mutate(genres = paste(genres, collapse='xxx')) %>% 
    ungroup() %>% 
    separate(genres, cols, sep = 'xxx') %>%
    mutate(across('g1':paste0('g',max_genres), parse_integer)) %>%
    # https://github.com/tidyverse/dplyr/issues/3899 (how to use a named vector in recode)
    mutate(across('g1':paste0('g',max_genres), recode, !!!lookup)) %>%
    unite("Genres", 'g1':paste0('g',max_genres), sep = ' | ', remove = FALSE, na.rm = TRUE) %>%
    # Unix Time Stamp to Date
    # 28/09/2018 <-> 1538129354
    # as_datetime(1538129354) %>% as_date()
    mutate(release_date = as_datetime(release_date) %>% as_date()) %>%
    return()
}
