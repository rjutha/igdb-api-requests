library(tidyverse)
library(readxl)

sheet_num = readxl::excel_sheets("Completed Games.xlsx") %>% length

load_excel_sheets <- function(sheet_num){
  read_xlsx("Completed Games.xlsx", sheet = sheet_num) %>%
    select(1:14) %>% 
    filter(!is.na(Name)) %>%
    mutate(
      `Date Start` = as.Date(`Date Start`),
      `Date Complete` = as.Date(`Date Complete`),
      Time = case_when(
        is.na(Hours) ~ NA,
        TRUE ~ paste(Hours, str_pad(Minutes, 2, pad = "0"), str_pad(Seconds, 2, pad = "0"), sep = ':'))
    ) %>%
    select(Name, Platform, Rank, Time,  `Date Start`, `Date Complete`, `Genre`, `Replay`, `Dropped`, `Grind`, `Multiplayer`) %>%
    arrange(desc(`Date Start`), Name)
}

1:sheet_num %>% map_df(load_excel_sheets) -> completed_games
