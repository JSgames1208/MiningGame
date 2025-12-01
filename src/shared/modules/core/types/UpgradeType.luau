export type UpgradeApplyFn<TItem> = (item: TItem, level: number) -> ()

export type UpgradeData<TItem> = {
	name: string,
	description: string,
	maxLevel: number,

	applicableTo: { string }?,

	apply: UpgradeApplyFn<TItem>,
}

return {}
