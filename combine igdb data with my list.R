library(tidyverse)
library(httr)
library(jsonlite)
library(tidyjson)

source("igdb_api_Helpers.R")
source("igdb_api_Cleaners.R")
source("get_completed_games.R")

client_id = "9mw7zxuabb95gony5yx0598b7l0jn0"
client_secret = "56a461dn6gjxfp9qpmnhmp00484sq0"

bearer_token <- get_igdb_bearer_token(client_id, client_secret)


genres_lookup <- get_igdb_genres(client_id, bearer_token) %>% select(id, genre = name)
platforms_lookup <- get_igdb_platform(client_id, bearer_token)

completed_games %>% 
  pull(Name) %>% 
  paste0('fields *; search "', ., '"; limit 500;') %>% 
  map_df(get_igdb_games, client_id = client_id, bearer_token = bearer_token) %>%
    clean_igdb_first_release_date() %>%
    clean_igdb_genres(genres_lookup) %>%
    clean_igdb_platforms(platforms_lookup) %>%
    clean_igdb_involved_companies() %>%
    select(
      name, first_release_date,
      Platforms, Genres, summary,
      developer, publisher, supporting, porting
    ) -> test
