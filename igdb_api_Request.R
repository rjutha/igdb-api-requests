library(httr)
library(jsonlite)
library(tidyjson)

source("igdb_api_Helpers.R")
source("igdb_api_Cleaners.R")

client_id = "9mw7zxuabb95gony5yx0598b7l0jn0"
client_secret = "56a461dn6gjxfp9qpmnhmp00484sq0"

bearer_token <- get_igdb_bearer_token(client_id, client_secret)

genre_lookup <- get_igdb_genres(client_id, bearer_token) %>% select(id, genre = name)
platform_lookups <- get_igdb_platform(client_id, bearer_token)

'fields *; search "Lego Star Wars: The Complete Saga"; where platforms = 20; limit 500;'

games_data <- get_igdb_games(
  client_id, bearer_token,
  'fields *; search "Mario"; limit 500;'
  )

games_clean <- 
  games_data %>%
  clean_igdb_first_release_date() %>%
  clean_igdb_genres(genre_lookup) %>%
  select(
    name, first_release_date,
    platforms, involved_companies, Genres, summary
  )
  

x <- get_igdb_involved_companies(client_id, bearer_token)
y <- get_igdb_company(client_id, bearer_token)
z <- get_igdb_platform(client_id, bearer_token)

