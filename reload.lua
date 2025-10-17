---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.


local IconNameToTextId = {
	["Currency"] = "Money",
	["MoneyDrop_Text"] = "Money",
	["MaxManaDrop_Text"] = "MaxManaDrop_Store",
	["PlantMoney_Text"] = "PlantMoney",
	["RandomLoot"] = "RandomLootGiftItem",
	["HealthItem01"] = "HealDrop",
	["LastStand"] = "ExtraChanceAlt",
	["TraitExchange"] = "",
	["tooltip_arrow"] = "→",
	["Bullet"] = "*",
	["HorizontalDivider"] = "",
	["HorizontalDividerLong"] = "",
	["Life"] = "Health",
	["LifeUp"] = "HealthUp",
	["LifeUp_Empty"] = "HealthUpAl",
	["LifeRestore"] = "HealthRestore",
	["Mana"] = "Mana",
	["ManaUp"] = "ManaUp",
	["UnLife"] = "ShieldHealth",
	["Armor"] = "Armor",
	["Omega"] = "Omega ", --we put a space here so that GetDisplayName fails and just returns 'Omega', of course this is not localized 
					--but since the pronounciation should hopefully be recognized globally, and its not an english word in the first place, and its not being seen
	["Elite_Badge_01"] = "Boss",
	["Elite_Badge_02"] = "MiniBoss",
	["WitchGrenadeIconHUD"] = "ShellsAlt",
	["LobAmmo"] = "ShellsAlt",
	["Enraged"] = "Fuel", --I honestly dont know what this icon is
	["ReRoll"] = "ReRollAlt",
	["Dash"] = "Dash",
	["UpArrow"] = "↑",
	["DownArrow"] = "↓",
	["HealthBar_1up"] = "ExtraChanceAlt",
	["HealthBar_1upEcho"] = "LastStandStatDisplay1",
	["Darkness"] = "Mixer6Common",
	["RandomPom"] = "RandomPom",
	["Pom"] = "Pom_Small",
	["Onion"] = "Onion",
	["MaxManaDrop_Preview"] = "MaxManaDrop_Store",
	["Hammer"] = "Hammer",
	["FatedChoice"] = "QuestItem",
	["Reminder"] = "WorldUpgradePinning",
	["ShrinePoint"] = "ShrinePoints",
	["Gift"] = "GiftPoints_Short",
	["GiftPointsRare_Text"] = "GiftPointsRare",
	["GiftPointsEpic_Text"] = "GiftPointsEpic",
	["SuperGift"] = "SuperGiftPoints",
	["ManaLock"] = "ReserveMana",
	["RunReward"] = "RunReward",
	["MetaReward"] = "MetaReward",
	["LimitedTimeOffer"] = "LimitedTimeOffer",
	["Locked"] = "AwardMenuLocked",
    ["ContractorPurchasedCheckmark"] = "", --no localization immediatly available
    ["MirrorLockedB"] = "",
    ["MirrorUnlockedA"] = "", --I have no idea what these last 2 are even used for in game
    ["Boon"] = "GodBoon",
    ["Slash"] = "/",
    ["SlashDark"] = "/",
    ["TimeIcon"] = "Outro_EarlyEnd05",
    ["RefreshIcon"] = "", --no localization immediately available
    ["NoCanDo"] = "X",
    ["CardRarityIcon_Common"] = "Common",
    ["CardRarityIcon_Rare"] = "Rare",
    ["CardRarityIcon_Epic"] = "Epic",
    ["CardRarityIcon_Heroic"] = "Heroic",
    ["Moon_Crescent"] = "",
    ["Moon_Half"] = "",
    ["Moon_Full"] = "",
    ["rank_1"] = "ShrineLevel1",
    ["rank_2"] = "TraitLevel_AspectLvl2",
    ["rank_3"] = "TraitLevel_AspectLvl3",
    ["rank_4"] = "TraitLevel_AspectLvl4",
    ["rank_5"] = "TraitLevel_AspectLvl5",
    ["legendRank_1"] = "ShrineLevel1",
    ["legendRank_2"] = "TraitLevel_AspectLvl2",
    ["legendRank_3"] = "TraitLevel_AspectLvl3",
    ["legendRank_4"] = "TraitLevel_AspectLvl4",
	["EasyMode"] = "EasyMode",
	["RelationshipHeart"] = "Outro_EarlyEnd_Heart",
	["RadioButton_Unselected"] = "", --No localization immediately available
	["RadioButton_Unselected"] = "", --No localization immediately available
	["Music"] = "", --This is only used in music captions, so we may not need it
	["RunClearStar"] = "", -- This is only ever used in russian and taiwanese chinese (dont know why, english quivalents use dots)
	["DotsLeft"] = "*",
	["DotsRight"] = "*",
	["BountySkull"] = "Bounties",
	["BountySkullEmpty"] = "Bounties",
	["BountyUnknown"] = "?",
	["Tool_Book_Frog"] = "FrogFamiliar",
	["Tool_FishingRod_Cat"] = "CatFamiliar",
	["Tool_Pickaxe_Raven"] = "RavenFamiliar",
	["Pause"] = "PauseScreen_Title",
	["Icon-Inventory"] = "Inventory",
	["Pickaxe"] = "ToolPickaxe",
	["ExorcismBook"] = "ToolExorcismBook",
	["Shovel"] = "ToolShovel",
	["FishingRod"] = "ToolFishingRod",
	["Element_Earth_Text"] = "CurseEarth",
	["Element_Fire_Text"] = "CurseFire",
	["Element_Air_Text"] = "CurseAir",
	["Element_Water_Text"] = "CurseWater",
	["Element_Aether_Text"] = "CurseAether",
	["ManaCrystal"] = "IncreaseMetaUpgradeCard",
	["MetaCardPointsCommon_Text"] = "MetaCardPointsCommon_Short",
	["MetaCurrency_Text"] = "MetaCurrency_Short",
	["MemPointsCommon_Text"] = "MemPointsCommon_Short",
	["PlantFMoly_Text"] = "PlantFMoly",
	["OreFSilver_Text"] = "OreFSilver_Short",
	["MetaFabric_Text"] = "MetaFabric",
	["Mixer5Common_Text"] = "Mixer5Common",
	["MixerShadow"] = "MixerShadow_Short",
	["CardUpgradePoints_Text"] = "CardUpgradePoints",
	["FamiliarPoints_Text"] = "FamiliarPoints",
	["PlantFNightshade_Text"] = "PlantFNightshade",
	["PlantFNightshadeSeed_Text"] = "PlantFNightshadeSeed",
	["PlantMysterySeed_Text"] = "SeedMystery",
	["PlantIPoppy_Text"] = "PlantIPoppy",
	["PlantGCattail_Text"] = "PlantGCattail",
	["PlantNGarlicSeed_Text"] = "PlantNGarlicSeed",
	["PlantNGarlic_Text"] = "PlantNGarlic",
	["CosmeticsPointsPrestige_Text"] = "CosmeticsPoints",
	["PlantOMandrakeSeed_Text"] = "PlantOMandrakeSeed",
	["PlantOMandrake_Text"] = "PlantOMandrake",
	["BountyBoardEye"] = "DeathVengeanceKeepsake"
}

function OnMouseOverTrigger(triggerArgs)
    local button = triggerArgs.TriggeredByTable
    if button == nil then
        return
    end

    -- Skip talent buttons - they have their own dedicated handler
    if button.Id and string.find(button.Id, "TalentObject") then
        return
    end

    if button.Id then
        -- For Cauldron (Ghost Admin) buttons, insert cost information between name and description
        if button.Data and button.Data.Cost and type(button.Data.Cost) == "table" and not button.Purchased then
            local lines = rom.tolk.get_lines_from_thing(button.Id)

            -- Insert cost lines after the first line (name) and before the description
            if #lines >= 2 then
                local newLines = {lines[1]} -- Start with the name

                -- Add cost label
                table.insert(newLines, "Cost")

                -- Add each resource cost
                for resourceName, amount in pairs(button.Data.Cost) do
                    local resourceData = ResourceData[resourceName]
                    if resourceData then
                        local resourceDisplayName = GetDisplayName({ Text = resourceData.CostTextId or resourceName })
                        if resourceDisplayName and resourceDisplayName ~= "" then
                            table.insert(newLines, amount .. " " .. resourceDisplayName)
                        end
                    end
                end

                -- Add the rest of the lines (description, etc.)
                for i = 2, #lines do
                    table.insert(newLines, lines[i])
                end

                lines = newLines
            end

            local collection = createCollection(lines)
            if collection and collection:match("%S") then
                rom.tolk.silence()
                rom.tolk.output(collection)
            end
        else
            -- Normal handling for non-Cauldron buttons
            local lines = rom.tolk.get_lines_from_thing(button.Id)
            local collection = createCollection(lines)

            -- Only output if there's actual content (not just whitespace)
            if collection and collection:match("%S") then
                rom.tolk.silence()
                rom.tolk.output(collection)
            end
        end
    end
end

function tolk_OnButtonHover(lines)
	rom.tolk.silence()
	local collection = createCollection(lines)
	rom.tolk.output(collection)
end

-- Helper function to convert icon paths to readable text (defined in ready.lua but need it here too)
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
	text = text:gsub("@[Gg][Uu][Ii][/\\][Ii]cons[/\\]([%w_]+)%.?%d*", function(iconName)
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

		return iconName:sub(1,1):upper() .. iconName:sub(2)
	end)

	return text
end

function createCollection(lines)
	local collection = ""
	for i = 1, #lines do
		local line = lines[i]
		if line and line ~= "" then
			-- Clean up the line - remove curly braces, convert icons, and fix plurals
			line = line:gsub("{[^}]+}", ""):gsub("%(s%)", "s")
			line = ConvertIconsToText(line)

			-- Check if line starts with @ (old icon format)
			if line:sub(1,1) == "@" then
				-- Extract the ending part after last slash
				local ending = ""
				for k in line:gmatch("[^/]+") do
					ending = k
				end
				-- Try to get display name from icon mapping
				if IconNameToTextId[ending] then
					local outputText = GetDisplayName({Text=IconNameToTextId[ending]}):gsub("{[^}]+}", ""):gsub("%(s%)", "s")
					collection = collection .. " " .. outputText
				else
					-- Fallback: just use the ending part
					collection = collection .. " " .. ending
				end
			else
				collection = collection .. " " .. line
			end
		end
	end

	return collection
end

-- Helper function to get the number of gifts given to a character
function GetGiftCount(characterName)
	if not characterName then
		return 0
	end

	if GameState.GiftTextLinesOrderRecord == nil then
		return 0
	end

	if GameState.GiftTextLinesOrderRecord[characterName] == nil then
		return 0
	end

	return #GameState.GiftTextLinesOrderRecord[characterName]
end

-- Track which codex buttons we've already added accessibility text to
CodexButtonsProcessed = {}
