library(dplyr)
library(tidyr)
library(purrr)
library(readr)
library(clock)
library(glue)
library(janitor)
library(lubridate)
library(ggtext)
library(geomtextpath)
library(vroom)
library(ggplot2)
library(metill)
library(stringr)
library(slider)
library(loftgaedi)
theme_set(theme_metill())
Sys.setlocale("LC_ALL", "is_IS.UTF-8")

my_date_labels <- function(dates) {
  dagur <- day(dates)
  ifelse(
    dagur == 1,
    format(dates, "%d\n%B"),
    format(dates, "%d")
  )
}


caption <- str_c(
  "Byggt á gögnum frá loftgaedi.is",
  "\n",
  "Gögn og kóði: https://github.com/bgautijonsson/loftgaedimyndir"
)

if (!file.exists("Data/loftgaedi_reykjavik.csv")) {
  source("R/get_data.R")
} else {
  source("R/update_data.R")
}

source("R/make_figures.R")


