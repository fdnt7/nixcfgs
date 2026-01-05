function Entity:padding()
	return " "
end
function Linemode:padding()
	return " "
end

require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.PLAIN,
})
