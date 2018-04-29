checkConsistency <- function(x){
  x<-as.data.frame(apply(x,2,as.factor))
  message('Checking consistency: taxa with more than one parent will be printed...')
  errors=0
  for(t in levels(x$Species)){
    if(length(levels(droplevels(x[which(x$Species==t),'Genus'])))>1){
      errors=errors+1
      message(paste('Species',t,'has',length(levels(droplevels(x[which(x$Species==t),'Genus']))),'parents'))
    }
  }
  for(t in levels(x$Genus)){
    if(length(levels(droplevels(x[which(x$Genus==t),'Family'])))>1){
      errors=errors+1
      message(paste('Genus',t,'has',length(levels(droplevels(x[which(x$Genus==t),'Family']))),'parents'))
    }
  }
  for(t in levels(x$Family)){
    if(length(levels(droplevels(x[which(x$Family==t),'Order'])))>1){
      errors=errors+1
      message(paste('Family',t,'has',length(levels(droplevels(x[which(x$Family==t),'Order']))),'parents'))
    }
  }
  for(t in levels(x$Order)){
    if(length(levels(droplevels(x[which(x$Order==t),'Class'])))>1){
      errors=errors+1
      message(paste('Order',t,'has',length(levels(droplevels(x[which(x$Order==t),'Class']))),'parents'))
    }
  }
  for(t in levels(x$Class)){
    if(length(levels(droplevels(x[which(x$Class==t),'Phylum'])))>1){
      errors=errors+1
      message(paste('Class',t,'has',length(levels(droplevels(x[which(x$Class==t),'Phylum']))),'parents'))
    }
  }
  for(t in levels(x$Phylum)){
    if(length(levels(droplevels(x[which(x$Phylum==t),'Kingdom'])))>1){
      errors=errors+1
      message(paste('Phylum',t,'has',length(levels(droplevels(x[which(x$Phylum==t),'Kingdom']))),'parents'))
    }
  }
  if(errors==0){
    message('All good. Taxon tree is fully consistent')
  }else{
    message(paste('Number of incosistencies found:',errors))
    message('Please check the taxa listed above and try again')
  }
}
