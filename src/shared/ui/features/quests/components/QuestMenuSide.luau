local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local SlideOutFrame = require(ReplicatedStorage.Shared.ui.core.components.SlideOutFrame)
local hudSlice = require(ReplicatedStorage.Shared.ui.features.hud.state.hudSlice)
local miningSlice = require(ReplicatedStorage.Shared.ui.features.mining.state.miningSlice)
local QuestDisplay = require(ReplicatedStorage.Shared.ui.features.quests.components.QuestDisplay)
local questSlice = require(ReplicatedStorage.Shared.ui.features.quests.state.questSlice)
local e: typeof(React.createElement) = React.createElement

local function QuestItem(props: { id: string, LayoutOrder: number })
	local id = props.id
	local questAtom = questSlice.actions.getQuestById(id)

	if not questAtom then
		return nil
	end

	local quest = ReactCharm.useAtom(questAtom)

	if not quest then
		return nil
	end

	local disp = {
		id = id,
		progress = quest.progress,
	}

	return e(QuestDisplay, { quest = disp, pinnable = false, LayoutOrder = props.LayoutOrder })
end

local function QuestMenuSide()
	local hudShown = ReactCharm.useAtom(hudSlice.states.shown)
	local questsOpen = ReactCharm.useAtom(questSlice.states.questsOpen)
	local mining = ReactCharm.useAtom(miningSlice.states.mining)
	local pinnedIds = ReactCharm.useAtom(questSlice.states.pinnedQuestIds)

	local snapshot = {}
	for _, id in ipairs(pinnedIds) do
		local qAtom = questSlice.actions.getQuestById(id)

		local qVal = nil
		if qAtom then
			qVal = qAtom()
		end
		table.insert(snapshot, {
			id = id,
			quest = qVal,
		})
	end

	table.sort(snapshot, function(a, b)
		local ast = a.quest.started or 0
		local bst = b.quest.started or 0

		return ast > bst
	end)

	local questChildren = {}
	for i, entry in ipairs(snapshot) do
		table.insert(questChildren, e(QuestItem, { key = entry.id, id = entry.id, LayoutOrder = i }))
	end

	return e(SlideOutFrame, {
		Shown = #questChildren > 0 and (hudShown or questsOpen or mining),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 800, 0, 1000),
		From = UDim2.new(1, -30, 0.5, 0),
		To = UDim2.new(1.4, -30, 0.5, 0),
		Speed = 8,
		AnchorPoint = Vector2.new(1, 0),
		children = {
			e("ScrollingFrame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				ScrollBarThickness = 5,
				ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
				ScrollingDirection = Enum.ScrollingDirection.Y,
			}, {
				e("UIListLayout", {
					Padding = UDim.new(0, 15),
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
				e("UIPadding", {
					PaddingTop = UDim.new(0, 5),
					PaddingBottom = UDim.new(0, 5),
					PaddingLeft = UDim.new(0, 5),
					PaddingRight = UDim.new(0, 10),
				}),
				questChildren,
			}),
		},
	})
end

return QuestMenuSide
