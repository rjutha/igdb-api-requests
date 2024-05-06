library(httr)
library(jsonlite)
library(tidyjson)

source("IGDB_API_Helpers.R")

client_id = "9mw7zxuabb95gony5yx0598b7l0jn0"
client_secret = "56a461dn6gjxfp9qpmnhmp00484sq0"

bearer_token <- get_IGDB_bearer_token(client_id, client_secret)

genre_lookup <- get_IGDB_genres(client_id, bearer_token)

data <- get_IGDB_games(
  client_id, bearer_token, genre_lookup,
  'fields *; search "Mario"; limit 500;'
  )

data %>% select(Game = game, Genres) %>% head(6)

x <- get_IGDB_involved_companies(client_id, bearer_token)

y <- get_IGDB_company(client_id, bearer_token)
