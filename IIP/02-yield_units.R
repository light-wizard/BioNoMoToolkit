yield_units<-function(artfish.units){
  out<-artfish.units
  out$DateF<-as.factor(out$Date)
  out$Id_CenPesF<-as.factor(out$id_CenPes)
  out$id_exp<-NA
  out$id_agent<-NA
  out$id_gmt<-NA
  out$id_taxon<-NA
  out$id_site<-NA
  out$start<-NA
  out$end<-NA
  out$itinerary<-NA
  exped=0
  message('Processing expeditions: this may take some time...')
  for(d in levels(out$DateF)){
    for(p in levels(droplevels(out$Id_CenPesF[which(out$DateF==d)]))){
      #print(d)
      #print(p)
      exped=exped+1
      out$id_exp[which(out$DateF==d & out$Id_CenPesF==p)]<-exped
      out$id_agent[which(out$DateF==d & out$Id_CenPesF==p)]<-
        saidas$id_agent[which(saidas$dateF==d & saidas$Id_CenPes==p)]
      out$start[which(out$DateF==d & out$Id_CenPesF==p)]<-
        as.character(saidas$start[which(saidas$dateF==d & saidas$Id_CenPes==p)])
      out$end[which(out$DateF==d & out$Id_CenPesF==p)]<-
        as.character(saidas$end[which(saidas$dateF==d & saidas$Id_CenPes==p)])
      out$itinerary[which(out$DateF==d & out$Id_CenPesF==p)]<-
        as.character(saidas$itinerary[which(saidas$dateF==d & saidas$Id_CenPes==p)])
      if(exped%%1000==0){
          message(paste(exped, 'expeditions processed...'))
      }
    }
  }
  message(paste('Total expeditions:',exped))
  message('Processing gathering methods...')
  for(g in levels(as.factor(out$id_GM))){
    out$id_gmt[which(out$id_GM==g)]<-
      lookup_gatheringmethods$id_gmt[which(lookup_gatheringmethods$orig_id==g)]
  }
  message('Processing taxa...')
  for(s in levels(as.factor(out$id_Sp))){
    if(length(lookup_taxoncatalogue$id[which(lookup_taxoncatalogue$OrigID==s)])==1){
      out$id_taxon[which(out$id_Sp==s)]<-
        lookup_taxoncatalogue$id[which(lookup_taxoncatalogue$OrigID==s)]
    }else{
      out$id_taxon[which(out$id_Sp==s)]<-NA
    }
  }
  message('Processing gathering sites...')
  for(cp in levels(out$Id_CenPesF)){
    out$id_site[which(out$Id_CenPesF==cp)]<-
      gathering_sites$id_site[which(gathering_sites$orig_id==cp)]
  }
  message('Process completed')
  return(out)
}
