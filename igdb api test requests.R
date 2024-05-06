library(httr)
library(jsonlite)
library(tidyjson)

client_id = "9mw7zxuabb95gony5yx0598b7l0jn0"
client_secret = "56a461dn6gjxfp9qpmnhmp00484sq0"


url <- paste0(
  "https://id.twitch.tv/oauth2/token?client_id=",
  client_id,
  "&client_secret=",
  client_secret, 
  "&grant_type=client_credentials"
  )

res = POST(url)
data = fromJSON(rawToChar(res$content))

res1 = POST(
  url = "https://api.igdb.com/v4/games",
  add_headers(`Client-ID` = client_id, Authorization = paste("Bearer", data$access_token)),
  body = 'fields *; search "Mario"; limit 500;'
)

data2 = fromJSON(rawToChar(res1$content))
data2 %>% select(name,genres) -> x



res2 = POST(
  url = "https://api.igdb.com/v4/genres",
  add_headers(`Client-ID` = client_id, Authorization = paste("Bearer", data$access_token)),
  body = 'fields checksum,created_at,name,slug,updated_at,url;limit 500;'
)
data3 = fromJSON(rawToChar(res2$content))
data3 %>% select(id, name) -> genre_lookup


x <- data2 %>% select(name,genres) %>% rowwise() %>% mutate(genres = paste(genres, collapse='xxx') %>% parse_number()) %>% left_join(data3, by = join_by(genres == id)) %>% select(Name = name.x, Genre = name.y)

max_genres <- data2 %>% pull(genres) %>% map(length) %>% unlist() %>% max()
cols = paste('Genre', 1:max_genres)

data2 %>% 
  select(Game = name,  release_date = first_release_date, summary, involved_companies, genres) %>%
  rowwise() %>% 
  mutate(genres = paste(genres, collapse='xxx')) %>% 
  ungroup() %>% separate(genres, cols, sep = 'xxx') %>%
  mutate(
    `Genre 1` = parse_integer(`Genre 1`),
    `Genre 2` = parse_integer(`Genre 2`),
    `Genre 3` = parse_integer(`Genre 3`),
    `Genre 4` = parse_integer(`Genre 4`),
    `Genre 5` = parse_integer(`Genre 5`),
  )-> x

x %>% left_join(genre_lookup, by = join_by(`Genre 1` == id)) %>%
  rename('G1' = name) %>%
  left_join(genre_lookup, by = join_by(`Genre 2` == id)) %>%
    rename('G2' = name) %>%
  left_join(genre_lookup, by = join_by(`Genre 3` == id)) %>%
    rename('G3' = name) %>%
  left_join(genre_lookup, by = join_by(`Genre 4` == id)) %>%
  rename('G4' = name) %>%
  left_join(genre_lookup, by = join_by(`Genre 5` == id)) %>%
  rename('G5' = name) %>%
  
  mutate(Genres = paste(G1, G2, G3, G4, G5, sep = ' | ')) %>%
  mutate(Genres1 = str_replace_all(Genres, " \\| NA( \\| NA)*$", '')) %>%
  select(Game, Genrees = Genres1) -> y
y
