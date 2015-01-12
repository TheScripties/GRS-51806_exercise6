# Michiel Blok and Madeleine van Winkel (TheScripties)
# 2015-09-12

preprocessing <- function() {
  #download.file(url = "https://github.com/GeoScripting-WUR/VectorRaster/raw/gh-pages/data/MODIS.zip" , destfile = "data/MODIS.zip", method = 'auto')
  #unzip(zipfile = "data/MODIS.zip" , exdir = "data." , overwrite = TRUE)

  MODISdata <- list.files(path = "data./", pattern = glob2rx('MOD*.grd'), full.names = TRUE)
  landsat <- brick(MODISdata)
  landsat[landsat < 0] <- NA
  
  # Define CRS object for RD projection
  prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")
  # Perform the coordinate transformation from WGS84 to RD
  landsatRD <- spTransform(landsat, prj_string_RD)
  
  NLDmunicipalities <- getData('GADM', country = 'NLD', level = 3)
  
  
  #rasterMunicipalities <- rasterize(NLDmunicipalities, landsat, field = NLDmunicipalities$NAME_2, background = NA)
  #plot(rasterMunicipalities) #DELETE LINE
  #maskGreenness <- mask(landsat, )
  extract(landsat, NLDmunicipalities, fun = 'mean', df = TRUE, sp = TRUE)
  landsatMunicipalities <- c("landsat" = landsat, "municipalities" = rasterMunicipalities)
  
  return(landsatMunicipalities)
}

calculation <- function(landsatMunicipalities) {
  January <- landsatMunicipalities$landsat[[1]]  
  August <- landsatMunicipalities$landsat[[8]]
  
  meanYear <- mean(landsatMunicipalities$landsat)
  opar <- par(mfrow = c(2, 7))
  plot(landsatMunicipalities$landsat)
  plot(meanYear)
  par(opar)
  
  jan
  
  aug
  
  
  greenness <- c()
  return(greenness)
}

#par()
#mask(inverse = TRUE)