## -----------------------------------------------------------------------------
## **Installation and loading the library of SpatGRID R package**
# You can install the SpatGRID package from CRAN using the following command:
# install.packages("SpatialGRID")
# Once installed, you can load the package using
  # library(SpatGRID)
## Data Input

# The first step is to prepare the data. The function `SpatialGridR` requires two lists:
# lon_list` - a list of longitudes, and `lat_list` - a list of latitudes.
# Ensure that your longitude values are within the range of -180 to +180, and latitude values are within the range of -90 to +90.

# Example:
# lon_list<-c(78,78,79,79,78)
# lat_list<-c(20,21,21,20,20)

## Setting Parameters for Generating Spatial Grid
# The `SpatialGridR` function requires several parameters:
# - `hemisphere`: Specify either 'north' or 'south'.
# - `outputShape`: Provide the path to the output shapefile.
# - `interval`: Define the desired interval for the grid in meters.

# Example:
#  hemisphere <- 'north'
#  outputShape <- 'C:\\path\\to\\your\\data\\grid.shp'
#  interval <- 1000

## Creating the Spatial Grid:
# Now, let's use the `SpatialGridR` function to generate the spatial grid of desired size
 
# Spatial_GRID <- SpatialGridR(lon_list, lat_list, hemisphere, interval, outputShape)

## Load the grid shapefile
# library(raster)
# library(SpatGRID)
# sample_grid<- shapefile("D:\\grid.shp")

## Plot the GRID
# plot(sample_grid, main = "Spatial GRID", col = "darkblue")


