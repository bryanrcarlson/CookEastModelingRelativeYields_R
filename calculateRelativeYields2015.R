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
inputFile <- "Input/HY2015GP_GrainWeightOnly_171020.csv"
harvestYear <- 2015
yield.proj4string <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

# Load data
strips <- readOGR("Input/Field_Plan_Final", "Field_Plan_Final")
refPoints <- geojson_read("Input/CookEast_GeoreferencePoints_171117.json", what = "sp")
boundary <- geojson_read("Input/CookEastBoundary_171106.json", what = "sp")
y <- read.csv(inputFile, stringsAsFactors = TRUE)


# Clean data
#y08 <- y08[!is.na(y08$GrainWeightWet), ]
#y08 <- droplevels(y08)
#y15 <- y15[!is.na(y15$GrainWeightWet), ]
#y15 <- droplevels(y15)
y <- y[!is.na(y$GrainWeightWet), ]
y <- droplevels(y)
strips@data$Crop = NULL
strips@data$Area = NULL
strips@data$Perimeter = NULL
strips@data$Area_ac = NULL
strips@data$Ind_Field = NULL

# Convert csv gain mass data to spatial points and specify the datum
#y08sp <- SpatialPoints(y08[,5:6], proj4string = CRS("+proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"))
#y08sp <- SpatialPointsDataFrame(y08sp, y08)
#y15sp <- SpatialPoints(y15[,6:5], proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
#y15sp <- SpatialPointsDataFrame(y15sp, y15)

ysp <- SpatialPoints(y[,6:5], proj4string=yield.proj4string)
ysp <- SpatialPointsDataFrame(ysp, y)

# Get data in WGS84
WGS84 <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
strips.WGS84 <- spTransform(strips, WGS84)
#y08sp <- spTransform(y08sp, WGS84)
ysp <- spTransform(ysp, WGS84)

# Remove unwanted fields from strip file
strips.WGS84 <- raster::intersect(boundary, strips.WGS84)

# Calculate relative yields for 2008
#rel.yields <- subset(y08sp, FALSE)
#rel.yields$StripMean
#rel.yields$RelativeYield
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "A", 1))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "A", 2))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "A", 3))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "A", 4))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "A", 5))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "A", 6))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "B", 1))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "B", 2))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "B", 3))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "B", 4))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "B", 5))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "B", 6))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "C", 1))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "C", 2))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "C", 3))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "C", 4))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "C", 5))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "C", 6))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "C", 7))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y08sp, strips.WGS84, "C", 8))

# Calculate relative yields for 2015
#rel.yields <- subset(y15sp, FALSE)
#rel.yields$RelativeYield
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "A", 1))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "A", 2))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "A", 3))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "A", 4))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "A", 5))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "A", 6))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "B", 1))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "B", 2))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "B", 3))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "B", 4))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "B", 5))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "B", 6))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "C", 1))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "C", 2))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "C", 3))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "C", 4))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "C", 5))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "C", 6))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "C", 7))
#rel.yields <- rbind(rel.yields, calculate_relative_yield(y15sp, strips.WGS84, "C", 8))

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

#write.csv(rel.yields@data, "Output/hy2015relativeYields.csv", row.names=FALSE)
#write.csv(rel.yields@data, "Output/hy2008relativeYields.csv", row.names=FALSE)
write.csv(rel.yields@data, paste("Output/hy",toString(harvestYear),"relativeYields.csv",sep=""), row.names=FALSE)



#---- Maps and testing ----
graphCols <- c("purple", "chartreuse", "blue", "yellow", "red", "green", "sandybrown")

plot(strips.WGS84)
plot(rel.yields, pch=21, bg=graphCols[rel.yields$Crop], col=graphCols[rel.yields$Crop], cex=0.8, add=T)

plot(y08sp, pch=21, bg=graphCols[y08sp$Crop], col=graphCols[y08sp$Crop], cex=0.8, add=T)
plot(refPoints, add=T)

t <- strips.WGS84[strips.WGS84$Field == "C" & strips.WGS84$Strip == 1,]
#point.in.polygon(y08sp$Easting, y08sp$Northing, t@polygons[[1]]@Polygons[[1]]@coords[,1], t@polygons[[1]]@Polygons[[1]]@coords[,2])
j <- over(t, y08sp)
j <- SpatialPoints(j[,5:6], proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
#jj <- unname(over(t, y08sp))
d <- SpatialPointsDataFrame(y08sp, j)
d <- SpatialPoints(j[,5:6], proj4string = CRS("+proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"))
d <- SpatialPointsDataFrame(d, j)
d <- spTransform(d, WGS84)
plot(d,add=T)


# Func test
poly <- strips.WGS84[strips.WGS84$Field == "A" & strips.WGS84$Strip == 1,]
y <- sp::over(poly, y08sp)
ysp <- SpatialPoints(y[,5:6], proj4string = CRS("+proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"))
ysp <- SpatialPointsDataFrame(ysp, y)
WGS84 <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
ysp <- spTransform(ysp, WGS84)

ysp.mean <- mean(ysp$GrainWeightWet)
ysp$StripMean <- ysp.mean
ysp$RelativeYield <- ysp$GrainWeightWet / ysp.mean
ysp


# fcn test points in poly
t <- strips.WGS84[strips.WGS84$Field == "A" & strips.WGS84$Strip == 1,]
#tt <- y08sp[point.in.polygon(y08sp$Easting, y08sp$Northing, t@polygons[[1]]@Polygons[[1]]@coords[,1], t@polygons[[1]]@Polygons[[1]]@coords[,2]),]
tt <- point.in.poly(y08sp, t)
plot(strips.WGS84)
plot(tt, add=T)
