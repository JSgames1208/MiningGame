export type Drop = {
	id: string,
	min: number,
	max: number,
	chance: number,
}

export type XP = {
	mining: number,
	player: number,
}

export type LootTable = {
	maxChance: number,
	drops: { Drop }?,
	xp: XP?,
}

return {}
