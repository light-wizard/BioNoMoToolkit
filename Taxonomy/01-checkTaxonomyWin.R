checkTaxonomy <- function(specieslist,fir=1,las=5,src="NCBI") {
  library(psych)
  library(data.table)
  library(taxize)
  library(ggplot2)
  library(rgbif)
  nameslist <- as.vector(specieslist[fir:las,1])
  res <- tnrs(nameslist, getpost="POST", source=src)
  res
  selected <- subset(res, score>0.5)
  message('Check results')
  print(selected)
  splist <- as.character(selected$matchedname)
  keys <- vapply(splist, function(x) name_suggest(x)$key[1], numeric(1), USE.NAMES=F)
  gbifdata <- occ_data(keys, continent='Africa', limit=300)
  mapdata <- rbindlist(lapply(gbifdata, function(z) z$data), fill=T, use.names=T)
  gbifmap(mapdata) + ggtitle('Species present in the area')
}
