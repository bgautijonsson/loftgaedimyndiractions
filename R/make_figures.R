day_stop <- day(Sys.Date())

d <- vroom("Data/loftgaedi_reykjavik.csv")


source("R/no2_klst_max.R")
source("R/no2_daily_mean.R")
source("R/no2_yearly_klst_max.R")
source("R/no2_yearly_day_max.R")
source("R/day_dist_figure.R")
source("R/combined_figure.R")
