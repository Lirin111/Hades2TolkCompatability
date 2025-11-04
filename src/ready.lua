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
if not config.Voicelines.ReadNonDialogue then
	return base(line, prevLine, parentLine, source, args, originalArgs)
end
	local isDryRun = (args and args.ReturnOnly) or (originalArgs and originalArgs.ReturnOnly)

	-- We only proceed with our announcement logic if there's a real cue AND it is NOT a dry run.
	if not isDryRun and line.Cue ~= nil and line.Cue ~= "/EmptyCue" then
		thread(function()
			local gameDelay = line.PreLineWait or (parentLine and parentLine.PreLineWait) or 0
			wait(gameDelay)

			local ref = line.Cue
			ref = string.gsub(ref, "/VO/", "")
			local text = GetDisplayName({ Text = ref }):gsub("{[^}]+}", ""):gsub("%(s%)", "s")
			rom.tolk.silence()
			rom.tolk.output(text)
		end)
	end

	local returnValue = base(line, prevLine, parentLine, source, args, originalArgs)
	return returnValue
end)

-- Read combat popups, EG: damage, interact prompts
ModUtil.Path.Wrap("CreateTextBox", function(base, format)

	if IsScreenOpen("TalentScreen") then
		return base(format)
	end

	local textBoxObject = base(format)
	if format and format.Font == "P22UndergroundSCHeavy" and textBoxObject and textBoxObject.Id then

		thread(function()
			wait(0.1)

			local lines = rom.tolk.get_lines_from_thing(textBoxObject.Id)
			local textToSpeak = createCollection(lines)

			if textToSpeak and textToSpeak:match("%S") then
				local UnwantedTextFragments = { " Status/WantsToFight" }
				for _, fragment in ipairs(UnwantedTextFragments) do
					if string.find(textToSpeak, fragment) then
						return
					end
				end

				local isDamageNumber = textToSpeak:match("%d") and not textToSpeak:match("%a")
				local shouldSpeak = false
				if isDamageNumber then
					if config.PopupAnnouncements.ReadDamageNumbers then
						shouldSpeak = true
					end
				else
					if config.PopupAnnouncements.ReadInteractPrompts then
						shouldSpeak = true
					end
				end

				if shouldSpeak then
					local finalOutput = textToSpeak -- Start with the original text.
					if isDamageNumber and string.find(finalOutput, "!") then
						finalOutput = "Crit" .. finalOutput
					end

					rom.tolk.silence()
					rom.tolk.output(finalOutput)
				end
	end
end)
	end

	return textBoxObject
end)

-- Read banners
ModUtil.Path.Wrap("DisplayInfoBanner", function(base, source, args)
	base(source, args)

	if args and args.Text then
		local textToSpeak = GetDisplayName({
			Text = args.Text,
			LuaKey = args.LuaKey,
			LuaValue = args.LuaValue
		})

		if textToSpeak and textToSpeak:match("%S") then
			rom.tolk.silence()
			rom.tolk.output(textToSpeak)
		end
	end

end)

-- Read prompts.
--[[
	AUTONOMOUS PROMPT READER (Minimalist and Complete)

	This version uses the simplified structure (no "hasBeenRead" flag) but
	includes the full, correct logic for assembling both simple and complex prompts.
]]

ModUtil.Path.Wrap("CreateScreenFromData", function(base, screen, componentData)

	-- Always run the base function first to create the screen's components.
	base(screen, componentData)

	-- We start with a basic check for a valid screen.
	if screen and screen.Components then
		
		-- FINGERPRINT 1: Is this a Trade Screen?
		if screen.Components.GiveInfoBoxName and screen.Components.GetInfoBoxName then
			
			thread(function()
				wait(0.2)
				
				-- This is the full, correct logic for assembling the Trade Screen announcement.
				local titleString = createCollection(rom.tolk.get_lines_from_thing(screen.Components.TitleText.Id))
				local subtitleString = createCollection(rom.tolk.get_lines_from_thing(screen.Components.SubtitleText.Id))
				local giveHintString = createCollection(rom.tolk.get_lines_from_thing(screen.Components.GiveHintText.Id))
				local giveItemName = createCollection(rom.tolk.get_lines_from_thing(screen.Components.GiveInfoBoxName.Id))
				local giveItemDesc = createCollection(rom.tolk.get_lines_from_thing(screen.Components.GiveInfoBoxBacking.Id))
				local getHintString = createCollection(rom.tolk.get_lines_from_thing(screen.Components.GetHintText.Id))
				local getItemName = createCollection(rom.tolk.get_lines_from_thing(screen.Components.GetInfoBoxName.Id))
				local getItemDesc = createCollection(rom.tolk.get_lines_from_thing(screen.Components.GetInfoBoxBacking.Id))

				local fullPrompt = titleString .. " " .. subtitleString .. " "
				fullPrompt = fullPrompt .. giveHintString .. " " .. giveItemName .. ". "
				if giveItemDesc and giveItemDesc:match("%S") then fullPrompt = fullPrompt .. giveItemDesc .. " " end
				fullPrompt = fullPrompt .. getHintString .. " " .. getItemName .. ". "
				if getItemDesc and getItemDesc:match("%S") then fullPrompt = fullPrompt .. getItemDesc end
				
				fullPrompt = fullPrompt:gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
				
				rom.tolk.silence()
				rom.tolk.output(fullPrompt)
			end)

		-- FINGERPRINT 2: Is this a simple prompt screen?
		elseif screen.Components.TitleText and screen.Components.DescriptionText then
			
			thread(function()
				wait(0.1)
				
				-- This is the full, correct logic for assembling a simple prompt.
				local titleString = createCollection(rom.tolk.get_lines_from_thing(screen.Components.TitleText.Id))
				local descriptionString = createCollection(rom.tolk.get_lines_from_thing(screen.Components.DescriptionText.Id))
				local fullPrompt = titleString .. ". " .. descriptionString
				
				rom.tolk.silence()
				rom.tolk.output(fullPrompt)
			end)
		end
	end
end)

-- Read dialogues
ModUtil.Path.Wrap("DisplayTextLine", function(base, screen, source, line, parentLine, nextLine, args)
if not config.Voicelines.ReadDialogues then
	return base(screen, source, line, parentLine, nextLine, args)
end
	if line.Cue ~= nil and line.Cue ~= "/EmptyCue" then
		local ref = line.Cue
		ref = string.gsub(ref, "/VO/", "")
		local text = GetDisplayName({ Text = ref }):gsub("{[^}]+}", ""):gsub("%((s)%)", "s")
		rom.tolk.silence()
		-- Resolve speaker id from current line / args / parent line
		local speakerId = nil
		if line.Speaker ~= nil then
			speakerId = line.Speaker
		elseif line.SpeakerName ~= nil then
			speakerId = line.SpeakerName
		elseif line.SpeakerNameId ~= nil then
			speakerId = line.SpeakerNameId
		end
		if speakerId == nil and type(args) == "table" then
			if args.Speaker ~= nil then
				speakerId = args.Speaker
			elseif args.SpeakerName ~= nil then
				speakerId = args.SpeakerName
			end
		end
		if speakerId == nil and type(parentLine) == "table" then
			if parentLine.Speaker ~= nil then
				speakerId = parentLine.Speaker
			elseif parentLine.SpeakerName ~= nil then
				speakerId = parentLine.SpeakerName
			end
		end
		-- Extract English speaker name (prefer Cue, fallback to speakerId)
		local speakerName = nil
		do
			local cueRef = type(line.Cue) == "string" and line.Cue:gsub("^/VO/", "") or nil
			if cueRef ~= nil then
				local npcBase = cueRef:match("^NPC_([^_]+)")
				if npcBase ~= nil then
					speakerName = npcBase
				else
					local base = cueRef:match("^([A-Za-z]+)")
					if base ~= nil then
						speakerName = base
					end
				end
			end
			if speakerName == nil and speakerId ~= nil then
				local sid = tostring(speakerId)
				if sid:find("^NPC_") then
					local npcBase2 = sid:match("^NPC_([^_]+)")
					speakerName = npcBase2 or sid
				else
					speakerName = sid:match("^([A-Za-z]+)") or sid
				end
			end
		end
		-- Resolve optional title/epithet/subtitle
		local titleId = nil
		if line.SpeakerSubtitle ~= nil then
			titleId = line.SpeakerSubtitle
		elseif line.Subtitle ~= nil then
			titleId = line.Subtitle
		elseif line.Epithet ~= nil then
			titleId = line.Epithet
		elseif line.SpeakerTitle ~= nil then
			titleId = line.SpeakerTitle
		elseif type(args) == "table" then
			if args.Subtitle ~= nil then
				titleId = args.Subtitle
			elseif args.Epithet ~= nil then
				titleId = args.Epithet
			elseif args.SpeakerTitle ~= nil then
				titleId = args.SpeakerTitle
			end
		end
		local titleText = nil
		if titleId ~= nil then
			titleText = GetDisplayName({ Text = titleId, IgnoreSpecialFormatting = true }):gsub("{[^}]+}", ""):gsub("%((s)%)", "s")
		end
		local outputText = text
		if speakerName ~= nil and speakerName ~= "" then
			if titleText ~= nil and titleText ~= "" and titleText ~= speakerName then
				outputText = speakerName .. "(" .. titleText .. "): " .. text
			else
				outputText = speakerName .. ": " .. text
			end
		end
		rom.tolk.output(outputText)
	end
	return base(screen, source, line, parentLine, nextLine, args)
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

-- Cauldron cost handling is now done directly in Blind_Accessibility mod
-- The wrap_GhostAdminDisplayCategory function adds cost textboxes between name and description

-- Helper function to convert icon paths to readable text
local function ConvertIconsToText(text)
	if not text then return text end

	-- Common icon mappings
	local iconMappings = {
		["@GUI\\Icons\\Life"] = "Health",
		["@GUI\\Icons\\Currency"] = "Gold",
		["@gui/icons/life"] = "Health",
		["@gui/icons/currency"] = "Gold",
		["@gui/icons/mana"] = "Magick",
		["@gui/icons/armor"] = "Armor",
		["@gui/icons/attack"] = "Attack",
		["@gui/icons/speed"] = "Speed",
	}

	-- First try exact matches (case-insensitive)
	for pattern, replacement in pairs(iconMappings) do
		text = text:gsub(pattern:gsub("\\", "\\\\"), replacement)
		text = text:gsub(pattern:lower():gsub("\\", "\\\\"), replacement)
		text = text:gsub(pattern:upper():gsub("\\", "\\\\"), replacement)
	end

	-- Handle any remaining icon patterns by extracting the icon name
	-- Pattern: @gui/icons/name or @GUI\Icons\name (with optional .number at the end)
	text = text:gsub("@[Gg][Uu][Ii][/\\][Ii]cons[/\\]([%w_]+)%.?%d*", function(iconName)
		-- Convert icon name from camelCase/snake_case to readable format
		-- First, handle known specific names
		local knownNames = {
			life = "Health",
			currency = "Gold",
			mana = "Magick",
			armor = "Armor",
			attack = "Attack",
			speed = "Speed",
		}

		local lowerName = iconName:lower()
		if knownNames[lowerName] then
			return knownNames[lowerName]
		end

		-- Otherwise, capitalize first letter and return
		return iconName:sub(1,1):upper() .. iconName:sub(2)
	end)

	return text
end

-- Add text to Talent buttons when hovering over them
ModUtil.Path.Wrap("MouseOverTalentButton", function(base, button)
	-- Build the name and status text BEFORE calling base
	local nameAndStatus = ""
	if button and button.Data and button.Data.Name then
		local talent = button.Data
		local talentName = GetDisplayName({Text = talent.Name}) or talent.Name

		-- Build status text
		local statusText = ""
		if talent.Invested then
			statusText = "On"
		elseif talent.QueuedInvested then
			statusText = "On, Queued"
		else
			-- Check prerequisites
			local hasPreRequisites = true
			if talent.LinkFrom and button.Screen and button.Screen.Components and button.TalentColumn then
				hasPreRequisites = false
				for _, preReqIndex in pairs(talent.LinkFrom) do
					local preReqButton = button.Screen.Components["TalentObject"..(button.TalentColumn-1).."_"..preReqIndex]
					if preReqButton and preReqButton.Data and (preReqButton.Data.Invested or preReqButton.Data.QueuedInvested) then
						hasPreRequisites = true
						break
					end
				end
			end

			if hasPreRequisites then
				statusText = "Off"
				if CurrentRun and CurrentRun.NumTalentPoints ~= nil then
					statusText = statusText .. ", Cost " .. (CurrentRun.NumTalentPoints + 1)
				end
			else
				statusText = "Locked"
			end
		end

		nameAndStatus = talentName .. ", " .. statusText
	end

	-- Call base to set up trait data and ModifyTextBox with description
	base(button)

	-- Wait for all text boxes to be fully created (including description from ModifyTextBox)
	wait(0.2)

	if button and button.Data and button.Data.Name then
		local talent = button.Data

		-- Get the full trait description directly from the trait data
		local traitData = TraitData[talent.Name]
		local fullDescription = ""

		if traitData then
			-- Get the main tooltip text
			if traitData.TooltipText then
				local tooltipText = GetDisplayName({Text = traitData.TooltipText, IgnoreSpecialFormatting = true})
				if tooltipText and tooltipText ~= "" then
					tooltipText = tooltipText:gsub("{[^}]+}", ""):gsub("%(s%)", "s")
					tooltipText = ConvertIconsToText(tooltipText)
					fullDescription = tooltipText
				end
			end

			-- Get additional description from ExtractValues if available
			local processedTrait = GetProcessedTraitData({
				Unit = CurrentRun.Hero,
				TraitName = talent.Name,
				Rarity = talent.Rarity,
				ForBoonInfo = true
			})

			if processedTrait and processedTrait.ExtractValues then
				for _, extractData in ipairs(processedTrait.ExtractValues) do
					if extractData.ExtractAs then
						local propertyKey = extractData.ExtractAs
						local propertyDisplay = GetDisplayName({Text = propertyKey, IgnoreSpecialFormatting = true})
						if propertyDisplay and propertyDisplay ~= "" and propertyDisplay ~= propertyKey then
							-- This is likely additional description text
							propertyDisplay = propertyDisplay:gsub("{[^}]+}", ""):gsub("%(s%)", "s")
							propertyDisplay = ConvertIconsToText(propertyDisplay)
							if fullDescription ~= "" then
								fullDescription = fullDescription .. ". "
							end
							fullDescription = fullDescription .. propertyDisplay
						end
					end
				end
			end
		end

		-- Also get text from the button as fallback/supplement
		local lines = rom.tolk.get_lines_from_thing(button.Id)
		for i = 2, #lines do
			local line = lines[i]
			if line and line ~= "" then
				-- Clean up the line
				line = line:gsub("{[^}]+}", ""):gsub("%(s%)", "s")
				line = ConvertIconsToText(line)

				-- Only add if not already in description
				if not fullDescription:find(line, 1, true) then
					if fullDescription ~= "" then
						fullDescription = fullDescription .. ". "
					end
					fullDescription = fullDescription .. line
				end
			end
		end

		-- Build the complete text to speak
		local fullText = nameAndStatus
		if fullDescription ~= "" then
			fullText = fullText .. ". " .. fullDescription
		end

		-- Speak everything at once to avoid interruptions
		if fullText ~= "" then
			rom.tolk.silence()
			rom.tolk.output(fullText)
		end
	end
end)

-- Add description and gift count text to Book of Shadows (Codex) entries
ModUtil.Path.Context.Wrap("CodexOpenChapter", function(screen, button)
	local chapterName = button.ChapterName

	ModUtil.Path.Wrap("CreateTextBox", function(base, textBoxArgs)
		-- Call the base CreateTextBox first
		local result = base(textBoxArgs)

		-- Check if this is a codex entry button name being created
		if textBoxArgs and textBoxArgs.Text and textBoxArgs.Id and not CodexButtonsProcessed[textBoxArgs.Id] then
			-- Check if this text matches an entry name by looking for it in CodexData
			local entryName = textBoxArgs.Text
			local entryData = CodexData[chapterName] and CodexData[chapterName].Entries and CodexData[chapterName].Entries[entryName]

			if entryData then
				-- Mark this button as processed so we don't add text multiple times
				CodexButtonsProcessed[textBoxArgs.Id] = true

				-- Add gift count information
				local narrativeData = NarrativeData[entryName]
				if narrativeData and narrativeData.GiftTextLinePriorities then
					local giftCount = GetGiftCount(entryName)
					local maxGifts = #narrativeData.GiftTextLinePriorities

					-- Add gift count text (show even if 0 to indicate relationship tracking is available)
					base({
						Id = textBoxArgs.Id,
						Text = "Gifts given " .. giftCount .. " of " .. maxGifts,
						Color = Color.Transparent,
					})
				end

				-- Add description text from entry data
				if entryData.Entries ~= nil then
					local descText = ""

					for index, unlockPortion in ipairs(entryData.Entries) do
						local subEntryData = entryData.Entries[index]
						if SessionState.CodexDebugUnlocked or subEntryData.UnlockGameStateRequirements == nil or IsGameStateEligible(CurrentRun, subEntryData.UnlockGameStateRequirements) then
							local portionText = GetDisplayName({ Text = unlockPortion.HelpTextId or unlockPortion.Text })
							if portionText and portionText ~= "" then
								descText = descText .. portionText .. " "
							end
						end
					end

					-- Add the description as transparent text
					if descText ~= "" then
						base({
							Id = textBoxArgs.Id,
							Text = descText,
							Color = Color.Transparent,
						})
					end
				end
			end
		end

		return result
	end)
end)
