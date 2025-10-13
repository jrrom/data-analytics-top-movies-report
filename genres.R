library(dplyr)
library(tidyr)
library(stringr)

# Function to separate genre lists into individual rows
separate_genres <- function(data, genre_col) {
  data |>
    mutate({{ genre_col }} := str_remove_all({{ genre_col }}, "\\[|\\]|'")) |>
    separate_rows({{ genre_col }}, sep = ",\\s*")
}
