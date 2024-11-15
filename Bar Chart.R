
ggplot(q1,aes(group,len,color=group,fill=group))+geom_bar(stat="summary",fun=mean,position="dodge",width =0.4,colour = "black")+stat_summary(fun.data = 'mean_sd', geom = "errorbar", width = 0.2,position = position_dodge(0.2))+theme_bw()+ scale_fill_manual(values = c('#C4C4C4','#1663A9','#F2CC8E','#F0FAEF',"#82B29A",'#DF7A5E'))+geom_jitter(width = 0.2, height = 0.2)+scale_color_manual(values = c('#C4C4C4','#1663A9','#F2CC8E','#F0FAEF',"#82B29A",'#DF7A5E'))+theme_classic()

或
ggplot(q1,aes(group,len,color=group,fill=group))+geom_bar(stat="summary",fun=mean,position="dodge",width =0.4,colour = "black")+stat_summary(fun.data = 'mean_sd', geom = "errorbar", width = 0.2,position = position_dodge(0.2))+theme_bw()+ scale_fill_manual(values = c('#C4C4C4','#1663A9','#F2CC8E','#4593FF',"#82B29A",'#DF7A5E'))+geom_jitter(width = 0.2, height = 0.2,size=4)+scale_color_manual(values = c('#C4C4C4','#1663A9','#F2CC8E','#4593FF',"#82B29A",'#DF7A5E'))+theme_classic()

ggscatter(q4, x= "V1", y = "V2", color = "group", palette = "Set1", ellipse = T,ellipse.type = "convex",ggtheme = theme_minimal()) + labs(x = "PCoA1 (26.85%)", y = "PCoA2 (15.25%)")

 q<- read.table("clipboard",sep='\t', header=T)
 ggplot(q,aes(x=sample,y=len,fill=group))+geom_bar(stat="identity")+scale_fill_brewer(palette="Pastel1")