export type DialogueContext = {
	player: Player?,
	entryId: string,
	currentNodeId: string,
	flags: { [string]: any }?,
	startedAt: number,
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
	choices: {
		{
			text: string,
			next: string,
			conditions: { string }?,
		}
	},
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

return {}
