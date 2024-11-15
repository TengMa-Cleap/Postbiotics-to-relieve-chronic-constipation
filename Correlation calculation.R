library(rmcorr)
library(dplyr)
setwd("C:/Users/yangni/Desktop")

mp = read.table("clipboard", sep="\t", header=T)

vir_sh <-read.table("clipboard", header=T, sep="\t")
bac_sh <-read.table("clipboard", header=T, sep="\t")

## All
all_data = merge(bac_sh, vir_sh) %>% merge(mp)
all_corr = rmcorr(Group, Bac_shannon, Vir_shannon, all_data)

## plot corr
ggplot(all_data, aes(x = Bac_shannon, y = Vir_shannon, group = factor(Time), color=factor(Time))) + geom_point(size=3) + geom_line(aes(y = all_corr$model$fitted.values), linetype = 1)