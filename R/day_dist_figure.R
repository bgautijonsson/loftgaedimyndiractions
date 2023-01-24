writeLines("---------------\nday_dist_figure.R\n---------------")

plot_dat <- d |>
    filter(
        station_name == "Grensásvegur",
        dagsetning >= date_build(2022, 11, 01)
    ) |>
    select(dagsetning, no2) |>
    mutate(
        klst = hour(dagsetning),
        dags = as_date(dagsetning),
        no2 = pmax(no2, 0),
        no2 = na.approx(no2, na.rm = FALSE)
    ) |>
    drop_na()


p5 <- plot_dat |>
    ggplot(aes(dags, klst, fill = no2)) +
    geom_raster() +
    scale_x_date(
        breaks = date_breaks("month"),
        labels = my_date_labels,
        expand = expansion()
    ) +
    scale_y_continuous(
        breaks = c(0, 4, 8, 12, 16, 20, 23),
        labels = label_number(suffix = ":00"),
        expand = expansion()
    ) +
    scale_fill_distiller(
        palette = "RdBu",
        breaks = c(
            0,
            max(plot_dat$no2, na.rm = T),
            100,
            200
        ),
        labels = label_number(accuracy = 1),
        guide = guide_colorbar(
            barheight = unit(0.3, "npc")
        )
    ) +
    theme(
        legend.title = element_text(size = 10),
        legend.text = element_text(size = 8)
    ) +
    labs(
        x = NULL,
        y = NULL,
        fill = "NO2",
        title = "Hvenær dags mælist köfnunartvíoxíð (NO2) hæst?",
        subtitle = NULL,
        caption = caption
    )


ggsave(
    p5,
    filename = "Figures/day_dist.png",
    width = 8, height = 0.5 * 8, scale = 1.3
)
