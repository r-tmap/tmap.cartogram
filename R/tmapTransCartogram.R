#' Cartogram transformation
#'
#' @param shpTM,size,ord__,plot.order,args,scale tmap internals
#' @return list of two. The first is a spatial object, the second the tmap ID codes
#' @export
#' @keywords internal
tmapTransCartogram = function(shpTM, size, ord__, plot.order, args, scale) {
	s = shpTM$shp

	# bypass cartogram error; use warning instead
	isll = sf::st_is_longlat(s)
	if (isll) {
		llcrs = sf::st_crs(s)
		warning("tm_cartogram requires projected coordinates, not longlat degrees. A projected CRS can be specified in tm_shape (argument crs)", call. = FALSE)
		s = sf::st_set_crs(s, NA)
	}

	message("Cartogram in progress...")

	x = sf::st_sf(geometry = s, weight = size, tmapID__ = shpTM$tmapID)
	x = x[x$weight > 0,]


	if (args$type == "cont") {
		shp = suppressMessages(suppressWarnings({cartogram::cartogram_cont(x, weight = "weight", itermax = args$itermax)}))
	} else if (args$type == "ncont") {
		shp = suppressMessages(suppressWarnings({cartogram::cartogram_ncont(x, weight = "weight", k = args$expansion, inplace = args$inplace)}))
	} else if (args$type == "dorling") {
		shp = suppressMessages(suppressWarnings({cartogram::cartogram_dorling(x, weight = "weight", k = args$share, itermax = args$itermax)}))
	} else {
		stop("unknown cartogram type", call. = FALSE)
	}


	shp2 = sf::st_cast(sf::st_geometry(shp), "MULTIPOLYGON")

	ord2 = ord__[match(shpTM$tmapID, shp$tmapID__)]

	o = order(ord2, decreasing = FALSE)

	# set lat/long crs again
	if (isll) shp2 = sf::st_set_crs(shp2, llcrs)

	list(shp = shp2[o], tmapID = shp$tmapID__[o])
}
