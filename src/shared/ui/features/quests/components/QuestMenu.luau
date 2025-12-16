local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local MenuScreen = require(ReplicatedStorage.Shared.ui.core.components.MenuScreen)
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

	return e(QuestDisplay, { quest = disp, LayoutOrder = props.LayoutOrder })
end

local function QuestMenu()
	local shown = ReactCharm.useAtom(questSlice.states.questsOpen)
	local activeIds = ReactCharm.useAtom(questSlice.states.activeQuestIds)

	local snapshot = {}
	for _, id in ipairs(activeIds) do
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

	return e(
		MenuScreen,
		{
			shown = shown,
			menuTitle = "Quests",
			setOpen = questSlice.actions.setQuestsOpen,
			children = {
				e("ScrollingFrame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(0.95, 0, 0.9, 0),
					Position = UDim2.new(0.5, 0, 1, 0),
					AnchorPoint = Vector2.new(0.5, 1),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					ScrollingEnabled = true,
					ScrollBarThickness = 20,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(0, 0, 0, 0),
					ZIndex = 5,
				}, {
					e("UIListLayout", {
						Padding = UDim.new(0, 25),
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),
					e("UIPadding", {
						PaddingTop = UDim.new(0, 25),
						PaddingBottom = UDim.new(0, 25),
						PaddingLeft = UDim.new(0, 25),
						PaddingRight = UDim.new(0, 25),
					}),
					questChildren,
				}),
			},
		} :: MenuScreen.MenuScreenProps
	)
end

return QuestMenu
