p <- d |> 
  filter(
    station_name == "Grensásvegur"
  ) |> 
  select(station_name, dagsetning, no2) |> 
  group_by(station_name, dags = as_date(dagsetning)) |> 
  summarise(
    fj_yfir = sum(no2 >= 200, na.rm = T),
    daily_mean = mean(no2, na.rm = T)
  ) |> 
  arrange(dags) |> 
  drop_na() |> 
  group_by(station_name) |> 
  mutate(
    yearly_mean = slide_dbl(
      daily_mean,
      mean,
      .before = 364,
      .complete = F
    ),
  ) |> 
  ggplot(aes(dags, yearly_mean)) +
  geom_texthline(
    yintercept = 40,
    label = "Leyfilegt ársmeðaltal",
    lty = 2,
    alpha = 0.4,
    linewidth = 0.4,
    hjust = 0.7
  ) +
  geom_line() +
  # facet_wrap("station_name") +
  scale_y_continuous(
    limits = c(0, 50),
    expand = expansion(),
    labels = label_number()
  ) +
  labs(
    x = NULL,
    y = NULL,
    title = "Hvert er meðaltal NO2 mælinga undanfarið ár?",
    subtitle = "Ársmörkin eru eru allt að 40 míkrógrömm á rúmmetra",
    caption = caption
  )


ggsave(
  plot = p,
  filename = "Figures/yearly_mean.png",
  width = 8, height = 0.5 * 8, scale = 1.3
)
