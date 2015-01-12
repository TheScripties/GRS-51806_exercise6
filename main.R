# Michiel Blok and Madeleine van Winkel
# 9 January 2015

# Set working directory
#setwd()

# Import packages
library(raster)
library(rgdal)
library(sp)

# Source functions
source('R/greenestMunicipality.R')

# Then the actual commands
MODIS.municipalities <- preprocessing()
calculation.result <- calculation(MODIS.municipalities)
visualization(calculation.result)