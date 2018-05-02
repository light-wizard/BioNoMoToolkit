remove_duplicates <- function(artfish.units.initial){
  ir=nrow(artfish.units.initial)
  message(paste(ir, 'initial records to be processed'))
  message('This may take some time: please wait...')
  artfish.units <- as.data.frame(matrix(NA,ir,7))
  colnames(artfish.units)<-c('Date','id_CenPes','id_GM','id_Sp','sex','count','weight')
  artfish.units.initial$Id_CenPes<-as.factor(artfish.units.initial$Id_CenPes)
  artfish.units.initial$Id_Arte<-as.factor(artfish.units.initial$Id_Arte)
  artfish.units.initial$Id_EspLog<-as.factor(artfish.units.initial$Id_EspLog)
  artfish.units.initial$Sex_Esp<-as.factor(artfish.units.initial$Sex_Esp)
  artfish.units.initial$DateF<-as.factor(artfish.units.initial$DateF)
  getmode <- function(x) {
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
  }
  x=0
  for(d in levels(artfish.units.initial$DateF)){
    #print(d)
    for(c in levels(droplevels(artfish.units.initial$Id_CenPes[which(artfish.units.initial$DateF==d)]))){
      #print(c)
      for(s in levels(droplevels(artfish.units.initial$Id_EspLog[which(artfish.units.initial$DateF==d &
                                                             artfish.units.initial$Id_CenPes==c)]))){
        #print(s)
        subset=artfish.units.initial[which(artfish.units.initial$DateF==d &
                                             artfish.units.initial$Id_CenPes==c &
                                             artfish.units.initial$Id_EspLog==s),]
        #print(str(subset))
        x=x+1
        artfish.units$Date[x]<-d
        artfish.units$id_CenPes[x]<-c
        artfish.units$id_Sp[x]<-s
        artfish.units$id_GM[x]<-as.character(getmode(subset$Id_Arte))
        artfish.units$sex[x]<-as.character(getmode(subset$Sex_Esp))
        artfish.units$count[x]<-sum(subset$Num_AmoEsp)
        artfish.units$weight[x]<-sum(subset$Peso_AmoEsp)
        if(x%%1000==0){
            message(paste(x, 'records generated'))
        }
      }
    }
  }
  message(paste('Total records:', x))
  return(artfish.units[-which(is.na(artfish.units$Date)),])
}
