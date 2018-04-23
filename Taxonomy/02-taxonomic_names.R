get_tree <- function(specieslist, db='dynamic'){
  require(taxize)
  if(db!='dynamic'){
    cdb=db
  }
  speciestable <- as.data.frame(matrix(NA,length(specieslist$species),11))
  colnames(speciestable) <- c('kingdom','phylum','class','order','family',
                              'genus','species','source','origID','notes','origSp')
  x=0
  for(s in specieslist$species){
    x=x+1
    speciestable$origSp[x] <- s
    speciestable$source[x] <- as.character(
      specieslist[x,'source'])
    speciestable$origID[x] <- as.character(
      specieslist[x,'origID'])
    if(db=='dynamic'){
      cdb=tolower(as.character(
        specieslist[x,'source']))
    }
    classif <- tryCatch(classification(s, db = cdb),error=function(err){
      message(err)
      return(NA)
    })
    if(is.na(classif)){
      speciestable[x,1:6] <- c(NA,NA,NA,NA,NA,NA)
      speciestable[x,'notes'] <- 'NOT FOUND'
    } else {
      classif <- as.data.frame(classif[[1]])
      for(r in colnames(speciestable[1:7])){
        tryCatch(speciestable[[r]][x] <- classif[['name']][
          which(tolower(classif[['rank']])==r)],error=function(err){
            speciestable[x,'notes'] <- 'ERROR'
          })
      }
    }
  }
  speciestable$notes[which(speciestable$species!=speciestable$origSp)] <- 'INCONGRUENCE'
  speciestable$notes[which(is.na(speciestable$species) & is.na(speciestable$notes))] <- 'ERROR'
  return(speciestable)
}