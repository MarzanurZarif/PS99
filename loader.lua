local NotificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/IceMinisterq/Notification-Library/Main/Library.lua"))()

local cloneref = cloneref or function(o) return o end

if not game:IsLoaded() then
	print("Waiting for game to load...")
	NotificationLibrary:SendNotification("Warning", "Waiting for game to load...", 5)
    game.Loaded:Wait()
end
print("Game Loaded...")
NotificationLibrary:SendNotification("Success", "Game Loaded...", 5)

TeleportService = cloneref(game:GetService("TeleportService"))
queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
HttpService = cloneref(game:GetService("HttpService"))
httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

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

local function Serverhop()
	print("Server hopping...")
	NotificationLibrary:SendNotification("Info", "Server hopping...", 5)
    if httprequest then
        local server = nil
        local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true", game.PlaceId)})
        local body = HttpService:JSONDecode(req.Body)

        if body and body.data then
            local BestFPS = 0
            local BestPing = math.huge
            for i, v in next, body.data do
                if type(v) == "table" and 
				tonumber(v.playing) and tonumber(v.maxPlayers) and tonumber(v.fps) and tonumber(v.ping) and 
				v.playing < v.maxPlayers and v.id ~= JobId and 
				tonumber(v.fps) >= BestFPS and tonumber(v.ping) <= BestPing then
                    BestFPS = tonumber(v.fps)
                    BestPing = tonumber(v.ping)
                    server = v.id
                end
                task.wait()
            end
        end

        if server then
			local success, result = pcall(function()
				return TeleportService:TeleportToPlaceInstance(game.PlaceId, server, game.Players.LocalPlayer)
			end)
			
			if not success then
				warn(result)
				NotificationLibrary:SendNotification("Error", result, 5)
			end
			
	    	TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
		        if player == game.Players.LocalPlayer then
		            print("Teleport failed, TeleportResult: "..teleportResult.Name)
					NotificationLibrary:SendNotification("Error", "Teleport failed, TeleportResult: "..teleportResult.Name, 5)
		            if teleportResult == Enum.TeleportResult.Failiure or teleportResult == Enum.TeleportResult.Flooded then
		                task.wait(5)
						print("Reattempting teleport")
						NotificationLibrary:SendNotification("Info", "Retrying simple teleport...", 5)
						TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
		            end
		        end
		    end)
        end
    end
end

local OreCheckHop = coroutine.create(function()
	local Checked = 0
	NotificationLibrary:SendNotification("Info", "Initiating auto serverhop...", 5)
	while true do
		if workspace.__THINGS.BlockWorlds:FindFirstChild("Blocks_8") and #workspace.__THINGS.BlockWorlds.Blocks_8:GetChildren() <= 0 then
			Checked = Checked + 1
			NotificationLibrary:SendNotification("Warning", "No blocks found in mine... Serverhopping in "..tostring(4-Checked), 1)
			if Checked > 2 then
				Serverhop()
				break
			end
		else
			Checked = 0
		end
		task.wait(1)
	end
end)
coroutine.resume(OreCheckHop)

print("Loading Script...")
NotificationLibrary:SendNotification("Info", "Loading Script...", 5)
task.wait(1)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Verteniasty/Pet-rbx/refs/heads/main/loadstring"))()
