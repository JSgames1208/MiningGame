export type DialogueContext = {
	player: Player?,
	entryId: string,
	currentNodeId: string,
	services: { quest: any },
	startedAt: number,

	runtime: {
		[string]: any,
	},
}

export type Choice = {
	text: string,
	next: string,
	conditions: { string }?,
}

export type BaseNode = {
	id: string,
	type: string,
}

export type LineNode = BaseNode & {
	type: "line",
	speaker: string,
	text: string,
	next: string?,
	commands: { CommandData },
}

export type ChoiceNode = BaseNode & {
	type: "choice",
	choices: { Choice },
}

export type EndNode = BaseNode & {
	type: "end",
}

export type DialogueNode = LineNode | ChoiceNode | EndNode

export type DialogueEntry = {
	start: string,
	conditions: { string }?,
	priority: number?,
	weight: number?,
}

export type DialogueCondition = (context: DialogueContext) -> boolean

export type CommandData = {
	type: string,
	[string]: any,
}

export type DialogueCommand = (ctx: DialogueContext, data: CommandData) -> ()

export type DialogueSnapshot = {
	npcId: string,
	nodeType: string,
	speaker: string,
	text: string,
}

return {}
