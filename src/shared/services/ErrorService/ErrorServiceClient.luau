--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local errorSlice = require(ReplicatedStorage.Shared.ui.features.error.state.errorSlice)

local ErrorServiceClient = {}

function ErrorServiceClient.init(self: ErrorServiceClient)
	self:clearError()
end

function ErrorServiceClient.displayError(self: ErrorServiceClient, err: string)
	errorSlice.actions.setErrorOpen(true)
	errorSlice.actions.setErrorMessage(err)
end

function ErrorServiceClient.clearError(self: ErrorServiceClient)
	errorSlice.actions.setErrorOpen(false)
	errorSlice.actions.setErrorMessage("")
end

export type ErrorServiceClient = typeof(ErrorServiceClient) & {}

return ErrorServiceClient
