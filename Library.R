list.of.packages <- c("tidyverse", "lubridate","patchwork","rjson","rcrossref","janitor")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
library("tidyverse");library("lubridate");library("patchwork");library("rjson");library("rcrossref");library("janitor")



theme_set(theme(panel.background = element_blank(),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                legend.text = element_text(size = 14),
                legend.title = element_text(size = 14),
                legend.position = "bottom",
                plot.title = element_text(hjust = 0.5), 
                axis.text = element_text(size = 12),
                axis.title = element_text(size = 14),
                strip.background = element_rect(fill = "white"),
                panel.border = element_rect(colour = "black", fill=NA),
                legend.key = element_rect(fill = "NA",color = "white"),
                legend.background = element_rect(color = "white"),
                axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0), angle = 90),
                axis.title.y.right = element_text(margin = margin(t = 0, r = 0, b = 0, l = 10)),
                strip.placement = "outside",
                strip.text = element_text(size = 14),
                strip.text.x = element_blank()))

sem <- function(x) sd(x,na.rm=T)/sqrt(length(x[!is.na(x)]))


options(scipen=9999)