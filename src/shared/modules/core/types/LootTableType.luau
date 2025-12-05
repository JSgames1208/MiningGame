local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataTemplate = require(ReplicatedStorage.Shared.modules.core.DataTemplate)

export type Drop = {
	id: string,
	min: number,
	max: number,
	chance: number,
}

export type Drops = { [DataTemplate.InventoryCategory]: { Drop } }

export type XP = {
	mining: number,
	player: number,
}

export type LootTable = {
	maxChance: number,
	drops: Drops?,
	xp: XP?,
}

return {}
