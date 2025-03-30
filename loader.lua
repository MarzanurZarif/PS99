local cloneref = cloneref or function(o) return o end

if not game:IsLoaded() then
	print("Waiting for game to load...")
    game.Loaded:Wait()
end
task.wait(1)
print("Game Loaded...")

queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
TeleportService = cloneref(game:GetService("TeleportService"))
GuiService = cloneref(game:GetService("GuiService"))
Lighting = cloneref(game:GetService("Lighting"))
HttpService = cloneref(game:GetService("HttpService"))
httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)



local function Serverhop()
	print("Server hopping...")
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
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server, game.Players.LocalPlayer)
        end
    end
end

local function Antilag()
	print("Antilag...")
    local Terrain = workspace:FindFirstChildOfClass('Terrain')
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
	Terrain.WaterTransparency = 0
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 9e9
	settings().Rendering.QualityLevel = 1
	for i,v in pairs(game:GetDescendants()) do
		if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
			v.Material = "Plastic"
			v.Reflectance = 0
		elseif v:IsA("Decal") then
			v.Transparency = 1
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Lifetime = NumberRange.new(0)
		elseif v:IsA("Explosion") then
			v.BlastPressure = 1
			v.BlastRadius = 1
		end
	end
	for i,v in pairs(Lighting:GetDescendants()) do
		if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
			v.Enabled = false
		end
	end
	workspace.DescendantAdded:Connect(function(child)
		task.spawn(function()
			if child:IsA('ForceField') then
				RunService.Heartbeat:Wait()
				child:Destroy()
			elseif child:IsA('Sparkles') then
				RunService.Heartbeat:Wait()
				child:Destroy()
			elseif child:IsA('Smoke') or child:IsA('Fire') then
				RunService.Heartbeat:Wait()
				child:Destroy()
			end
		end)
	end)
end

Antilag()

local function UnequipHover()
	game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Hoverboard_RequestUnequip"):FireServer()
end

UnequipHover()
print("Loading Script...")
task.wait(1)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Verteniasty/Pet-rbx/refs/heads/main/loadstring"))()

local TeleportCheck = false
Players.LocalPlayer.OnTeleport:Connect(function(State)
	if (not TeleportCheck) and queueteleport then
		TeleportCheck = true
		queueteleport("")
	end
end)

GuiService.ErrorMessageChanged:Connect(function()
	print("Error Message")
	while true do
		task.wait(10)
    	Serverhop()
	end
end)
