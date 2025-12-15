export type RequirementData = {
	type: string,
	target: any,
	amount: number,
}

export type QuestData = {
	name: string,
	questType: { ModuleScript },
	requirements: { RequirementData },
	rewards: { items: { { id: string, amount: number } } },
}

return {}
