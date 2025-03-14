local ProfileService = require(game.ReplicatedStorage.ProfileService)
local Players = game:GetService("Players")

local ProfileStore = ProfileService.GetProfileStore(
	"TestSave7", -- OfficialSave1
	{ 
		OreInventory = {
			["Dirt"] = 0,
			["Clay"] = 0,
			["Iron"] = 0,
			["Coal"] = 0,
			["Stone"] = 0,
			["Bedrock"] = 0,
			["Diamond"] = 0,
			["Emerald"] = 0,
			["Limestone"] = 0,
			["Sandstone"] = 0
		},

		OreCapacity = 50,
		Money = 0,

		PickaxeSpeed = 5
	}
)

local Profiles = {}

local function onPlayerAdded(player)
	local profile = ProfileStore:LoadProfileAsync("Player_"..player.UserId, "ForceLoad")
	
	if profile then
		profile:AddUserId(player.UserId)
		profile:Reconcile()

		profile:ListenToRelease(function()
			Profiles[player] = nil
			player:Kick("Data has been loaded on another server.")
		end)
		
		if player:IsDescendantOf(Players) then
			Profiles[player] = profile
		else
			profile:Release()
		end
	else
		player:Kick("Failure loading data. Please rejoin.\n If this issue continues to happen please contact a developer on the communications server.")
	end
end

local function onPlayerRemoving(player)
	local profile = Profiles[player]
	if profile then
		if player.TempMulti.Value == true then
			player.MultiplierValue.Value /= 2
		end
		profile:Release()
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)


local DataManager = {}

function DataManager:Get(player)
	local profile = Profiles[player]
	
	if profile then
		return profile.Data
	end
end

return DataManager