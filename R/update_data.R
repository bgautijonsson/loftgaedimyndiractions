stations = tribble(
  ~station_name, ~station_number,
  "Grensásvegur", 35,
  "Úlfársdalur", 70,
  "Laugarnes", 113,
  "Lundur", 115,
  "Norðlingaholt", 50,
  "Vesturbæjarlaug", 78
)

read_fun <- function(date_from, date_to, station_number) {
  glue("https://loftgaedi.is/station/csv?filter%5Btype%5D=INDICATOR&filter%5BcancelSearch%5D=&filter%5BstationId%5D={station_number}&filter%5BindicatorId%5D%5B0%5D=1&filter%5BindicatorId%5D%5B1%5D=3&filter%5BindicatorId%5D%5B2%5D=4&filter%5BindicatorId%5D%5B3%5D=11&filter%5BindicatorId%5D%5B4%5D=21&filter%5BindicatorId%5D%5B5%5D=33&filter%5BindicatorId%5D%5B6%5D=73&filter%5BindicatorId%5D%5B7%5D=74&filter%5BindicatorId%5D%5B8%5D=76&filter%5BdateFrom%5D={date_from}&filter%5BdateUntil%5D={date_to}&filter%5BsubmitHit%5D=1&filter%5BindicatorIds%5D=1%2C3%2C4%2C11%2C21%2C33%2C73%2C74%2C76") |> 
    read_csv2()
}

d <- vroom(
  "Data/loftgaedi_reykjavik.csv"
)


d_new <- stations |> 
  crossing(
    from = max(d$dagsetning) |> as_date(),
  ) |> 
  mutate(
    to = Sys.Date()
  ) |> 
  mutate_at(vars(from, to), format, "%d.%m.%Y") |> 
  mutate(
    data = pmap(list(from, to, station_number), read_fun)
  ) |> 
  filter(
    map_dbl(data, nrow) > 0
  ) |> 
  select(station_name, data) |> 
  unnest(data) |> 
  clean_names()

bind_rows(
  d_new |> anti_join(d, by = "dagsetning"),
  d
) |> 
  write_csv("Data/loftgaedi_reykjavik.csv")
