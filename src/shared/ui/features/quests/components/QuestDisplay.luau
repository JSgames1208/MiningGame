local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local React = require(ReplicatedStorage.Packages.React)
local Sift = require(ReplicatedStorage.Packages.Sift)
local Quests = require(ReplicatedStorage.Shared.modules.core.registries.Quests)
local ImageIds = require(ReplicatedStorage.Shared.ui.core.ImageIds)
local Button = require(ReplicatedStorage.Shared.ui.core.components.Button)
local Intersection = require(ReplicatedStorage.Shared.ui.core.components.Intersection)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local ProgressBar = require(ReplicatedStorage.Shared.ui.features.quests.components.ProgressBar)
local questSlice = require(ReplicatedStorage.Shared.ui.features.quests.state.questSlice)
local e: typeof(React.createElement) = React.createElement

type Atom<T> = Charm.Atom<T>

type Quest = {
	id: string,
	progress: {
		[string]: {
			current: number,
			target: number,
		},
	},
}

export type QuestDisplayProps = {
	quest: Quest,
	pinnable: boolean?,
	LayoutOrder: number,
}

local function QuestDisplay(props: QuestDisplayProps)
	local quest = props.quest
	local questId = quest.id
	local questEntry = Quests.get(questId)

	if not questEntry then
		return nil
	end

	local questName = questEntry.name

	local questProgress = quest.progress

	local bars = {}

	for _, requirement in pairs(questEntry.requirements) do
		local reqId = requirement.type .. "_" .. tostring(requirement.target)

		local reqProgress = questProgress[reqId]

		if reqProgress then
			bars = Sift.Array.push(
				bars,
				e(ProgressBar, {
					text = `{requirement.type} {requirement.amount} {requirement.target}`,
					pinnable = props.pinnable,
					showNumbers = true,
					current = reqProgress.current,
					target = reqProgress.target,
					LayoutOrder = #bars + 10,
				})
			)
		end
	end

	local pinButton = nil

	if props.pinnable then
		local pinned = Sift.Array.contains(questSlice.states.pinnedQuestIds(), questId)
		local image = pinned and ImageIds.icons["star_yellow"] or ImageIds.icons["star_gray"]
		pinButton = e(
			Button,
			{
				onClick = function()
					if pinned then
						questSlice.actions.unpinQuest(questId)
					else
						questSlice.actions.pinQuest(questId)
					end
				end,
				Image = image,
				Size = UDim2.new(0.075, 0, 0.075, 0),
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				LayoutOrder = 0,
				ZIndex = 15,
				BackgroundTransparency = 1,
				Children = {
					e("UIPadding", {
						PaddingTop = UDim.new(0, 25),
						PaddingBottom = UDim.new(0, 25),
						PaddingLeft = UDim.new(0, 25),
						PaddingRight = UDim.new(0, 25),
					}),
				},
			} :: Button.ButtonProps
		)
	end

	local paddingAmount = props.pinnable and 25 or 15

	return e("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(245, 245, 245),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.LayoutOrder,
		ClipsDescendants = false,
		BorderSizePixel = 0,
		ZIndex = 5,
	}, {
		pinButton,
		e("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(245, 245, 245),
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = 5,
			LayoutOrder = 1,
		}, {
			e("UIStroke", {
				Color = Color3.fromRGB(0, 0, 0),
				Thickness = props.pinnable and 10 or 5,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			}),
			e("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),
			e("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, paddingAmount),
			}),
			e("UIPadding", {
				PaddingTop = UDim.new(0, paddingAmount),
				PaddingBottom = UDim.new(0, paddingAmount),
				PaddingLeft = UDim.new(0, paddingAmount),
				PaddingRight = UDim.new(0, paddingAmount),
			}),
			e(TextLabel, {
				Text = questName,
				Font = Enum.Font.FredokaOne,
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				Size = UDim2.new(1, 0, 0.075, 0),
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
				TextScaled = true,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 5,
				LayoutOrder = 0,
				Stroke = {
					Thickness = props.pinnable and 10 or 5,
					Color = Color3.fromRGB(0, 0, 0),
				},
				Children = {},
			}),
			e(Intersection, {
				ZIndex = 10,
				LayoutOrder = 1,
			}),
			bars,
		}),
	})
end

return QuestDisplay
