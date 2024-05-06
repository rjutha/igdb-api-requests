# Generalized functions for accessing different urls of the igdb api.

get_igdb_bearer_token <- function(client_id, client_secret){
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

get_igdb_genres <- function(client_id, bearer_token, body = 'fields *;limit 500;'){
  res = POST(
    url = "https://api.igdb.com/v4/genres",
    add_headers(`Client-ID` = client_id, Authorization = bearer_token),
    body = body
  )
  
  data = fromJSON(rawToChar(res$content)) %>% return()
}

get_igdb_games <- function(client_id, bearer_token, body = 'fields *; search "Mario"; limit 500;'){
  res = POST(
    url = "https://api.igdb.com/v4/games",
    add_headers(`Client-ID` = client_id, Authorization = bearer_token),
    body = body
  )
  
  data = fromJSON(rawToChar(res$content)) %>% return()
}

get_igdb_involved_companies <- function(client_id, bearer_token, body = 'fields *;where id = (8775,8776,8777);limit 500;'){
  res = POST(
    url = "https://api.igdb.com/v4/involved_companies",
    add_headers(`Client-ID` = client_id, Authorization = bearer_token),
    body = body
  )
  
  data = fromJSON(rawToChar(res$content)) %>% return()
}

get_igdb_company <- function(client_id, bearer_token, body = 'fields *;where id = (70,1760,1025);limit 500;'){
  res = POST(
    url = "https://api.igdb.com/v4/companies",
    add_headers(`Client-ID` = client_id, Authorization = bearer_token),
    body = body
  )
  
  data = fromJSON(rawToChar(res$content)) %>% return()
}

get_igdb_platform <- function(client_id, bearer_token, body = 'fields *;limit 500;'){
  res = POST(
    url = "https://api.igdb.com/v4/platforms",
    add_headers(`Client-ID` = client_id, Authorization = bearer_token),
    body = body
  )
  
  data = fromJSON(rawToChar(res$content)) %>% return()
}
