.onLoad = function(...) {
	assign("cache", list(), .TMAP_CARTOGRAM)
}


.TMAP_CARTOGRAM = new.env(FALSE, parent = globalenv())
