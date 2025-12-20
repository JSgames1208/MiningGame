export type RequirementData = {
	type: string,
	target: any,
	amount: number,
}

export type QuestData = {
	name: string,
	turninDialogue: string?,
	questType: { string },
	requirements: { RequirementData },
	rewards: { items: { { id: string, amount: number } } },
}

export type Questline = {
	id: string,
	quests: { string },
}

return {}
