#' Create a Spatial Grid from the list of longitude and latitude
#'
#' @param lon_list A list of longitudes
#' @param lat_list A list of latitudes
#' @param hemisphere Either 'north' or 'south'
#' @param outputShape Path to the output shapefile
#' @param interval Desired interval for the grid in meter
#' @return A spatial grid shapefile
#' @examples
#' \dontrun{
#' library(SpatGRID)
#' lon_list<-c(78,78,79,79,78)
#' lat_list<-c(20,21,21,20,20)
#' hemisphere <- 'north'
#' outputShape <- 'C:\\path\\to\\your\\data\\grid.shp'
#' interval <- 1000
#' Spatial_GRID <- SpatialGridR(lon_list, lat_list, hemisphere, interval, outputShape)
#' }
#' @references
#' 1. Brus,D.J.(2022). Spatial Sampling with R (1st ed.).Chapman and Hall/CRC.<DOI:10.1201/9781003258940>
#' 2. Hijmans, R. J. (2022). raster: Geographic Data Analysis and Modeling. R package version 3.5-13.
#' @export
#' @import raster
#' @import sp
#' @import sf
#' @import qpdf
#'
SpatialGridR<- function(lon_list, lat_list, hemisphere, interval,outputShape) {

  # Check if longitude vector list is within -180 to +180 range
  if (any(lon_list < -180 | lon_list > 180)) {
    stop("Longitude values should be between -180 and 180.")
  }

  # Check if latitude vector list is within -90 to +90 range
  if (any(lat_list < -90 | lat_list > 90)) {
    stop("Latitude values should be between -90 and 90.")
  }

  # Create a polygon from the longitude and latitude coordinates
  xy_list<-cbind(lon_list,lat_list)
  polygon <- Polygon(xy_list)

  # Create EPSG code
  # Check if hemisphere is valid
  valid_hemispheres <- c("north", "south")
  if (!(hemisphere %in% valid_hemispheres)) {
    stop("Invalid hemisphere. Use 'north' or 'south'.")
  }
  # Determine the third integer based on hemisphere
  hemisphere_code <- ifelse(hemisphere == "north", 6, 7)

  # Calculate the UTM zone based on longitude list
  # Extract the first value from the list
  first_value <- lon_list[1]
  # Divide the first value by 6
  divided_value <- first_value / 6
  # Round towards the left integer value
  rounded_value <- floor(divided_value)
  # Add the rounded value to 31
  utm_zone <- rounded_value + 31

  # Create EPSG code
  epsg_code <- paste0("EPSG:32", hemisphere_code, sprintf("%02d", utm_zone))

  # Create a spatial object from the polygon
  ps=Polygons(list(polygon),1)
  sps<-SpatialPolygons(list(ps))
  proj4string(sps)=CRS("EPSG:4326")
  data=data.frame(f=99.9)
  spdf<-SpatialPolygonsDataFrame(sps,data)

  # Check the current CRS of the input shapefile
  current_crs <- st_crs(spdf)

  # If the current CRS is not UTM, transform the shapefile
  if (current_crs$proj != "+proj=utm") {
    newDataa <- spTransform(spdf, epsg_code)
  }

  ## Create grid
  grid<-makegrid(newDataa, cellsize = interval) # cellsize in map units
  # grid is a dataframe, first convert grid into a spatial point dataframe
  gridd<-SpatialPoints(grid,proj4string =CRS(epsg_code))

  # Save as shapefile
  grid_shape<- shapefile(x=gridd,file= outputShape, overwrite=TRUE)
  return( grid_shape)
}
