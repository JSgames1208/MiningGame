export type DialogueQueryContext = {
	player: Player?,
	npcId: string,

	services: {
		quest: any,
	},

	runtime: {
		[string]: any,
	}?,
}

export type DialogueRuntimeContext = {
	player: Player?,
	entryId: string,
	npcId: string,
	currentNodeId: string,
	services: { quest: any },
	startedAt: number,

	runtime: {
		[string]: any,
	},
}

export type NodeType = "line" | "choice" | "end"

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
	prompt: string,
	choices: { Choice },
}

export type EndNode = BaseNode & {
	type: "end",
}

export type DialogueNode = LineNode | ChoiceNode | EndNode

export type DialogueConditionBlock = {
	type: string,
	data: any,
}

export type DialogueStage = {
	when: { DialogueConditionBlock }?,
	start: string,
	priority: number?,
	weight: number?,
}

export type SimpleDialogueEntry = {
	start: string,
	conditions: { DialogueConditionBlock }?,
	priority: number?,
	weight: number?,
}

export type StagedDialogueEntry = {
	stages: { DialogueStage },
}

export type DialogueEntry = SimpleDialogueEntry | StagedDialogueEntry

export type DialogueCondition = (context: DialogueQueryContext, data: any) -> boolean

export type CommandData = {
	type: string,
	[string]: any,
}

export type DialogueCommand = (ctx: DialogueRuntimeContext, data: CommandData) -> ()

export type BaseSnapshot<T = NodeType> = {
	npcId: string,
	nodeType: T,
}

export type LineSnapshot = BaseSnapshot<"line"> & {
	speaker: string,
	text: string,
}

export type ChoiceSnapshot = BaseSnapshot<"choice"> & {
	prompt: string,
	choices: { Choice },
}

export type EndSnapshot = BaseSnapshot<"end">

export type DialogueSnapshot = LineSnapshot | ChoiceSnapshot | EndSnapshot

return {}
