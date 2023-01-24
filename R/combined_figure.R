writeLines("---------------\nRunning combined_figure.R\n---------------")
layout <- '
AB
CD
EE
EE
'

asp <- 0.8
heights <- c(1, 1, 0.6)

p <- (p1 + labs(caption = NULL)) +
  (p2 + labs(caption = NULL)) +
  (p3 + labs(caption = NULL)) +
  (p4 + labs(caption = NULL)) +
  p5 +
  plot_layout(ncol = 2, design = layout, heights = heights) &
  theme(
    plot.title = element_text(size = 15)
  )

ggsave(
  plot = p,
  filename = "Figures/combined_image.png",
  width = 8, height = asp * 8, scale = 2
)



p <- (p1 + labs(caption = NULL)) +
  (p2 + labs(caption = NULL)) +
  (p3 + labs(caption = NULL)) +
  (p4 + labs(caption = NULL)) +
  p5 +
  plot_layout(ncol = 2, design = layout) &
  theme(
    plot.title = element_text(size = 15),
    plot.background = element_blank(),
    panel.background = element_blank(),
    legend.background = element_blank()
  )




ggsave(
  plot = p,
  filename = "Figures/combined_image_page.png",
  width = 8, height = asp * 8, scale = 2
)
