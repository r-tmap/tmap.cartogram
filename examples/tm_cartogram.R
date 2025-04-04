library(tmap)

Africa = World[World$continent == "Africa", ]

tm_shape(Africa, crs = "+proj=robin") +
  tm_cartogram_ncont(size = "pop_est", options = opt_tm_cartogram_ncont())

\donttest{
tm_shape(Africa, crs = "+proj=robin") +
  tm_cartogram(size = "pop_est", options = opt_tm_cartogram(itermax = 15))

tm_shape(World, crs = "+proj=robin") +
  tm_polygons() +
  tm_cartogram_ncont(size = "pop_est", fill = "yellow")

# with animation
tm_shape(Africa, crs = "+proj=robin") +
  tm_cartogram(
    size = "*pop_est",
    fill = "footprint", options = opt_tm_cartogram(itermax = 15))
}
