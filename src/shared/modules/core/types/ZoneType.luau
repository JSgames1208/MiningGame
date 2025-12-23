export type ZoneData = {
	name: string,
	description: string,
	cost: number?,
	previous: string?,
	ores: {
		weights: {
			[string]: number,
		},
	},
}

export type ZoneUIData = {
	id: string,
	name: string,
	cost: number,
}

return {}
