get_IGDB_access_token <- function(client_id, client_secret){
  url <- paste0(
    "https://id.twitch.tv/oauth2/token?client_id=",
    client_id,
    "&client_secret=",
    client_secret, 
    "&grant_type=client_credentials"
  )
  
  res = POST(url)
  data = fromJSON(rawToChar(res$content))
  bearer_token <- paste("Bearer", data$access_token)
  return(bearer_token)
}

get_IGDB_genres <- function(client_id, bearer_token){
  res = POST(
    url = "https://api.igdb.com/v4/genres",
    add_headers(`Client-ID` = client_id, Authorization = bearer_token),
    body = 'fields checksum,created_at,name,slug,updated_at,url;limit 500;'
  )
  
  data = fromJSON(rawToChar(res$content))
  genre_lookup = data %>% select(id, genre = name) %>% return()
}

get_IGDB_games <- function(client_id, bearer_token, genre_lookup, body){
  res = POST(
    url = "https://api.igdb.com/v4/games",
    add_headers(`Client-ID` = client_id, Authorization = bearer_token),
    body = body
  )
  
  data = fromJSON(rawToChar(res$content))
  
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
    mutate(across('g1':paste0('g',max_genres), recode, !!!lookup)) %>%
    unite("Genres", 'g1':paste0('g',max_genres), sep = ' | ', remove = FALSE, na.rm = TRUE) %>%
    return()
}

get_IGDB_involved_companies <- function(client_id, bearer_token){
  res = POST(
    url = "https://api.igdb.com/v4/involved_companies",
    add_headers(`Client-ID` = client_id, Authorization = bearer_token),
    body = 'fields checksum,company,developer,game,porting,publisher,supporting;where id = (8775,8776,8777);limit 500;'
  )
  
  data = fromJSON(rawToChar(res$content)) %>% return()
}

get_IGDB_company <- function(client_id, bearer_token){
  res = POST(
    url = "https://api.igdb.com/v4/companies",
    add_headers(`Client-ID` = client_id, Authorization = bearer_token),
    body = 'fields checksum,name,country,published,start_date,parent,developed,description;where id = (70,1760,1025);limit 500;'
  )
  
  data = fromJSON(rawToChar(res$content)) %>% return()
}
