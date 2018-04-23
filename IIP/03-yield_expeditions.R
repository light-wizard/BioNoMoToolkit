yield_expeditions<-function(artfish.units.final){
  out<-as.data.frame(matrix(NA,length(unique(artfish.units.final$id_exp)),4))
  colnames(out)<-c('id_exp','start','end','itinerary')
  for(exped in 1:length(unique(artfish.units.final$id_exp))){
    out[exped,]<-
      head(artfish.units.final[which(artfish.units.final$id_exp==
                                       unique(artfish.units.final$id_exp)[exped]),c(10,15,16,17)],1)
  }
  return(out)
}
