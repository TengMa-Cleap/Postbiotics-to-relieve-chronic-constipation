library(ggplot2)
> library(ggpubr)
> library(ade4)

data <- read.table("clipboard",sep='\t', header=T, row.names=1, check=F, comment='')
View(data)
 dist.bray <- vegdist(data, method = "bray", binary=FALSE, diag=FALSE, upper=FALSE, na.rm = FALSE) 
 bray <- as.matrix(dist.bray) 
 View(bray) 
 dist.bray <- vegdist(t(data), method = "bray", binary=FALSE, diag=FALSE, upper=FALSE, na.rm = FALSE) 
 bray <- as.matrix(dist.bray) 

group <- read.table("clipboard", sep = '\t', header = T)
nmds1 <- metaMDS(bray, k = 2) 
nmds1 <- metaMDS(bray, k = 2) 
sample_site <- data.frame(nmds1$point)
sample_site$names <- rownames(sample_site)
names(sample_site)[1:2] <- c('NMDS1', 'NMDS2')
write.csv(points,file="11.csv")
sample_site <- merge(sample_site, group, by = 'names', all.x = TRUE)
write.csv(sample_site,file="sample_site.csv")
sample_site<-read.table("clipboard",row.names=1, header=T, sep="\t")


sample_site$group<-factor(sample_site$group,levels=c("0d","3d","7d","14d","21d"))

ggplot(sample_site, aes(NMDS1, NMDS2, group = group)) + geom_point(aes(color = group, shape = group), size = 3.5, alpha = 0.8) + 
	scale_shape_manual(values = c(17, 16, 15，18,20)) + 
	scale_colour_brewer(palette="Dark2") + 
		theme(panel.grid = element_blank(), panel.background = element_rect(color = 'black', fill = 'transparent')) + 
		theme(legend.key = element_rect(fill = 'transparent'), legend.title = element_blank()) + 
			labs(x = 'NMDS axis1', y = 'NMDS axis2', title = paste('Stress =', round(nmds1$stress, 4))) + theme(plot.title = element_text(hjust = 0.5))
