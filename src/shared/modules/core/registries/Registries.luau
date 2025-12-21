local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Registry = require(ReplicatedStorage.Shared.modules.core.Registry)
local AttributeTypes = require(ReplicatedStorage.Shared.modules.core.types.AttributeTypes)
local ItemType = require(ReplicatedStorage.Shared.modules.core.types.ItemType)
local LootTableType = require(ReplicatedStorage.Shared.modules.core.types.LootTableType)
local ModifierTypes = require(ReplicatedStorage.Shared.modules.core.types.ModifierTypes)
local NPCTypes = require(ReplicatedStorage.Shared.modules.core.types.NPCTypes)
local OreType = require(ReplicatedStorage.Shared.modules.core.types.OreType)
local QuestType = require(ReplicatedStorage.Shared.modules.core.types.QuestType)
local UpgradeType = require(ReplicatedStorage.Shared.modules.core.types.UpgradeType)
local ZoneType = require(ReplicatedStorage.Shared.modules.core.types.ZoneType)
local DialogueTypes = require(ReplicatedStorage.Shared.modules.core.types.dialogue.DialogueTypes)

type Registry<T> = Registry.Registry<T>

export type Registries = {
	ITEM: Registry<ItemType.ItemData>,
	UPGRADE: Registry<UpgradeType.UpgradeData<any>>,
	ORE: Registry<OreType.OreData>,
	LOOTTABLE: Registry<LootTableType.LootTable>,
	ZONE: Registry<ZoneType.ZoneData>,
	QUEST: Registry<QuestType.QuestData>,
	DIALOGUE_NODE: Registry<DialogueTypes.DialogueNode>,
	DIALOGUE_ENTRY: Registry<DialogueTypes.DialogueEntry>,
	DIALOGUE_CONDITION: Registry<DialogueTypes.DialogueCondition>,
	DIALOGUE_COMMAND: Registry<DialogueTypes.DialogueCommand>,
	NPC: Registry<NPCTypes.NPCData>,
	QUESTLINE: Registry<QuestType.Questline>,
	ATTRIBUTE: Registry<AttributeTypes.Attribute>,
	MODIFIER: Registry<ModifierTypes.Modifier>,
}

local Registries: Registries = {
	ITEM = Registry.new() :: Registry<ItemType.ItemData>,
	UPGRADE = Registry.new() :: Registry<UpgradeType.UpgradeData<any>>,
	ORE = Registry.new() :: Registry<OreType.OreData>,
	LOOTTABLE = Registry.new() :: Registry<LootTableType.LootTable>,
	ZONE = Registry.new() :: Registry<ZoneType.ZoneData>,
	QUEST = Registry.new() :: Registry<QuestType.QuestData>,
	DIALOGUE_NODE = Registry.new() :: Registry<DialogueTypes.DialogueNode>,
	DIALOGUE_ENTRY = Registry.new() :: Registry<DialogueTypes.DialogueEntry>,
	DIALOGUE_CONDITION = Registry.new() :: Registry<DialogueTypes.DialogueCondition>,
	DIALOGUE_COMMAND = Registry.new() :: Registry<DialogueTypes.DialogueCommand>,
	NPC = Registry.new() :: Registry<NPCTypes.NPCData>,
	QUESTLINE = Registry.new() :: Registry<QuestType.Questline>,
	ATTRIBUTE = Registry.new() :: Registry<AttributeTypes.Attribute>,
	MODIFIER = Registry.new() :: Registry<ModifierTypes.Modifier>,
}

return Registries
