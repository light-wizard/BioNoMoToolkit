checkConsistency <- function(x){
  for(t in levels(x$Species)){
    if(length(levels(droplevels(x[which(x$Species==t),'Genus'])))>1){
      print(cat(t,length(levels(droplevels(x[which(x$Species==t),'Genus'])))))
    }
  }
  for(t in levels(x$Genus)){
    if(length(levels(droplevels(x[which(x$Genus==t),'Family'])))>1){
      print(cat(t,length(levels(droplevels(x[which(x$Genus==t),'Family'])))))
    }
  }
  for(t in levels(x$Family)){
    if(length(levels(droplevels(x[which(x$Family==t),'Order'])))>1){
      print(cat(t,length(levels(droplevels(x[which(x$Family==t),'Order'])))))
    }
  }
  for(t in levels(x$Order)){
    if(length(levels(droplevels(x[which(x$Order==t),'Class'])))>1){
      print(cat(t,length(levels(droplevels(x[which(x$Order==t),'Class'])))))
    }
  }
  for(t in levels(x$Class)){
    if(length(levels(droplevels(x[which(x$Class==t),'Phylum'])))>1){
      print(cat(t,length(levels(droplevels(x[which(x$Class==t),'Phylum'])))))
    }
  }
  for(t in levels(x$Phylum)){
    if(length(levels(droplevels(x[which(x$Phylum==t),'Kingdom'])))>1){
      print(cat(t,length(levels(droplevels(x[which(x$Phylum==t),'Kingdom'])))))
    }
  }
}