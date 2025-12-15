export type Progress = {
	completed: boolean,
	requirements: {
		[string]: {
			current: number,
			target: number,
		},
	},
}

export type Runtime = {
	player: Player,
	questId: string,
	data: any,
	progress: Progress,
	complete: () -> (),
	_conn: RBXScriptConnection?,
}

export type RequirementRuntime = {
	id: string,
	data: any,
	progress: {
		current: number,
		target: number,
	},
	complete: () -> (),
}

export type QuestTypeModule = {
	supports: (reqType: string) -> boolean,
	startRequirement: (runtime: Runtime, req: RequirementRuntime) -> RBXScriptConnection?,
	stopRequirement: (conn: RBXScriptConnection?) -> (),
}

local Base = {}

function Base.newProgress(requirements: { [string]: number }): Progress
	local r = {}
	for id, target in requirements do
		r[id] = {
			current = 0,
			target = target,
		}
	end

	return {
		completed = false,
		requirements = r,
	}
end

return Base
