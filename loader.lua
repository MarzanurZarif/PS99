local cloneref = cloneref or function(o) return o end

if not game:IsLoaded() then
	print("Waiting for game to load...")
    game.Loaded:Wait()
end
task.wait(1)
print("Game Loaded...")

queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)

print("Loading Script...")
task.wait(1)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Verteniasty/Pet-rbx/refs/heads/main/loadstring"))()

local TeleportCheck = false
Players.LocalPlayer.OnTeleport:Connect(function(State)
	if (not TeleportCheck) and queueteleport then
		TeleportCheck = true
		queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/MarzanurZarif/PS99/refs/heads/main/loader.lua'))()")
	end
end)
