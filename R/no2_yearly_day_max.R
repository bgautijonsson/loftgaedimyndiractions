writeLines("---------------\nno2_yearly_day_max.R\n---------------")

p4 <- d |>
  filter(
    station_name == "Grensásvegur"
  ) |>
  select(station_name, dagsetning, no2) |>
  group_by(station_name, dags = as_date(dagsetning)) |>
  summarise(
    fj_yfir = sum(no2 >= 200, na.rm = T),
    mean = mean(no2, na.rm = T)
  ) |>
  arrange(dags) |>
  drop_na() |>
  group_by(station_name) |>
  mutate(
    fj_yfir_klst = slide_dbl(
      fj_yfir,
      sum,
      .before = 364, .complete = F
    ),
    fj_yfir_dag = slide_dbl(
      mean,
      ~ sum(.x > 75),
      .before = 364, .complete = F
    ),
  ) |>
  ggplot(aes(dags, fj_yfir_dag)) +
  geom_texthline(
    yintercept = 7,
    label = "Hámarksfjöldi á ári (7x)",
    lty = 2,
    alpha = 0.4,
    linewidth = 0.4,
    hjust = 0.7
  ) +
  geom_line() +
  # facet_wrap("station_name") +
  scale_y_continuous(
    limits = c(0, 20),
    expand = expansion(),
    labels = label_number(suffix = " sinnum")
  ) +
  labs(
    x = NULL,
    y = NULL,
    title = "Hversu oft hefur sólarhringsmeðaltal NO2 farið yfir mörkin undanfarið ár?",
    subtitle = "Sólarhringsheilsuverndarmörkin eru allt að 75 míkrógrömm á rúmmetra",
    caption = caption
  )


ggsave(
  plot = p4,
  filename = "Figures/fj_day.png",
  width = 8, height = 0.621 * 8, scale = 1.3
)
