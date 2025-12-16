local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactCharm = require(ReplicatedStorage.Packages.ReactCharm)
local Sift = require(ReplicatedStorage.Packages.Sift)
local MenuScreen = require(ReplicatedStorage.Shared.ui.core.components.MenuScreen)
local QuestDisplay = require(ReplicatedStorage.Shared.ui.features.quests.components.QuestDisplay)
local questSlice = require(ReplicatedStorage.Shared.ui.features.quests.state.questSlice)
local e: typeof(React.createElement) = React.createElement

local function QuestMenu()
	local shown = ReactCharm.useAtom(questSlice.states.questsOpen)
	local quests = ReactCharm.useAtom(questSlice.states.quests)
	local active = quests.active

	local questArray = {}
	for questId, quest in pairs(active) do
		questArray = Sift.Array.push(questArray, Sift.Dictionary.set(quest, "id", questId))
	end

	questArray = Sift.Array.sort(questArray, function(a, b)
		return a.started > b.started
	end)

	local questFrames = {}

	for _, quest in ipairs(questArray) do
		questFrames = Sift.Array.push(
			questFrames,
			e(QuestDisplay, {
				quest = {
					id = quest.id,
					progress = quest.progress,
				},
			})
		)
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
					questFrames,
				}),
			},
		} :: MenuScreen.MenuScreenProps
	)
end

return QuestMenu
