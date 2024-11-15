library(ggplot2)
> library(ggpubr)
> library(ade4)

#导入丰度文件
data <- read.table("clipboard",sep='\t', header=T, row.names=1, check=F, comment='')##原始丰度文件
View(data)
 dist.bray <- vegdist(data, method = "bray", binary=FALSE, diag=FALSE, upper=FALSE, na.rm = FALSE) 
 bray <- as.matrix(dist.bray) ## 得到bray距离文件，对角线格式
 View(bray) 
 dist.bray <- vegdist(t(data), method = "bray", binary=FALSE, diag=FALSE, upper=FALSE, na.rm = FALSE) ##将菌与菌之间改为样本与样本之间，PCOA处理的就是样本与样本之间的关系
 bray <- as.matrix(dist.bray) #得到距离文件

#导入分组文件
group <- read.table("clipboard", sep = '\t', header = T)
nmds1 <- metaMDS(bray, k = 2) 
nmds1 <- metaMDS(bray, k = 2) 
sample_site <- data.frame(nmds1$point)
sample_site$names <- rownames(sample_site)
names(sample_site)[1:2] <- c('NMDS1', 'NMDS2')
write.csv(points,file="11.csv")
sample_site <- merge(sample_site, group, by = 'names', all.x = TRUE)
write.csv(sample_site,file="sample_site.csv")#注意上一步表格合成后：样品名、NMDS1、NMDS2、group 如果不对，需要导出整理，再导入
sample_site<-read.table("clipboard",row.names=1, header=T, sep="\t")

#改变坐标排序
sample_site$group<-factor(sample_site$group,levels=c("0d","3d","7d","14d","21d"))

ggplot(sample_site, aes(NMDS1, NMDS2, group = group)) + geom_point(aes(color = group, shape = group), size = 3.5, alpha = 0.8) + #可在这里修改点的透明度、大小
	scale_shape_manual(values = c(17, 16, 15，18,20)) + #可在这里修改点的形状,样品分组是几个就设置对应形状
	scale_colour_brewer(palette="Dark2") + #可在这里修改点的颜色
		theme(panel.grid = element_blank(), panel.background = element_rect(color = 'black', fill = 'transparent')) + #去掉背景框
		theme(legend.key = element_rect(fill = 'transparent'), legend.title = element_blank()) + #去掉图例标题及标签背景
			labs(x = 'NMDS axis1', y = 'NMDS axis2', title = paste('Stress =', round(nmds1$stress, 4))) + theme(plot.title = element_text(hjust = 0.5))