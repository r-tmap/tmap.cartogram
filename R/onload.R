.onLoad = function(...) {
	assign("cache", list(), .TMAP_CARTOGRAM)
	tmap::tmapSubmitOptions(
		options = list(
			value.null = list(area = 0)))
}


.TMAP_CARTOGRAM = new.env(FALSE, parent = globalenv())
