writeLines("---------------\nRunning no2_daily_mean.R\n---------------")

colour_2023 <- "black"

colour_other <- "grey70"


plot_dat <- d |>
  filter(
    station_name == "Grensásvegur"
  ) |>
  mutate(
    month = month(dagsetning),
    day = day(dagsetning),
    year = year(dagsetning),
    yday = yday(dagsetning),
    plot_date = clock::date_build(year = plot_year, month = month, day = day)
  ) |>
  filter(yday <= day_stop) |>
  group_by(year, month, day, plot_date, yday, station_name) |>
  summarise(
    max = max(no2, na.rm = T),
    mean = mean(no2, na.rm = T),
    .groups = "drop"
  ) |>
  drop_na() |>
  mutate(
    colour = ifelse(year == 2023, colour_2023, colour_other),
    linewidth = ifelse(year == 2023, 1, 0)
  )

p2 <- plot_dat |>
  ggplot(aes(plot_date, mean)) +
  geom_texthline(
    yintercept = 75,
    lty = 2,
    alpha = 0.3,
    size = 4,
    linewidth = 0.3,
    label = "Dagsmörk",
    hjust = 0.3
  ) +
  geom_line(
    data = plot_dat |> filter(year != 2023),
    aes(group = year, col = colour, linewidth = linewidth),
    alpha = 0.6
  ) +
  geom_point(
    data = plot_dat |> filter(year != 2023),
    aes(group = year, col = colour, size = linewidth),
    alpha = 0.6
  ) +
  geom_line(
    data = plot_dat |> filter(year == 2023),
    aes(group = year, col = colour, linewidth = linewidth)
  ) +
  geom_point(
    data = plot_dat |> filter(year == 2023),
    aes(group = year, col = colour, size = linewidth)
  ) +
  scale_x_date(
    breaks = date_breaks("day"),
    labels = my_date_labels,
    expand = expansion(add = 0.2)
  ) +
  scale_y_continuous(
    limits = c(0, 200),
    expand = expansion(),
    breaks = c(0, 50, 75, 100, 150, 200)
  ) +
  scale_colour_identity() +
  scale_linewidth_continuous(
    range = c(1, 1.3)
  ) +
  scale_size_continuous(
    range = c(2, 3.5)
  ) +
  theme(
    legend.position = "none",
    plot.subtitle = element_markdown(size = 12),
  ) +
  labs(
    x = NULL,
    y = NULL,
    title = "Daglegt meðaltal köfnunarefnisdíoxíðsmælinga (NO2)",
    subtitle = str_c(
      "Sýnt fyrir fyrstu daga janúar árið ",
      glue("<b style='color:{colour_2023}'>"),
      "2023 ",
      "</b>",
      "borið saman við  ",
      glue("<b style='color:{colour_other}'>"),
      "2019 til 2022",
      "</b>"
    ),
    caption = caption
  )

ggsave(
  plot = p2,
  filename = "Figures/no2_mean.png",
  width = 8, height = 0.621 * 8, scale = 1.3
)
