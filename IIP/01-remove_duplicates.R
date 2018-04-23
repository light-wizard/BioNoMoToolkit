remove_duplicates <- function(artfish.units.initial){
  artfish.units <- as.data.frame(matrix(NA,132273,7))
  colnames(artfish.units)<-c('Date','id_CenPes','id_GM','id_Sp','sex','count','weight')
  x=0
  for(d in levels(artfish.units.initial$DateF)){
    for(c in levels(droplevels(artfish.units.initial[which(artfish.units.initial$DateF==d),
                                                     'Id_CenPes']))){
      for(s in levels(droplevels(artfish.units.initial[which(artfish.units.initial$DateF==d &
                                                             artfish.units.initial$Id_CenPes==c),'Id_EspLog']))){
        subset=artfish.units.initial[which(artfish.units.initial$DateF==d &
                                             artfish.units.initial$Id_CenPes==c &
                                             artfish.units.initial$Id_EspLog==s),]
        x=x+1
        print(x)
        artfish.units$Date[x]<-d
        artfish.units$id_CenPes[x]<-c
        artfish.units$id_Sp[x]<-s
        artfish.units$id_GM[x]<-as.character(getmode(subset$Id_Arte))
        artfish.units$sex[x]<-as.character(getmode(subset$Sex_Esp))
        artfish.units$count[x]<-sum(subset$Num_AmoEsp)
        artfish.units$weight[x]<-sum(subset$Peso)
      }
    }
  }
  return(artfish.units)
}
