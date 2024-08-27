# Create figure S
# Load tidyverse
library("tidyverse")
library(openxlsx)
library("ggthemes")
# Set working directory

setwd("C:\\Users\\B059633\\Dropbox\\Work\\Research\\Projects\\Gender Econ\\submissions\\PUS\\Final edits for PUS\\Replication Package")
# Load data reorder
df<-read_csv("data\\igm_data.csv")%>%
  arrange(female_agreedisagree)%>%
  mutate(rank_female=row_number())%>%
  arrange(abs(contrast))%>%
  mutate(rank_contrast=row_number())


dfag<-rbind(df%>%mutate(view=male_agreedisagree,group="Male"),
            df%>%mutate(view=female_agreedisagree,group="Female"))%>%
          mutate(q=str_replace(q,"Question A:",""),
                 q=str_replace(q,"Question B:",""),
                 group2=ifelse(group=="Male"," Male",group)
                 )
    
# create chart

dfag<-dfag%>%mutate(labelfemale=ifelse(group=="Male",
                                       " ", paste("",sprintf(view, fmt = '%#.2f'),
                                                  "\nN=",n_female,sep="" )),
                    labelmale=ifelse(group!="Male",
                                     " ", paste("",sprintf(view, fmt = '%#.2f'),
                                                "\nN=",n_male,sep="" )))

ggplot(dfag%>%filter(rank<14),
       aes(x=reorder(stringr::str_wrap(q, 75),
                     rank_female),y=view,fill=group2))+
  theme_bw()+
  geom_text(aes(label=labelfemale), nudge_y = 0.05,hjust=0,
            size=4)+
  geom_text(aes(label=labelmale),  nudge_y = -0.05,hjust=1,
            size=4)+
  geom_col(alpha=1)+
  coord_flip()+
  scale_fill_grey()+
  theme(axis.line.x=element_line(color="black"),
        legend.position = "top",
        axis.text.y = element_text(size=11,hjust=0,color="black"),
        axis.text.x = element_text(size=13),
        axis.ticks.y = element_blank(),
        axis.title.x = element_text(size=14),
        legend.text = element_text(size=14),
        panel.border = element_blank())+
  ylim(-1,1.5)+
  labs(fill="", x=" ", y="View \n Disagree                                                           Agree")


ggsave("output/figure_Sa.png",height = 11,width=10)



ggplot(dfag%>%filter(rank>13),
       aes(x=reorder(stringr::str_wrap(q, 75),
                     rank_female),y=view,fill=group))+
  theme_bw()+
  geom_text(aes(label=labelfemale), nudge_y = -0.035,hjust=1,
            size=4)+
  geom_text(aes(label=labelmale),  nudge_y = 0.035,hjust=0,
            size=4)+
  geom_col(alpha=1)+
  coord_flip()+
  scale_fill_grey()+
  theme(axis.line.x=element_line(color="black"),
        legend.position = "top",
        axis.text.y = element_text(size=11,hjust=0,color="black"),
        axis.text.x = element_text(size=13),
        axis.ticks.y = element_blank(),
        axis.title.x = element_text(size=14),
        legend.text = element_text(size=14),
        panel.border = element_blank())+
  ylim(-0.75,1)+
  labs(fill="", x=" ", y="View \n Disagree                                                           Agree")


ggsave("output/figure_Sb.png",height = 11,width=10)
