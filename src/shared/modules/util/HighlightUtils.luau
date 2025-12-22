local HighlightUtils = {}

local activeHighlights: { [Model]: Highlight } = {}

function HighlightUtils.apply(model: Model, color: Color3?, transparency: number?)
	if not model then
		return
	end

	HighlightUtils.remove(model)

	local highlight = Instance.new("Highlight")
	highlight.Adornee = model

	if not highlight.Adornee then
		return
	end

	highlight.FillColor = color or Color3.fromRGB(220, 0, 0)
	highlight.FillTransparency = transparency or 0.5
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.OutlineTransparency = 0
	highlight.Parent = model

	activeHighlights[model] = highlight
	return highlight
end

function HighlightUtils.remove(model: Model)
	local highlight = activeHighlights[model]
	if highlight then
		highlight:Destroy()
		activeHighlights[model] = nil
	end
end

function HighlightUtils.removeAll()
	for model, _ in pairs(activeHighlights) do
		HighlightUtils.remove(model)
	end
end

return HighlightUtils
