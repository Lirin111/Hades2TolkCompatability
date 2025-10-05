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

--Read non-dialogue voicelines
ModUtil.Path.Wrap("PlayVoiceLine", function(base, line, prevLine, parentLine, source, args, originalArgs)
	if line.Cue ~= nil and line.Cue ~= "/EmptyCue" then
		local ref = line.Cue
		ref = string.gsub(ref, "/VO/", "")
		local text = GetDisplayName({ Text = ref }):gsub("{[^}]+}", ""):gsub("%(s%)", "s")
		rom.tolk.silence()
		rom.tolk.output(text)
	end
	base(line, prevLine, parentLine, source, args, originalArgs)
end)

-- Read dialogues
ModUtil.Path.Wrap("DisplayTextLine", function(base, screen, source, line, parentLine, nextLine, args)
	if line.Cue ~= nil and line.Cue ~= "/EmptyCue" then
		local ref = line.Cue
		ref = string.gsub(ref, "/VO/", "")
		local text = GetDisplayName({ Text = ref }):gsub("{[^}]+}", ""):gsub("%(s%)", "s")
		rom.tolk.silence()
		rom.tolk.output(text)
	end
	base(screen, source, line, parentLine, nextLine, args)
end)

-- Add description text to Quest buttons (like Silver Pool does)
ModUtil.Path.Context.Wrap("OpenQuestLogScreen", function()
	ModUtil.Path.Wrap("CreateTextBox", function(base, textBoxArgs)
		-- Call the base CreateTextBox first
		local result = base(textBoxArgs)

		-- Check if this is a quest name text box
		if textBoxArgs and textBoxArgs.Text and textBoxArgs.Id then
			-- Check if this text matches a quest name by looking for it in QuestData
			local questData = QuestData[textBoxArgs.Text]
			if questData then
				-- Add invisible description text (like Silver Pool)
				base({
					Id = textBoxArgs.Id,
					Text = textBoxArgs.Text,
					UseDescription = true,
					Color = Color.Transparent,
				})

				-- Add reward info if available
				if questData.RewardResourceName and questData.RewardResourceAmount and GameState.QuestStatus[questData.Name] ~= "CashedOut" then
					-- Add simple "Reward" label
					base({
						Id = textBoxArgs.Id,
						Text = "Reward",
						Color = Color.Transparent,
					})

					-- Add reward amount and localized resource name
					local resourceDisplayName = GetDisplayName({ Text = questData.RewardResourceName })
					if resourceDisplayName and resourceDisplayName ~= "" then
						base({
							Id = textBoxArgs.Id,
							Text = questData.RewardResourceAmount .. " " .. resourceDisplayName,
							Color = Color.Transparent,
						})
					end
				end
			end
		end

		return result
	end)
end)

-- Add cost/unlock condition text to Silver Pool buttons
ModUtil.Path.Wrap("MouseOverWeaponShopItem", function(base, button)
	base(button)

	-- Add cost information as transparent text on the button (if not purchased)
	if button and button.Data and button.Data.Cost and not button.Purchased then
		-- Add a simple "Cost" label
		CreateTextBox({
			Id = button.Id,
			Text = "Cost",
			Color = Color.Transparent,
		})

		-- Add each resource cost
		for resourceName, amount in pairs(button.Data.Cost) do
			local resourceData = ResourceData[resourceName]
			if resourceData then
				local resourceDisplayName = GetDisplayName({ Text = resourceData.CostTextId or resourceName })
				if resourceDisplayName and resourceDisplayName ~= "" then
					CreateTextBox({
						Id = button.Id,
						Text = amount .. " " .. resourceDisplayName,
						Color = Color.Transparent,
					})
				end
			end
		end
	end
end)

-- Add cost/unlock condition text to Cauldron (Ghost Admin) buttons
ModUtil.Path.Wrap("MouseOverGhostAdminItem", function(base, button)
	base(button)

	-- Add cost information as transparent text on the button (if not purchased)
	if button and button.Data and button.Data.Cost and not button.Purchased then
		-- Add a simple "Cost" label
		CreateTextBox({
			Id = button.Id,
			Text = "Cost",
			Color = Color.Transparent,
		})

		-- Add each resource cost
		for resourceName, amount in pairs(button.Data.Cost) do
			local resourceData = ResourceData[resourceName]
			if resourceData then
				local resourceDisplayName = GetDisplayName({ Text = resourceData.CostTextId or resourceName })
				if resourceDisplayName and resourceDisplayName ~= "" then
					CreateTextBox({
						Id = button.Id,
						Text = amount .. " " .. resourceDisplayName,
						Color = Color.Transparent,
					})
				end
			end
		end
	end
end)
