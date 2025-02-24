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


	x = sf::st_sf(geometry = s, weight = size, tmapID__ = shpTM$tmapID)
	x = x[x$weight > 0,]


	if (args$type == "cont") {
		xargs = list(itermax = args$itermax)

		#shp = suppressMessages(suppressWarnings({cartogram::cartogram_cont(x, weight = "weight", itermax = args$itermax)}))
	} else if (args$type == "ncont") {
		xargs = list(k = args$expansion, inplace = args$inplace)
		#shp = suppressMessages(suppressWarnings({cartogram::cartogram_ncont(x, weight = "weight", k = args$expansion, inplace = args$inplace)}))
	} else if (args$type == "dorling") {
		xargs = list(k = args$share, itermax = args$itermax)
		#shp = suppressMessages(suppressWarnings({cartogram::cartogram_dorling(x, weight = "weight", k = args$share, itermax = args$itermax)}))
	} else {
		stop("unknown cartogram type", call. = FALSE)
	}

	string = paste(c(object.size(x), args$type, unlist(xargs)), collapse = "_")
	cache = get("cache", envir = .TMAP_CARTOGRAM)

	cache_id = which(string == names(cache))[1]
	if (is.na(cache_id)) {
		message("Cartogram in progress...")
		fname = paste0("cartogram::cartogram_", args$type)
		shp = do.call(eval(parse(text=fname)), c(list(x = x, weight = "weight"), xargs))

		nc = length(cache)

		if (nc == 0) {
			cache = structure(list(shp), names = string)
		} else if (nc >= 10) {
			cache = c(cache[2L:10L], structure(list(shp), names = string))
		} else {
			cache = c(cache, structure(list(shp), names = string))
		}

		assign("cache", cache, .TMAP_CARTOGRAM)
	} else {
		shp = cache[[cache_id]]
	}

	shp2 = sf::st_cast(sf::st_geometry(shp), "MULTIPOLYGON")

	ord2 = ord__[match(shpTM$tmapID, shp$tmapID__)]

	o = order(ord2, decreasing = FALSE)

	# set lat/long crs again
	if (isll) shp2 = sf::st_set_crs(shp2, llcrs)

	list(shp = shp2[o], tmapID = shp$tmapID__[o])
}
