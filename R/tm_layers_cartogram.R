#' Map layer: cartogram
#'
#' Map layer that draws a cartogram. It is recommended to specify a proper crs in `tmap:tm_shape()`.
#'
#' @param size,size.scale,size.legend,size.chart,size.free Visual variable that specifies the polygon sizes.
#' @param plot.order Specification in which order the spatial features are drawn.
#'   See [tmap:tm_plot_order()] for details.
#' @param options passed on to the corresponding `opt_<layer_function>` function
#' @param ... passed on to `tmap:tm_polygons()`
#' @import tmap
#' @export
tm_cartogram = function(size = 1,
						size.scale = tmap::tm_scale(),
						size.legend = tmap::tm_legend_hide(),
						size.chart = tmap::tm_chart_none(),
						size.free = NA,
						plot.order = tmap::tm_plot_order("size", reverse = FALSE),
						options = opt_tm_cartogram(),
						...) {
	po = plot.order
	#trans.args$type = match.arg(trans.args$type)

	# types: "cont", "ncont", "dorling"

	tmp = do.call(tmap::tm_polygons, c(list(...), list(options = options$polygons)))
	tmp[[1]] = within(tmp[[1]], {
		trans.fun = tmapTransCartogram
		trans.args = options$cartogram$trans.args
		trans.aes = list(size = tmapScale(aes = "area",
										  value = size,
										  scale = size.scale,
										  legend = size.legend,
										  chart = size.chart,
										  free = size.free))
		tpar = tmapTpar(area = "__area")
		trans.isglobal = FALSE
		plot.order = po
	})
	tmp
}

#' @export
#' @rdname tm_cartogram
tm_cartogram_ncont = function(size = 1,
							  size.scale = tm_scale(),
							  size.legend = tm_legend_hide(),
							  size.chart = tm_chart_none(),
							  size.free = NA,
							  plot.order = tm_plot_order("size", reverse = FALSE),
							  options = opt_tm_cartogram_ncont(),
							  ...) {
	args = list(...)
	do.call(tm_cartogram, c(list(size = size,
								 size.scale = size.scale,
								 size.legend = size.legend,
								 size.chart = size.chart,
								 size.free = size.free,
								 plot.order = plot.order,
								 options = options), args))
}


#' @export
#' @rdname tm_cartogram
tm_cartogram_dorling = function(size = 1,
								size.scale = tm_scale(),
								size.legend = tm_legend_hide(),
								size.chart = tm_chart_none(),
								size.free = NA,
								plot.order = tm_plot_order("size", reverse = FALSE),
								options = opt_tm_cartogram_dorling(),
								...) {
	args = list(...)
	do.call(tm_cartogram, c(list(size = size,
								 size.scale = size.scale,
								 size.legend = size.legend,
								 size.chart = size.chart,
								 size.free = size.free,
								 plot.order = plot.order,
								 options = options), args))
}

#' @rdname tm_cartogram
#' @param type cartogram type, one of: "cont" for contiguous cartogram, "ncont" for non-contiguous cartogram and "dorling" for Dorling cartograms
#' @param itermax, maximum number of iterations (see [cartogram::cartogram_cont()])
#' @param ... arguments passed on to [cartogram::cartogram_cont()]
#' @export
opt_tm_cartogram = function(type = "cont",
							itermax = 15,
							...) {
	list(cartogram = list(mapping.args = list(),
						  trans.args = list(type = type, itermax = itermax)),
		 polygons = do.call(tmap::opt_tm_polygons, list(...)))
}

#' @rdname tm_cartogram
#' @param expansion factor expansion, see [cartogram::cartogram_ncont()] (argument `k`)
#' @param inplace should each polygon be modified in its original place? (`TRUE` by default)
#' @export
opt_tm_cartogram_ncont = function(type = "ncont",
								  expansion = 1,
								  inplace = FALSE,
								  ...) {

	list(cartogram = list(mapping.args = list(),
						  trans.args = list(type = type, expansion = expansion, inplace = inplace)),
		 polygons = do.call(tmap::opt_tm_polygons, list(...)))
}


#' @rdname tm_cartogram
#' @param share share of the bounding box filled with the larger circle (see [cartogram::cartogram_dorling()] argument `k`)
#' @export
opt_tm_cartogram_dorling = function(type = "dorling",
									share = 5,
									itermax = 1000,
									...) {
	list(cartogram = list(mapping.args = list(),
						  trans.args = list(type = type, share = share, itermax = itermax)),
		 polygons = do.call(tmap::opt_tm_polygons, list(...)))
}
