taxonLookupTable_ID <- function(x){
  # Calculate the number of unique values
  totaltaxa<-length(c(levels(x$Kingdom),levels(x$Phylum),levels(x$Class),levels(x$Order),
                      levels(x$Family),levels(x$Genus),levels(x$Species)))
  #print(totaltaxa)
  # Output matrix
  lookup<-matrix(NA,totaltaxa,7)
  colnames(lookup)<-c('id','Taxon','Rank','Author','Source','Parent','OrigID')
  # Keep trace of the record number
  key=0
  # Start from 'Kingdom' level
  for(k in levels(x$Kingdom)){
    key=key+1
    #print(key)
    # Keep trace of parent Kingdom id
    parentvalue=key
    lookup[key,]<-c(key,k,'Kingdom',NA,NA,parentvalue,NA)
    # Select unique values from Phylum rank
    phyla<-levels(droplevels(x[which(x$Kingdom==k),'Phylum']))
    for(p in phyla){
      key=key+1
      #print(key)
      lookup[key,]<-c(key,p,'Phylum',NA,NA,parentvalue,NA)
      parentphylum=key
      classes<-levels(droplevels(x[which(x$Phylum==p),'Class']))
      for(cl in classes){
        key=key+1
        lookup[key,]<-c(key,cl,'Class',NA,NA,parentphylum,NA)
        parentclass=key
        orders<-levels(droplevels(x[which(x$Class==cl),'Order']))
        for(o in orders){
          key=key+1
          lookup[key,]<-c(key,o,'Order',NA,NA,parentclass,NA)
          parentorder=key
          families<-levels(droplevels(x[which(x$Order==o),'Family']))
          for(f in families){
            key=key+1
            lookup[key,]<-c(key,f,'Family',NA,NA,parentorder,NA)
            parentfamily=key
            genuses<-levels(droplevels(x[which(x$Family==f),'Genus']))
            for(g in genuses){
              key=key+1
              lookup[key,]<-c(key,g,'Genus',NA,NA,parentfamily,NA)
              parentgenus=key
              species<-levels(droplevels(x[which(x$Genus==g),'Species']))
              for(s in species){
                key=key+1
                author<-as.character(x[which(x$Species==s),'Author'])
                src<-as.character(x[which(x$Species==s),'Source'])
                origid<-as.character(x[which(x$Species==s),'id'])
                lookup[key,]<-c(key,s,'Species',author,src,parentgenus,origid)
              }
            }
          }
        }
      }
    }
  }
  return(as.data.frame(lookup))
}

# Select unique values from taxon rank
# levels(droplevels(specieslist.final[which(specieslist.final$Family=='Euphorbiaceae'),]$Genus))