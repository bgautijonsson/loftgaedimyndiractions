writeLines("---------------\nRunning pm10_yearly_klst_max.R\n---------------")

p6 <- d |>
  filter(
    station_name == "Grensásvegur"
  ) |>
  select(station_name, dagsetning, pm10) |>
  group_by(station_name, dags = as_date(dagsetning)) |>
  summarise(
    mean = mean(pm10, na.rm = T)
  ) |>
  arrange(dags) |>
  drop_na() |>
  group_by(station_name) |>
  mutate(
    fj_yfir_dag = slide_dbl(
      mean,
      ~ sum(.x > 50),
      .before = 364, .complete = F
    )
  ) |>
  ggplot(aes(dags, fj_yfir_dag)) +
  geom_texthline(
    yintercept = 35,
    label = "Hámarksfjöldi á ári (35x)",
    lty = 2,
    alpha = 0.4,
    linewidth = 0.4
  ) +
  geom_line() +
  # facet_wrap("station_name") +
  scale_y_continuous(
    limits = c(0, NA),
    expand = expansion(),
    labels = label_number(suffix = " sinnum")
  ) +
  theme(
    plot.subtitle = element_text(size = 12)
  ) +
  labs(
    x = NULL,
    y = NULL,
    title = "Hversu oft hefur gróft svifryk farið yfir klukkustundarmörkin undanfarið ár?",
    subtitle = "Leyfilegt sólarhringsmeðaltal er allt að 50 míkrógrömm á rúmmetra",
    caption = caption
  )

p6

