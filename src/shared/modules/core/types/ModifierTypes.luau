export type OperationType = "ADD" | "MULTIPLY_BASE" | "MULTIPLY_TOTAL"

export type Modifier = {
	id: string,
	type: OperationType,
	attribute: string,
	value: number,
	persistent: boolean,
	expiresAt: number?,
	source: string?,
}

return {}
