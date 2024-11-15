library(mixOmics)

a<- read.table("clipboard",sep='\t', header=T, row.names=1, check=F, comment='')

group =read.table("clipboard", header=T,sep = "\t")

b<-t(a)
df_plsda<-plsda(b,group$group,ncomp=2)
plotIndiv(df_plsda , comp = c(1,2),group = group$group, style = 'ggplot2',ellipse = T,  size.xlabel = 20, size.ylabel = 20, size.axis = 20, pch = 16, cex = 5)

df <- unclass(df_plsda)

df1 = as.data.frame(df$variates$X)
df1$group = group$group
df1$samples = rownames(df1)
 explain = df$prop_expl_var$X
x_lable <- round(explain[1],digits=3)
y_lable <- round(explain[2],digits=3)

col=c("#D5695D","#F5B041","#F6DA65","#8AB1D2","#53BE80","#91DFD0","#8A7067")


 ggplot(df1,aes(x=comp1,y=comp2,color=group,shape=group))+theme_bw()+geom_point(size=1.8)+labs(x=paste0("P1 (",x_lable*100,"%)"), y=paste0("P2 (",y_lable*100,"%)"))+stat_ellipse(data=df1, geom = "polygon",level = 0.9,linetype = 2,size=0.5, aes(fill=group),  alpha=0.2,show.legend = T)+  scale_color_manual(values = col)+scale_fill_manual(values = c("#D5695D","#F5B041","#F6DA65","#8AB1D2","#53BE80","#91DFD0","#8A7067"))
