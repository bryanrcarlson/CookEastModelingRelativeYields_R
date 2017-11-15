# Author: Bryan Carlson
# Contact: bryan.carlson@ars.usda.gov
# Purpose: Calculate relative yields using "average" normalization method bounded by strips

# Setup project
library(rgdal)
library(geojsonio)
library(jsonlite)
#library(jqr)

#library(sp)
#library(rgdal)
#library(dismo)
#library(gstat)

setwd("C:\\Dev\\Projects\\CookEastModelingRelativeYields\\R")

# Load data
strips <- readOGR("Input/Field_Plan_Final", "Field_Plan_Final")
#refPoints.j <- fromJSON(readLines("Input/CookEast_GeoreferencePoints_20171117.json"))
refPoints <- geojson_read("Input/CookEast_GeoreferencePoints_171117.json", what = "sp")
boundary <- geojson_read("Input/CookEastBoundary_171106.json", what = "sp")
y15 <- read.csv("Input/HY2015GP_GrainWeightOnly_171020.csv", stringsAsFactors = TRUE)

# Clean data
y15 <- y15[!is.na(y15$GrainWeightWet), ]
y15 <- droplevels(y15)

# Convert csv gain mass data to spatial points and specify the datum
y15sp <- SpatialPoints(y15[,6:5], proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs"))
y15sp <- SpatialPointsDataFrame(y15sp, y15)

# Get data in WGS84
WGS84 <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
strips.WGS84 <- spTransform(strips, WGS84)

# Remove unwanted fields from strip file
strips.WGS84 <- raster::intersect(boundary, strips.WGS84)



graphCols <- c("purple", "chartreuse", "blue", "yellow", "red", "green", "sandybrown")

plot(strips.WGS84)
plot(y15sp, pch=21, bg=graphCols[y15sp$Crop], col=graphCols[y15sp$Crop], cex=0.8, add=T)
plot(refPoints, add=T)
