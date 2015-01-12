# Michiel Blok and Madeleine van Winkel (TheScripties)
# 2015-09-12

preprocessing <- function() {
  download.file(url = "https://github.com/GeoScripting-WUR/VectorRaster/raw/gh-pages/data/MODIS.zip" , destfile = "data/MODIS.zip", , quiet = TRUE, method = 'auto')
  unzip(zipfile = "data/MODIS.zip" , exdir = "data." , overwrite = TRUE)
  NLD.municipalities <- getData('GADM', country = 'NLD', level = 3)
  
  MODIS.data <- list.files(path = "data./", pattern = glob2rx('MOD*.grd'), full.names = TRUE)
  MODIS.raster <- brick(MODIS.data)
  MODIS.raster[MODIS.raster < 0] <- NA

  # Perform the coordinate transformation to WGS84
  municipalities.CRS <- spTransform(NLD.municipalities, CRS(proj4string(MODIS.raster)))

  MODIS.mask <- mask(MODIS.raster, municipalities.CRS)
  MODIS.crop <- crop(MODIS.mask, municipalities.CRS)
  
  MODIS.municipalities <- c("MODIS.crop" = MODIS.crop, "municipalities.CRS" = municipalities.CRS)
  
  return(MODIS.municipalities)
}

calculation <- function(landsatMunicipalities) {
  January <- landsatMunicipalities$landsat[[1]]  
  August <- landsatMunicipalities$landsat[[8]]
  
  MODIS.NLD <- extract(MODIS, municipalitiesCRS, fun = mean, df = TRUE, sp = TRUE)
  
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