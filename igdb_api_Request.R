library(httr)
library(jsonlite)
library(tidyjson)

source("igdb_api_Helpers.R")
source("igdb_api_Cleaners.R")

client_id = "9mw7zxuabb95gony5yx0598b7l0jn0"
client_secret = "56a461dn6gjxfp9qpmnhmp00484sq0"

bearer_token <- get_igdb_bearer_token(client_id, client_secret)

genre_lookup <- get_igdb_genres(client_id, bearer_token) %>% select(id, genre = name)
platform_lookup <- get_igdb_platform(client_id, bearer_token)

games_data <- get_igdb_games(
  client_id, bearer_token,
  'fields *; search "Mario"; limit 500;'
  )

games_clean <- igdb_clean_games(games_data, genre_lookup)

x <- get_igdb_involved_companies(client_id, bearer_token)

y <- get_igdb_company(client_id, bearer_token)

z <- get_igdb_platform(client_id, bearer_token)
# Unix Time Stamp to Date
# 28/09/2018 <-> 1538129354
# as_datetime(1538129354) %>% as_date()
