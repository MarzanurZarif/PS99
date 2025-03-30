local NotificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/IceMinisterq/Notification-Library/Main/Library.lua"))()

local cloneref = cloneref or function(o) return o end

if not game:IsLoaded() then
	print("Waiting for game to load...")
	NotificationLibrary:SendNotification("Warning", "Waiting for game to load...", 5)
    game.Loaded:Wait()
end
print("Game Loaded...")
NotificationLibrary:SendNotification("Success", "Game Loaded...", 5)

queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
local autoexe = coroutine.create(function()
	local TeleportCheck = false
	print("Initiating autoexe...")
	NotificationLibrary:SendNotification("Info", "Initiating autoexe...", 5)
	game.Players.LocalPlayer.OnTeleport:Connect(function(State)
		if (not TeleportCheck) and queueteleport then
			TeleportCheck = true
			queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/MarzanurZarif/PS99/refs/heads/main/loader.lua'))()")
		end
	end)
end)
coroutine.resume(autoexe)

local OreCheckHop = coroutine.create(function()
	local Checked = 0
	NotificationLibrary:SendNotification("Info", "Initiating auto serverhop...", 5)
	while true do
		repeat
			task.wait()
		until workspace.__THINGS.BlockWorlds:FindFirstChild("Blocks_8")
		if not #workspace.__THINGS.BlockWorlds.Blocks_8:GetChildren() > 0 then
			Checked = Checked + 1
			NotificationLibrary:SendNotification("Warning", "No blocks found in mine...", 5)
			if Checked > 2 then
				Serverhop()
			end
		end
	end
end)
coroutine.resume(OreCheckHop)

print("Loading Script...")
NotificationLibrary:SendNotification("Info", "Loading Script...", 5)
task.wait(1)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Verteniasty/Pet-rbx/refs/heads/main/loadstring"))()
