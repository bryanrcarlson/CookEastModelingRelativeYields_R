# Author: Bryan Carlson
# Contact: bryan.carlson@ars.usda.gov
# Purpose: Calculate relative yields using "average" normalization method bounded by strips

# ---- Setup ----
library(rgdal)
library(geojsonio)
library(jsonlite)
library(spatialEco)

setwd("C:\\Dev\\Projects\\CookEastModelingRelativeYields\\R")

# ---- Functions ----
#' Creates a IDW map of yield values from grain weight
#' @param yields SpatialPointsDataFrame with yield (or grain weight) values to be normalized.  Assumed column name is "GrainWeightWet".
#' @param strips SpatialPolygonsDataFrame of the field and strips that intersect with yields.  Assumed column names: "Field", "Strip".
#' @param fieldId String indicating field ID: "A", "B", or "C".
#' @param stripId Number indicating strip ID: 1-6 for fields A and B, 1-8 for field C
calculate_relative_yield <- function(yields, strips, fieldId, stripId) {
  poly <- strips[strips$Field == fieldId & strips$Strip == stripId,]
  y <- point.in.poly(yields, poly)
  
  y.mean <- mean(y$GrainWeightWet)
  y$StripMean <- y.mean
  y$RelativeYield <- y$GrainWeightWet / y.mean
  y
}


# ---- Main ----
# Parameters
utmZone11n <- CRS("+proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
WGS84 <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

#inputFile <- "Input/HY1999GP_CopiedFromRYAvg_171117.csv"
#harvestYear <- 1999
#yield.proj4string <- utmZone11n

#inputFile <- "Input/HY2008GP_CopiedFromRYAvg_171117.csv"
#harvestYear <- 2008
#yield.proj4string <- utmZone11n

#inputFile <- "Input/HY2013GP_GrainWeightOnly_171117.csv"
#harvestYear <- 2013
#yield.proj4string <- WGS84

#inputFile <- "Input/HY2015GP_GrainWeightOnly_171117.csv"
#harvestYear <- 2015
#yield.proj4string <- WGS84

# For 2016, see "calculateRelativeYields2016.R"

# Load data
strips <- readOGR("Input/Field_Plan_Final", "Field_Plan_Final")
refPoints <- geojson_read("Input/CookEast_GeoreferencePoints_171117.json", what = "sp")
boundary <- geojson_read("Input/CookEastBoundary_171106.json", what = "sp")
y <- read.csv(inputFile, stringsAsFactors = TRUE, skip = 1)


# Clean data
y <- y[!is.na(y$GrainWeightWet), ]
y <- droplevels(y)
strips@data$Crop = NULL
strips@data$Area = NULL
strips@data$Perimeter = NULL
strips@data$Area_ac = NULL
strips@data$Ind_Field = NULL

# Convert csv gain mass data to spatial points and specify the datum
ysp <- SpatialPoints(y[,6:5], proj4string=yield.proj4string)
ysp <- SpatialPointsDataFrame(ysp, y)

# Get data in WGS84
#WGS84 <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
strips.WGS84 <- spTransform(strips, WGS84)
#y08sp <- spTransform(y08sp, WGS84)
ysp <- spTransform(ysp, WGS84)

# Remove unwanted fields from strip file
strips.WGS84 <- raster::intersect(boundary, strips.WGS84)

# Calculate relative yields
rel.yields <- subset(ysp, FALSE)
rel.yields$StripMean
rel.yields$RelativeYield
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "A", 1))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "A", 2))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "A", 3))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "A", 4))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "A", 5))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "A", 6))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "B", 1))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "B", 2))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "B", 3))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "B", 4))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "B", 5))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "B", 6))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "C", 1))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "C", 2))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "C", 3))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "C", 4))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "C", 5))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "C", 6))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "C", 7))
rel.yields <- rbind(rel.yields, calculate_relative_yield(ysp, strips.WGS84, "C", 8))

# Cleanup
rel.yields$FID = NULL

write.csv(rel.yields@data, paste("Output/hy",toString(harvestYear),"relativeYields.csv",sep=""), row.names=FALSE)

# Plot
graphCols <- c("purple", "chartreuse", "blue", "yellow", "red", "green", "sandybrown")
plot(strips.WGS84)
plot(rel.yields, pch=21, bg=graphCols[rel.yields$Crop], col=graphCols[rel.yields$Crop], cex=0.8, add=T)

