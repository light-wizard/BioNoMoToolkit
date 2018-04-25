authority_search <- function(taxoncatalogue){
  require(ritis)
  require(taxize)
  for(i in 1:length(taxoncatalogue$Taxon)){
    if(is.na(taxoncatalogue$Author[i])){
      taxoncatalogue$Author[i]<-tryCatch(as.character(taxon_authorship(tsn=as.numeric(get_tsn(taxoncatalogue$Taxon[i])[1]))[1,1]),
                                         error=function(err){
                                           if(err[1]=='Column index must be at most 0 if positive, not 1'){
                                             message(cat('Taxon not found:',as.character(taxoncatalogue$Taxon[i])))
                                           } else {
                                             message(err)
                                           }
                                           return(NA)
                                         })
      }
    }
  return(taxoncatalogue)
}
