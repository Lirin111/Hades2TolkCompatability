---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

rom.tolk.on_button_hover(function(lines)
	tolk_OnButtonHover(lines)
end)

OnMouseOver{
	function( triggerArgs )
		OnMouseOverTrigger(triggerArgs)
	end
}
