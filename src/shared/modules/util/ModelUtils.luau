local CollectionService = game:GetService("CollectionService")

local ModelUtils = {}

function ModelUtils.getPrimaryPart(model: Model): BasePart? | { Position: Vector3 }
	if model.PrimaryPart then
		return model.PrimaryPart
	end

	local parts = model:GetDescendants()
	local sumPos = Vector3.new(0, 0, 0)
	local count = 0

	for _, part in pairs(parts) do
		if part:IsA("BasePart") then
			sumPos += part.Position
			count += 1
		end
	end

	if count == 0 then
		return nil
	end

	return { Position = sumPos / count }
end

function ModelUtils.getPosition(model: Model): Vector3
	local primary = ModelUtils.getPrimaryPart(model)
	return primary.Position
end

function ModelUtils.getSize(model: Model): Vector3
	local bounds = model:GetExtentsSize()
	return bounds
end

function ModelUtils.setPosition(model: Model, position: Vector3)
	local primary = ModelUtils.getPrimaryPart(model)
	if typeof(primary) == "table" or not primary:IsA("BasePart") then
		error("Cannot move model with no primary part")
	end

	local offset = position - primary.Position

	for _, part in pairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Position += offset
		end
	end
end

function ModelUtils.findTaggedParent(part: BasePart, tag: string): Model?
	if not part then
		return nil
	end
	local parent = part.Parent
	while parent do
		if parent:IsA("Model") and CollectionService:HasTag(parent, tag) then
			return parent
		end
		parent = parent.Parent
	end

	return nil
end

return ModelUtils
