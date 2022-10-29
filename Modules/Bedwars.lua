local HamWare = shared["HamWare"]
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
local window = library:CreateWindow({
    Name = "HamWare "..HamWare["Version"],
    LoadingTitle = "HamWare "..HamWare["Version"],
    LoadingSubtitle = "Made by Ham135#6306",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "HW"..HamWare["SaveName"]
    },
    KeySystem = false,
    KeySettings = {
        Title = "HamWare "..HamWare["Version"],
        Subtitle = "Key Required",
        Note = "The Script's Name",
        Key = "HamWare"
    }
})
HamWare["Tabs"] = {
    ["Combat"] = window:CreateTab("Combat"),
    ["Blatant"] = window:CreateTab("Blatant"),
    ["Render"] = window:CreateTab("Render"),
    ["Utility"] = window:CreateTab("Utility"),
    ["World"] = window:CreateTab("World"),
    ["Exploits"] = window:CreateTab("Exploits")
}
HamWare["Sections"] = {
    ["Combat"] = HamWare["Tabs"]["Combat"]:CreateSection("Combat"),
    ["Blatant"] = HamWare["Tabs"]["Blatant"]:CreateSection("Blatant"),
    ["Render"] = HamWare["Tabs"]["Render"]:CreateSection("Render"),
    ["Utility"] = HamWare["Tabs"]["Utility"]:CreateSection("Utility"),
    ["World"] = HamWare["Tabs"]["World"]:CreateSection("World"),
    ["Exploits"] = HamWare["Tabs"]["Exploits"]:CreateSection("Exploits")
}
HamWare["Library"] = library
local LastNotification = 0
function createnotification(Title2,Content2)
    local diff = math.abs(LastNotification - tick())
    if diff >= 0.3 then
        library:Notify(Title2,Content2,10010348543)
        LastNotification = tick()
    end
end
function runcode(func)
    func()
end
local NewFunc = {}; NewFunc["NewElement"] = function(argtable)
    local toggled = false
    local addfuncs = {}
    local toggle = argtable["Tab"]:CreateToggle({
        Name = argtable["Name"],
        CurrentValue = false,
        Flag = "Toggle_"..argtable["Name"],
        Callback = function(Val)
            toggled = Val
            if toggled then
                spawn(function()
                    createnotification("Module Toggled",argtable["Name"].." has been Enabled!")
                end)
                spawn(function()
                    argtable["Callback"](true)
                end)
            else
                spawn(function()
                    createnotification("Module Toggled",argtable["Name"].." has been Disabled!")
                end)
                spawn(function()
                    argtable["Callback"](false)
                end)
            end
        end
    })
    argtable["Tab"]:CreateKeybind({
        Name = argtable["Name"].." Keybind",
        CurrentKeybind = "",
        HoldToInteract = false,
        Flag = argtable["Name"].."_Bind",
        Callback = function()
            toggle:Set(not toggled)
        end
    })
    function addfuncs:NewTextbox(argtable2)
        argtable["Tab"]:CreateInput({
            Name = argtable2["Name"],
            PlaceholderText = "Input Here",
            RemoveTextAfterFocusLost = false,
            Flag = "Textbox_"..argtable["Name"].."_"..argtable2["Name"],
            Callback = argtable2["Callback"]
        })
    end
    function addfuncs:NewDropdown(argtable2)
        argtable["Tab"]:CreateDropdown({
            Name = argtable2["Name"],
            Options = argtable2["List"],
            CurrentOption = argtable2["Default"] or (argtable2["List"][1]),
            Flag = "Dropdown_"..argtable["Name"].."_"..argtable2["Name"],
            Callback = argtable2["Callback"]
        })
    end
    function addfuncs:NewSlider(argtable2)
        argtable["Tab"]:CreateSlider({
            Name = argtable2["Name"],
            Range = {argtable2["Min"] or 0, argtable2["Max"]},
            Increment = argtable2["Increment"] or 1,
            Suffix = "",
            CurrentValue = argtable2["Default"] or 0,
            Flag = "Slider_"..argtable["Name"].."_"..argtable2["Name"],
            Callback = argtable2["Callback"]
        })
    end
    return addfuncs
end
HamWare["Createnotification"] = Createnotification
HamWare["NewElement"] = NewElement

local lplr = game:GetService("Players").LocalPlayer
local cam = game:GetService("Workspace").CurrentCamera
local uis = game:GetService("UserInputService")
local KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
local Client = require(game:GetService("ReplicatedStorage").TS.remotes).default.Client
local getremote = function(tab)
    for i,v in pairs(tab) do
        if v == "Client" then
            return tab[i + 1]
        end
    end
    return ""
end
local bedwars = {
    ["SprintController"] = KnitClient.Controllers.SprintController,
    ["ClientHandlerStore"] = require(lplr.PlayerScripts.TS.ui.store).ClientStore,
    ["KnockbackUtil"] = require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil,
    ["PingController"] = require(lplr.PlayerScripts.TS.controllers.game.ping["ping-controller"]).PingController,
    ["DamageIndicator"] = KnitClient.Controllers.DamageIndicatorController.spawnDamageIndicator,
    ["SwordController"] = KnitClient.Controllers.SwordController,
    ["ViewmodelController"] = KnitClient.Controllers.ViewmodelController,
    ["SwordRemote"] = getremote(debug.getconstants((KnitClient.Controllers.SwordController).attackEntity)),
}

function isalive(plr)
    plr = plr or lplr
    if not plr.Character then return false end
    if not plr.Character:FindFirstChild("Head") then return false end
    if not plr.Character:FindFirstChild("Humanoid") then return false end
    return true
end
function canwalk(plr)
    plr = plr or lplr
    if not plr.Character then return false end
    if not plr.Character:FindFirstChild("Humanoid") then return false end
    local state = plr.Character:FindFirstChild("Humanoid"):GetState()
    if state == Enum.HumanoidStateType.Dead then
        return false
    end
    if state == Enum.HumanoidStateType.Ragdoll then
        return false
    end
    return true
end
function getbeds()
    local beds = {}
    for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
        if string.lower(v.Name) == "bed" and v:FindFirstChild("Covers") ~= nil and v:FindFirstChild("Covers").Color ~= lplr.Team.TeamColor then
            table.insert(beds,v)
        end
    end
    return beds
end
function getplayers()
    local players = {}
    for i,v in pairs(game:GetService("Players"):GetPlayers()) do
        if v.Team ~= lplr.Team and isalive(v) and v.Character:FindFirstChild("Humanoid").Health > 0.11 then
            table.insert(players,v)
        end
    end
    return players
end
function getserverpos(Position)
    local x = math.round(Position.X/3)
    local y = math.round(Position.Y/3)
    local z = math.round(Position.Z/3)
    return Vector3.new(x,y,z)
end
function getnearestplayer(maxdist)
    local obj = lplr
    local dist = math.huge
    for i,v in pairs(game:GetService("Players"):GetChildren()) do
        if v.Team ~= lplr.Team and v ~= lplr and isalive(v) and isalive(lplr) then
            local mag = (v.Character:FindFirstChild("HumanoidRootPart").Position - lplr.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
            if (mag < dist) and (mag < maxdist) then
                dist = mag
                obj = v
            end
        end
    end
    return obj
end
function getmatchstate()
	return bedwars["ClientHandlerStore"]:getState().Game.matchState
end
function getqueuetype()
    local state = bedwars["ClientHandlerStore"]:getState()
    return state.Game.queueType or "bedwars_test"
end
function getitem(itm)
    if isalive(lplr) and lplr.Character:FindFirstChild("InventoryFolder").Value:FindFirstChild(itm) then
        return true
    end
    return false
end

runcode(function()
    local Enabled = false
    local Sprint = NewFunc["NewElement"]({
        ["Name"] = "Sprint",
        ["Tab"] = HamWare["Tabs"]["Combat"],
        ["Callback"] = function(val)
            Enabled = val
            if Enabled then
                spawn(function()
                    repeat
                        task.wait()
                        if not bedwars["SprintController"].sprinting then
                            bedwars["SprintController"]:startSprinting()
                        end
                    until not Enabled
                end)
            else
                bedwars["SprintController"]:stopSprinting()
            end
        end
    })
end)

runcode(function()
    local part
    local connection
    local Enabled = false
    local AntiVoid = NewFunc["NewElement"]({
        ["Name"] = "AntiVoid",
        ["Tab"] = HamWare["Tabs"]["World"],
        ["Callback"] = function(val)
            Enabled = val
            if Enabled then
                part = Instance.new("Part")
                part.Anchored = true
                part.Size = Vector3.new(3000,3,3000)
                part.Color = Color3.fromRGB(90,90,90)
                part.Material = Enum.Material.Neon
                part.Transparency = 0.5
                part.Parent = game:GetService("Workspace")
                connection = part.Touched:Connect(function(part2)
                    if part2.Parent.Name == lplr.Name and isalive(lplr) and lplr.Character:FindFirstChild("Humanoid").Health > 0.1 then
                        for i = 1,25 do
                            task.wait(0.03)
                            lplr.Character:FindFirstChild("HumanoidRootPart").Velocity = lplr.Character:FindFirstChild("HumanoidRootPart").Velocity + Vector3.new(0,6,0)
                        end
                    end
                end)
                spawn(function()
                    repeat task.wait() until getmatchstate() ~= 0
                    local hrp = lplr.Character:FindFirstChild("HumanoidRootPart")
                    part.CFrame = CFrame.new(hrp.Position.X,hrp.Position.Y-10,hrp.Position.Z)
                end)
            else
                part:Destroy()
                connection:Disconnect()
            end
        end
    })
end)

runcode(function()
    local old
    local Enabled = false
    local NoKnockback = NewFunc["NewElement"]({
        ["Name"] = "NoKnockback",
        ["Tab"] = HamWare["Tabs"]["Blatant"],
        ["Callback"] = function(val)
            Enabled = val
            if Enabled then
                old = bedwars["KnockbackUtil"].applyKnockback
                bedwars["KnockbackUtil"].applyKnockback = function() end
            else
                bedwars["KnockbackUtil"].applyKnockback = old
                old = nil
            end
        end
    })
end)

runcode(function()
    local connection
    local Enabled = false
    local StaffDetector = NewFunc["NewElement"]({
        ["Name"] = "StaffDetector",
        ["Tab"] = HamWare["Tabs"]["Utility"],
        ["Callback"] = function(val)
            Enabled = val
            if Enabled then
                for i,v in pairs(game:GetService("Players"):GetPlayers()) do
                    if v:IsInGroup(5774246) and v:GetRankInGroup(5774246) >= 100 then
                        Client:Get("TeleportToLobby"):SendToServer()
                    elseif v:IsInGroup(5774246,4199740) and v:GetRankInGroup(5774246,4199740) >= 1 then
                        Client:Get("TeleportToLobby"):SendToServer()
                    end
                end
                connection = game:GetService("Players").PlayerAdded:Connect(function(v)
                    if v:IsInGroup(5774246) and v:GetRankInGroup(5774246) >= 100 then
                        Client:Get("TeleportToLobby"):SendToServer()
                    elseif v:IsInGroup(5774246,4199740) and v:GetRankInGroup(5774246,4199740) >= 1 then
                        Client:Get("TeleportToLobby"):SendToServer()
                    end
                end)
            else
                connection:Disconnect()
            end
        end
    })
end)

runcode(function()
    local connection
    local Enabled = false
    local NoFall = NewFunc["NewElement"]({
        ["Name"] = "NoFall",
        ["Tab"] = HamWare["Tabs"]["Blatant"],
        ["Callback"] = function(val)
            Enabled = val
            if Enabled then
                spawn(function()
                    repeat
                        task.wait(0.5)
                        Client:Get("GroundHit"):SendToServer()
                    until not Enabled
                end)
            end
        end
    })
end)

runcode(function()
    local connection
    local NewFOV = {["Value"] = 120}
    local Enabled = false
    local FOVChanger = NewFunc["NewElement"]({
        ["Name"] = "FOVChanger",
        ["Tab"] = HamWare["Tabs"]["Render"],
        ["Callback"] = function(val)
            Enabled = val
            if Enabled then
                cam.FieldOfView = NewFOV["Value"]
                connection = cam:GetPropertyChangedSignal("FieldOfView"):Connect(function()
                    cam.FieldOfView = NewFOV["Value"]
                end)
            else
                connection:Disconnect()
                cam.FieldOfView = 80
            end
        end
    })
    FOVChanger:NewSlider({
        ["Name"] = "NewFOV",
        ["Min"] = 30,
        ["Max"] = 120,
        ["Default"] = 120,
        ["Callback"] = function(val)
            NewFOV["Value"] = val
        end
    })
end)

runcode(function()
    local Multiplier = {["Value"] = 0.04}
    local Enabled = false
    local Speed = NewFunc["NewElement"]({
        ["Name"] = "Speed",
        ["Tab"] = HamWare["Tabs"]["Blatant"],
        ["Callback"] = function(val)
            Enabled = val
            if Enabled then
                spawn(function()
                    repeat
                        task.wait()
                        if isalive(lplr) then
                            local hrp = lplr.Character:FindFirstChild("HumanoidRootPart")
                            local hum = lplr.Character:FindFirstChild("Humanoid")
                            if isnetworkowner(hrp) and hum.MoveDirection.Magnitude > 0 then
                                lplr.Character:TranslateBy(hum.MoveDirection * Multiplier["Value"])
                            end
                        end
                    until not Enabled
                end)
            end
        end
    })
    Speed:NewSlider({
        ["Name"] = "SpeedVal",
        ["Min"] = 0,
        ["Max"] = 1,
        ["Increment"] = 0.01,
        ["Default"] = 0.04,
        ["Callback"] = function(val)
            Multiplier["Value"] = val
        end
    })
end)

runcode(function()
    local velo
    local Mode = {["Value"] = "Vulcan"}
    local Enabled = false
    local Fly = NewFunc["NewElement"]({
        ["Name"] = "Fly",
        ["Tab"] = HamWare["Tabs"]["Blatant"],
        ["Callback"] = function(val)
            Enabled = val
            if Enabled then
                velo = Instance.new("BodyVelocity")
                velo.MaxForce = Vector3.new(0,9e9,0)
                velo.Parent = lplr.Character:FindFirstChild("HumanoidRootPart")
                spawn(function()
                    repeat
                        task.wait()
                        if Mode["Value"] == "Vulcan" then
                            velo.Velocity = Vector3.new(0,1,0)
                            task.wait(0.15)
                            velo.Velocity = Vector3.new(0,0.1,0)
                            task.wait(0.15)
                        else
                            Mode["Value"] = "Vulcan"
                        end
                    until not Enabled
                end)
            else
                velo:Destroy()
                for i,v in pairs(lplr.Character:FindFirstChild("HumanoidRootPart"):GetChildren()) do
                    if v:IsA("BodyVelocity") then
                        v:Destroy()
                    end
                end
            end
        end
    })
end)

runcode(function()
    local old
    local Enabled = false
    local Speed = NewFunc["NewElement"]({
        ["Name"] = "NoIndicator",
        ["Tab"] = HamWare["Tabs"]["Render"],
        ["Callback"] = function(val)
            Enabled = val
            if Enabled then
                old = bedwars["PingController"].createIndicator
                bedwars["PingController"].createIndicator = function() end
            else
                bedwars["PingController"].createIndicator = old
                old = nil
            end
        end
    })
end)

runcode(function()
    local Distance = {["Value"] = 30}
    local Enabled = false
    local Nuker = NewFunc["NewElement"]({
        ["Name"] = "Nuker",
        ["Tab"] = HamWare["Tabs"]["World"],
        ["Callback"] = function(val)
            Enabled = val
            if Enabled then
                spawn(function()
                    repeat
                        task.wait(0.1)
                        if isalive(lplr) and lplr.Character:FindFirstChild("Humanoid").Health > 0.1 then
                            local beds = getbeds()
                            for i,v in pairs(beds) do
                                local mag = (v.Position - lplr.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
                                if mag < Distance["Value"] then
                                    local serverpos = getserverpos(v.Position)
                                    game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.DamageBlock:InvokeServer({
                                        ["blockRef"] = {
                                            ["blockPosition"] = serverpos
                                        },
                                        ["hitPosition"] = serverpos,
                                        ["hitNormal"] = serverpos
                                    })
                                end
                            end
                        end
                    until not Enabled
                end)
            end
        end
    })
    Nuker:NewSlider({
        ["Name"] = "Distance",
        ["Min"] = 0,
        ["Max"] = 30,
        ["Default"] = 30,
        ["Callback"] = function(val)
            Distance["Value"] = val
        end
    })
end)

runcode(function()
    local old
    local Enabled = false
    local RainbowIndicator = NewFunc["NewElement"]({
        ["Name"] = "RainbowIndicator",
        ["Tab"] = HamWare["Tabs"]["Render"],
        ["Callback"] = function(val)
            Enabled = val
            if Enabled then
                old = debug.getupvalue(bedwars["DamageIndicator"],10,{Create})
                debug.setupvalue(bedwars["DamageIndicator"],10,{
                    Create = function(self,obj,...)
                        spawn(function()
                            obj.Parent.TextColor3 = Color3.fromHSV(tick()%5/5,1,1)
                        end)
                        return game:GetService("TweenService"):Create(obj,...)
                    end
                })
            else
                debug.setupvalue(bedwars["DamageIndicator"],10,{
                    Create = old
                })
                old = nil
            end
        end
    })
end)

runcode(function()
    local Enabled = false
    local AutoQueue = NewFunc["NewElement"]({
        ["Name"] = "AutoQueue",
        ["Tab"] = HamWare["Tabs"]["Utility"],
        ["Callback"] = function(val)
            Enabled = val
            if Enabled then
                spawn(function()
                    repeat task.wait(3) until getmatchstate() == 2 or not Enabled
                    if not Enabled then return end
                    game:GetService("ReplicatedStorage"):FindFirstChild("events-@easy-games/lobby:shared/event/lobby-events@getEvents.Events").joinQueue:FireServer({["queueType"] = getqueuetype()})
                end)
            end
        end
    })
end)

runcode(function()
    local New = {["Value"] = 196}
    local Enabled = false
    local Gravity = NewFunc["NewElement"]({
        ["Name"] = "Gravity",
        ["Tab"] = HamWare["Tabs"]["Blatant"],
        ["Callback"] = function(val)
            Enabled = val
            if Enabled then
                spawn(function()
                    repeat
                        task.wait()
                        game:GetService("Workspace").Gravity = New["Value"]
                    until not Enabled
                    game:GetService("Workspace").Gravity = 196.2
                end)
            else
                game:GetService("Workspace").Gravity = 196.2
            end
        end
    })
    Gravity:NewSlider({
        ["Name"] = "New",
        ["Min"] = 0,
        ["Max"] = 196,
        ["Default"] = 196,
        ["Callback"] = function(val)
            New["Value"] = val
        end
    })
end)

runcode(function()
    local highlights = {}
    local newbed
    local Enabled = false
    local BedESP = NewFunc["NewElement"]({
        ["Name"] = "BedESP",
        ["Tab"] = HamWare["Tabs"]["Render"],
        ["Callback"] = function(val)
            Enabled = val
            if Enabled then
                newbed = game:GetService("Workspace").ChildAdded:Connect(function(v)
                    if string.lower(v.Name) == "bed" then
                        for i2,v2 in pairs(v:GetChildren()) do
                            local hl = Instance.new("Highlight")
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Enabled = true
                            hl.FillColor = v.Color
                            hl.FillTransparency = 0
                            hl.OutlineColor = Color3.fromRGB(255,255,255)
                            hl.OutlineTransparency = 1
                            hl.Parent = v2
                            table.insert(highlights,hl)
                        end
                    end
                end)
                for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
                    if string.lower(v.Name) == "bed" then
                        for i2,v2 in pairs(v:GetChildren()) do
                            local hl = Instance.new("Highlight")
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Enabled = true
                            hl.FillColor = v.Color
                            hl.FillTransparency = 0
                            hl.OutlineColor = Color3.fromRGB(255,255,255)
                            hl.OutlineTransparency = 1
                            hl.Parent = v2
                            table.insert(highlights,hl)
                        end
                    end
                end
            else
                newbed:Disconnect()
                for i,v in pairs(highlights) do
                    v:Destroy()
                end
                highlights = nil
                highlights = {}
            end
        end
    })
end)

runcode(function()
    local objects = {}
    local connections = {}
    local newconnection
    local Enabled = false
    local function BrickToNew(bname)
        local p = Instance.new("Part")
        p.BrickColor = bname
        local new = p.Color
        p:Destroy()
        return new
    end
    local function TagPart(part,plr)
        local tag = Drawing.new("Text")
        tag.Color = BrickToNew(plr.TeamColor)
        tag.Visible = false
        tag.Text = plr.DisplayName or plr.Name
        tag.Size = 20
        tag.Center = true
        tag.Outline = false
        tag.Font = 1
        table.insert(objects,tag)
        spawn(function()
            repeat
                task.wait()
                local vec,onscreen = cam:worldToViewportPoint(plr.Character:FindFirstChild("Head").Position)
                if onscreen then
                    tag.Visible = true
                    tag.Position = Vector2.new(vec.X,vec.Y+10)
                    tag.Text = (plr.DisplayName or plr.Name).." "..math.floor(plr.Character:FindFirstChild("Humanoid").Health).." HP"
                else
                    tag.Visible = false
                end
            until not tag or not isalive(plr)
            if tag then
                tag:Remove()
                objects[tag] = nil
            end
        end)
    end
    local NameTags = NewFunc["NewElement"]({
        ["Name"] = "NameTags",
        ["Tab"] = HamWare["Tabs"]["Render"],
        ["Callback"] = function(val)
            Enabled = val
            if Enabled then
                for i,plr in pairs(game:GetService("Players"):GetChildren()) do
                    if plr.Name ~= lplr.Name then
                        if isalive(plr) then
                            TagPart(plr.Character:WaitForChild("Head"),plr)
                        end
                        connections[#connections+1] = plr.CharacterAdded:Connect(function(char)
                            task.wait(1)
                            TagPart(char:WaitForChild("Head"),plr)
                        end)
                    end
                end
                newconnection = game:GetService("Players").PlayerAdded:Connect(function(plr)
                    connections[#connections+1] = plr.CharacterAdded:Connect(function(char)
                        task.wait(1)
                        TagPart(char:WaitForChild("Head"),plr)
                    end)
                end)
            else
                newconnection:Disconnect()
                for i,v in pairs(objects) do
                    v:Remove()
                end
                for i,v in pairs(connections) do
                    v:Disconnect()
                end
                objects = nil
                connections = nil
                objects = {}
                connections = {}
            end
        end
    })
end)

runcode(function()
    local BedwarsSwords = require(game:GetService("ReplicatedStorage").TS.games.bedwars["bedwars-swords"]).BedwarsSwords
    function hashFunc(vec) 
        return {value = vec}
    end
    local function GetInventory(plr)
        if not plr then 
            return {items = {}, armor = {}}
        end

        local suc, ret = pcall(function() 
            return require(game:GetService("ReplicatedStorage").TS.inventory["inventory-util"]).InventoryUtil.getInventory(plr)
        end)

        if not suc then 
            return {items = {}, armor = {}}
        end

        if plr.Character and plr.Character:FindFirstChild("InventoryFolder") then 
            local invFolder = plr.Character:FindFirstChild("InventoryFolder").Value
            if not invFolder then return ret end
            for i,v in next, ret do 
                for i2, v2 in next, v do 
                    if typeof(v2) == 'table' and v2.itemType then
                        v2.instance = invFolder:FindFirstChild(v2.itemType)
                    end
                end
                if typeof(v) == 'table' and v.itemType then
                    v.instance = invFolder:FindFirstChild(v.itemType)
                end
            end
        end

        return ret
    end
    local function getSword()
        local highest, returning = -9e9, nil
        for i,v in next, GetInventory(lplr).items do 
            local power = table.find(BedwarsSwords, v.itemType)
            if not power then continue end
            if power > highest then 
                returning = v
                highest = power
            end
        end
        return returning
    end 
    local HitRemote = Client:Get(bedwars["SwordRemote"])--["instance"]
    local Distance = {["Value"] = 18}
    local Enabled = false
    local KillAura = NewFunc["NewElement"]({
        ["Name"] = "KillAura",
        ["Tab"] = HamWare["Tabs"]["Blatant"],
        ["Callback"] = function(val)
            Enabled = val
            if Enabled then
                spawn(function()
                    repeat
                        task.wait(0.12)
                        local nearest = getnearestplayer(Distance["Value"])
                        if nearest ~= nil and nearest.Team ~= lplr.Team and isalive(nearest) and nearest.Character:FindFirstChild("Humanoid").Health > 0.1 and isalive(lplr) and lplr.Character:FindFirstChild("Humanoid").Health > 0.1 and not nearest.Character:FindFirstChild("ForceField") then
                            local sword = getSword()
                            spawn(function()
                                local anim = Instance.new("Animation")
                                anim.AnimationId = "rbxassetid://4947108314"
                                local animator = lplr.Character:FindFirstChild("Humanoid"):FindFirstChild("Animator")
                                animator:LoadAnimation(anim):Play()
                                anim:Destroy()
                                bedwars["ViewmodelController"]:playAnimation(15)
                            end)
                            if sword ~= nil then
                                bedwars["SwordController"].lastAttack = game:GetService("Workspace"):GetServerTimeNow() - 0.11
                                HitRemote:SendToServer({
                                    ["weapon"] = sword.tool,
                                    ["entityInstance"] = nearest.Character,
                                    ["validate"] = {
                                        ["raycast"] = {
                                            ["cameraPosition"] = hashFunc(cam.CFrame.Position),
                                            ["cursorDirection"] = hashFunc(Ray.new(cam.CFrame.Position, nearest.Character:FindFirstChild("HumanoidRootPart").Position).Unit.Direction)
                                        },
                                        ["targetPosition"] = hashFunc(nearest.Character:FindFirstChild("HumanoidRootPart").Position),
                                        ["selfPosition"] = hashFunc(lplr.Character:FindFirstChild("HumanoidRootPart").Position + ((lplr.Character:FindFirstChild("HumanoidRootPart").Position - nearest.Character:FindFirstChild("HumanoidRootPart").Position).magnitude > 14 and (CFrame.lookAt(lplr.Character:FindFirstChild("HumanoidRootPart").Position, nearest.Character:FindFirstChild("HumanoidRootPart").Position).LookVector * 4) or Vector3.new(0, 0, 0)))
                                    },
                                    ["chargedAttack"] = {["chargeRatio"] = 0.8}
                                })
                            end
                        end
                    until not Enabled
                end)
            end
        end
    })
end)

runcode(function()
    local Speed = {["Value"] = 40}
    local Enabled = false
    local Spider = NewFunc["NewElement"]({
        ["Name"] = "Spider",
        ["Tab"] = HamWare["Tabs"]["Blatant"],
        ["Callback"] = function(val)
            Enabled = val
            if Enabled then
                spawn(function()
                    repeat
                        task.wait(0.01)
                        if isalive(lplr) and lplr.Character:FindFirstChild("Humanoid").Health > 0.1 and lplr.Character:FindFirstChild("Humanoid").MoveDirection.Magnitude > 0 then
                            local touching = game:GetService("Workspace"):FindPartOnRay(Ray.new(lplr.Character:FindFirstChild("HumanoidRootPart").Position,lplr.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector),lplr.Character)
                            if touching ~= nil and touching.CanCollide then
                                lplr.Character:FindFirstChild("HumanoidRootPart").Velocity = lplr.Character:FindFirstChild("HumanoidRootPart").Velocity + Vector3.new(0,Speed["Value"],0)
                            end
                        end
                    until not Enabled
                end)
            end
        end
    })
    Spider:NewSlider({
        ["Name"] = "Speed",
        ["Min"] = 0,
        ["Max"] = 100,
        ["Default"] = 40,
        ["Callback"] = function(val)
            Speed["Value"] = val
        end
    })
end)

library:LoadConfiguration()
shared["HamWare"] = HamWare
