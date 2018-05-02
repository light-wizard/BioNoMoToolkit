yield_expeditions<-function(artfish.units.final){
  out<-as.data.frame(matrix(NA,length(unique(artfish.units.final$id_exp)),4))
  colnames(out)<-c('id_exp','start','end','itinerary')
  te=length(unique(artfish.units.final$id_exp))
  message(paste(te,'total expeditions to be processed'))
  x=0
  state=0
  for(exped in 1:length(unique(artfish.units.final$id_exp))){
    x=x+1
    out[exped,]<-
      head(artfish.units.final[which(artfish.units.final$id_exp==
                                       unique(artfish.units.final$id_exp)[exped]),c(10,15,16,17)],1)
    prog=floor(x/te*100)
    if(prog%%10==0 & prog!=state){
      message(paste(prog, '%  completed'))
      state=prog
    }
  }
  return(out)
}
