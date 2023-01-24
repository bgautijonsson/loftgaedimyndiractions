writeLines("---------------\nRunning no2_yearly_klst_max.R\n---------------")

p3 <- d |>
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
  ggplot(aes(dags, fj_yfir_klst)) +
  geom_texthline(
    yintercept = 18,
    label = "Hámarksfjöldi á ári (18x)",
    lty = 2,
    alpha = 0.4,
    linewidth = 0.4
  ) +
  geom_line() +
  # facet_wrap("station_name") +
  scale_y_continuous(
    limits = c(0, 60),
    expand = expansion(),
    labels = label_number(suffix = " sinnum")
  ) +
  theme(
    plot.subtitle = element_text(size = 12)
  ) +
  labs(
    x = NULL,
    y = NULL,
    title = "Hversu oft hefur NO2 farið yfir klukkustundarmörkin undanfarið ár?",
    subtitle = "Leyfilegt klukkustundargildi er allt að 200 míkrógrömm á rúmmetra",
    caption = caption
  )


ggsave(
  plot = p3,
  filename = "Figures/fj_klst.png",
  width = 8, height = 0.621 * 8, scale = 1.3
)
