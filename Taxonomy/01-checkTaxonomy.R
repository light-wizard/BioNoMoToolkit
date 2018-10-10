checkTaxonomy <- function(specieslist,fir=1,las=5,src="NCBI", ctry=NULL, cont="Africa") {
  library(psych)
  library(data.table)
  library(taxize)
  library(ggplot2)
  library(rgbif)
  library(leaflet)
  if(is.data.frame(specieslist)){
    nameslist <- as.vector(specieslist[fir:las,1]) 
  }else{
    nameslist<-as.vector(specieslist)
  }
  res <- tnrs(nameslist, getpost="POST", source=src)
  res
  selected <- subset(res, score>0.5)
  message('Check results')
  print(selected)
  splist <- as.character(selected$matchedname)
  keys <- vapply(splist, function(x) name_suggest(x)$key[1], numeric(1), USE.NAMES=F)
  gbifdata <- occ_data(keys, country=ctry, continent=cont, limit=300)
  #return(gbifdata)
  if(length(nameslist)>1){
    mapdata <- rbindlist(lapply(gbifdata, function(z) z$data), fill=T, use.names=T)
  }else{
    mapdata <- rbindlist(gbifdata, fill=T, use.names=T)
  }
  #gbifmap(mapdata,region="Mozambique") + ggtitle('Species present in the area') ## DEPRECATED
  occurrence <- dplyr::rename(mapdata, latitude = decimalLatitude, longitude = decimalLongitude)
  occurrence$label <- paste0(occurrence$scientificName," ~ ", "Year: ", occurrence$year,
                             " ~ ", "ID: ", occurrence$occurrenceID)
  ngroups<-length(unique(occurrence$scientificName))
  pal <- colorFactor(topo.colors(ngroups),occurrence$scientificName)
  k <- leaflet::leaflet(occurrence) %>%
    addTiles() %>%
    addCircleMarkers(~longitude, ~latitude, popup = occurrence$label,
                     radius=4, weight=2, opacity=0.5, fill=T, fillOpacity=0.2,
                     color= ~pal(scientificName)) %>%
    addLegend("bottomright", pal = pal, values = ~scientificName,
              title = "Species present in the area",
              opacity = 1)
  k
}
