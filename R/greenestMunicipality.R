# Michiel Blok and Madeleine van Winkel (TheScripties)
# 9 January 2015


# Preprocessing function to prepare the data for calculations -------------
preprocessing <- function() {
  # Download and unzip files ------------------------------------------------  
  download.file(url = "https://github.com/GeoScripting-WUR/VectorRaster/raw/gh-pages/data/MODIS.zip" , destfile = "data/MODIS.zip", , quiet = TRUE, method = 'auto')
  unzip(zipfile = "data/MODIS.zip" , exdir = "data." , overwrite = TRUE)
  NLD.municipalities <- getData('GADM', country = 'NLD', level = 3)
  
  # Load the data in R ------------------------------------------------------  
  MODIS.data <- list.files(path = "data./", pattern = glob2rx('MOD*.grd'), full.names = TRUE)
  MODIS.raster <- brick(MODIS.data)
  MODIS.raster[MODIS.raster < 0] <- NA
  
  # Perform the coordinate transformation to WGS84 --------------------------
  municipalities.CRS <- spTransform(NLD.municipalities, CRS(proj4string(MODIS.raster)))
  
  # Perform mask and crop ---------------------------------------------------
  MODIS.mask <- mask(MODIS.raster, municipalities.CRS)
  MODIS.crop <- crop(MODIS.mask, municipalities.CRS)
  
  MODIS.municipalities <- c("MODIS.crop" = MODIS.crop, "municipalities.CRS" = municipalities.CRS)  
  return(MODIS.municipalities)
}

# Calculate the greenness of the municipalities ---------------------------
calculation <- function(MODIS.municipalities) {
  
  # Create time period variables --------------------------------------------  
  January <- MODIS.municipalities$MODIS.crop[[1]]
  August <- MODIS.municipalities$MODIS.crop[[8]]
  meanYear <- mean(MODIS.municipalities$MODIS.crop, na.rm = TRUE)
  
  # Perform extraction ------------------------------------------------------
  MODIS.jan <- extract(x = January, y = MODIS.municipalities$municipalities.CRS, fun = mean, df = TRUE, sp = TRUE)
  MODIS.aug <- extract(August, MODIS.municipalities$municipalities.CRS, fun = mean, df = TRUE, sp = TRUE)
  MODIS.year <- extract(meanYear, MODIS.municipalities$municipalities.CRS, fun = mean, df = TRUE, sp = TRUE)
  
  # Calculate greenness per time period -------------------------------------  
  greenness.jan <- max(MODIS.jan@data$NAME_2[MODIS.jan@data$January == max(MODIS.jan@data$January, na.rm = TRUE)], na.rm = TRUE)
  greenness.aug <- max(MODIS.aug@data$NAME_2[MODIS.aug@data$August == max(MODIS.aug@data$August, na.rm = TRUE)], na.rm = TRUE)
  greenness.year <- max(MODIS.year@data$NAME_2[MODIS.year@data$layer == max(MODIS.year@data$layer, na.rm = TRUE)], na.rm = TRUE)
  
  calculation.result <- c("MODIS.jan" = MODIS.jan, "MODIS.aug" = MODIS.aug, "MODIS.year" = MODIS.year, "greenness.jan" = greenness.jan, "greenness.aug" = greenness.aug, "greenness.year" = greenness.year)
  return(calculation.result)
}

# Visualize the greenest municipalities per given time period -------------
visualization <- function(calculation.result) {
  
  #opar <- par(mfrow = c(1, 3)) ## This should work, but unfortunately does not work on spplot.
  spplot(calculation.result$MODIS.jan, zcol = 'January', main = paste("Greenness per municipality in January \n (Greenest municipality:",  calculation.result$greenness.jan, ")"), col.regions = colorRampPalette(c("#E5FFCC", "#003300"))(20))
  spplot(calculation.result$MODIS.aug, zcol = 'August', main = paste("Greenness per municipality in August \n (Greenest municipality:",  calculation.result$greenness.aug, ")"), col.regions = colorRampPalette(c("#E5FFCC", "#003300"))(20))
  spplot(calculation.result$MODIS.year, zcol = 'layer', main = paste("Greenness per municipality per year \n (Greenest municipality:",  calculation.result$greenness.year, ")"), col.regions = colorRampPalette(c("#E5FFCC", "#003300"))(20))
  #par(opar) ## This should work, but unfortunately does not work on spplot.
  
  return()
} 