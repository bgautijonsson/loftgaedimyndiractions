writeLines("---------------\nRunning day_dist_figure.R\n---------------")

hour_col <- "#bd1c14"

day_col <- "#b48100"

start_date <- floor_date(Sys.Date() - dmonths(3), "day")

plot_dat <- d |>
    filter(
        station_name == "Grensásvegur",
        dagsetning >= start_date
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
    ggplot(aes(dags, klst, fill = no2, alpha = no2)) +
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
    scale_fill_gradient2(
        # palette = "RdYlGn",
        low = "#00522c",
        mid = "#ffe7bd",
        high = "#990024",
        midpoint = 75,
        breaks = c(
            0,
            max(plot_dat$no2, na.rm = T),
            75,
            200
        ),
        labels = c(
            0,
            max(plot_dat$no2, na.rm = T) |> round(),
            "75\n(Dagsmörk)",
            "200\n(Klstmörk)"
        ),
        guide = guide_colorbar(
            barwidth = unit(0.3, "npc"),
            barheight = unit(0.017, "npc"),
            title.vjust = 0.8,
            label.hjust = 0.5,
            label.vjust = 1,
            ticks = T,
            ticks.colour = "#111111"
        )
    ) +
    scale_alpha_continuous(
        range = c(1, 1),
        guide = guide_legend()
    ) +
    guides(
        alpha = FALSE
    ) +
    theme(
        legend.title = element_text(size = 10, face = "bold"),
        legend.text = element_text(size = 9, face = "bold"),
        legend.position = c(0.6, 1.08),
        legend.direction = "horizontal",
        legend.margin = margin(),
        legend.box.margin = margin(),
        plot.subtitle = element_markdown(size = 12, margin = margin(b = 10)),
        plot.caption = element_text(vjust = 18, hjust = 1, margin = margin()),
        plot.caption.position = "plot",
        plot.margin = margin(t = 10, r = 5, b = 5, l = 5)
    ) +
    labs(
        x = NULL,
        y = NULL,
        fill = NULL,
        title = "Hvenær dags mælist köfnunartvíoxíð (NO2) hæst?",
        subtitle = glue(
            str_c(
                "Leyfilegt <b>klukkustundargildi</b> er allt að ",
                "<b style=color:{hour_col}>",
                "200 míkrógrömm",
                "</b>",
                " á rúmmetra<br>",
                "Meðaltal <b>yfir heilan dag</b> má vera allt að ",
                "<b style=color:{day_col}>",
                "75 míkrógrömm ",
                "</b>",
                " á rúmmetra"
            )
        ),
        caption = caption
    )


