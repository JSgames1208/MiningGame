local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)
local React = require(ReplicatedStorage.Packages.React)
local Sift = require(ReplicatedStorage.Packages.Sift)
local Quests = require(ReplicatedStorage.Shared.modules.core.registries.Quests)
local Intersection = require(ReplicatedStorage.Shared.ui.core.components.Intersection)
local TextLabel = require(ReplicatedStorage.Shared.ui.core.components.TextLabel)
local ProgressBar = require(ReplicatedStorage.Shared.ui.features.quests.components.ProgressBar)
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
					showNumbers = true,
					current = reqProgress.current,
					target = reqProgress.target,
					LayoutOrder = #bars + 10,
				})
			)
		end
	end

	return e("Frame", {
		Size = UDim2.new(0.9, 0, 0, 100),
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromRGB(245, 245, 245),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.LayoutOrder,
		ZIndex = 5,
	}, {
		e("UIStroke", {
			Color = Color3.fromRGB(0, 0, 0),
			Thickness = 10,
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
			Padding = UDim.new(0, 25),
		}),
		e("UIPadding", {
			PaddingTop = UDim.new(0, 25),
			PaddingBottom = UDim.new(0, 25),
			PaddingLeft = UDim.new(0, 25),
			PaddingRight = UDim.new(0, 25),
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
				Thickness = 10,
				Color = Color3.fromRGB(0, 0, 0),
			},
			Children = {},
		}),
		e(Intersection, {
			ZIndex = 5,
			LayoutOrder = 1,
		}),
		bars,
	})
end

return QuestDisplay
