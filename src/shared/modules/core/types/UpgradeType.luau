export type UpgradeEffect<TItem> = {
	scaleType: "add" | "multiply",
	stats: {
		durability: number?,
		miningPower: number?,
		miningSpeed: number?,
	}?,

	onMine: ((tool: any, ore: any, player: Player) -> ())?,

	dropMultiplier: number?,
}

export type UpgradeData<TItem> = {
	name: string,
	description: string,
	maxLevel: number,
	levels: {
		[number]: string,
	},
	excludes: { string },

	applicableTo: { string }?,

	effect: UpgradeEffect<TItem>,
}

return {}
