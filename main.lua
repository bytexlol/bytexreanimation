local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bytexlol/bytexreanimation/refs/heads/main/lib.lua"))()

local bytexgui = Library:create{
    Theme = Library.Themes.Dark
}

local Bytex_R6FlingPart = "Left Leg"
local Bytex_R15FlingPart = "LeftFoot"
local Bytex_R6FakeLimb = 63690008
local Bytex_GiveHatPrefix = "-gh"
local Bytex_Permadeath = false
local Bytex_UseHats = true

Bytex_R6FakeLimb = game:GetObjects("rbxassetid://"..tostring(Bytex_R6FakeLimb))[1].Name

function Reanimate(BytexConvert_HatID, BytexConvert_HatCFrame, BytexConvert_HatLimbWeld)
local Global = (getgenv and getgenv()) or shared
            Global.GelatekReanimateConfig = {
            -- [[ Rig Settings ]] --
            ["AnimationsDisabled"] = false,
            ["R15ToR6"] = true,
            ["DontBreakHairWelds"] = false,
            ["PermanentDeath"] = Bytex_Permadeath,
            ["Headless"] = false,
            ["TeleportBackWhenVoided"] = false,
            
            -- [[ Reanimation Settings ]] --
            ["AlignReanimate"] = false,
            ["FullForceAlign"] = false,
            ["FasterHeartbeat"] = true,
            ["DynamicalVelocity"] = false,
            ["DisableTweaks"] = false,
            
            -- [[ Optimization ]] --
            ["OptimizeGame"] = false,

            -- [[ Miscellacious ]] --
            ["LoadLibrary"] = false,
            ["DetailedCredits"] = false,
            
            -- [[ Flinging Methods ]] --
            ["TorsoFling"] = false,
            ["R6FlingPart"] = Bytex_R6FlingPart,
            ["R15FlingPart"] = Bytex_R15FlingPart,
	        ["R6FakeLimb"] = Bytex_R6FakeLimb,
            ["BulletEnabled"] = true,
            ["BulletConfig"] = {
                ["RunAfterReanimate"] = true,
                ["LockBulletOnTorso"] = true
            }
        }
        if Bytex_UseHats then
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            local Character = player.Character

            function sendMessage(message)
                if game:GetService("TextChatService") then
                    game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(message)
                elseif ChatService then
                    game:GetService("Chat"):Chat(Character, message)
                end
            end

            local HAT_NAME = game:GetObjects("rbxassetid://"..tostring(BytexConvert_HatID))[1].Name
            local accessory = Character:FindFirstChild(HAT_NAME)
            if not accessory then
                bytexgui:Notification{
                    Title = "Error!",
                    Text = "You didn't have the hat equipped!, Run script again.",
                    Duration = 5,
                }
                wait()
                sendMessage("/e "..Bytex_GiveHatPrefix.." "..tostring(BytexConvert_HatID))
                return
            end
        end

        loadstring(game:HttpGet("https://raw.githubusercontent.com/bytexlol/bytexreanimation/refs/heads/main/reanimate.lua"))()
        
        wait(0.5)
        if Bytex_UseHats then
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local Character = player.Character

        local RightArm = Character:WaitForChild(BytexConvert_HatLimbWeld)

        local HAT_NAME = game:GetObjects("rbxassetid://"..tostring(BytexConvert_HatID))[1].Name
        local accessory = Character:FindFirstChild(HAT_NAME)

        local handle = accessory:FindFirstChild("Handle")

        for _, v in ipairs(handle:GetChildren()) do
            if v:IsA("Weld") or v:IsA("Motor6D") or v:IsA("WeldConstraint") --[[or v:IsA("Mesh") or v:IsA("SpecialMesh")]] then
                v:Destroy()
            end
        end

        local grip = Instance.new("Part")
        grip.Name = "AccessoryGrip"
        grip.Size = Vector3.new(0.2, 0.2, 0.2)
        grip.Transparency = 1
        grip.CanCollide = false
        grip.Anchored = false
        grip.Parent = Character

        local gripWeld = Instance.new("Motor6D")
        gripWeld.Name = "GripWeld"
        gripWeld.Part0 = RightArm
        gripWeld.Part1 = grip
        gripWeld.C0 = BytexConvert_HatCFrame
        gripWeld.Parent = grip

        local alignPos = Instance.new("AlignPosition")
        alignPos.Attachment0 = Instance.new("Attachment", handle)
        alignPos.Attachment1 = Instance.new("Attachment", grip)
        alignPos.RigidityEnabled = false
        alignPos.Responsiveness = 200
        alignPos.MaxForce = 100000
        alignPos.Parent = handle

        local alignOri = Instance.new("AlignOrientation")
        alignOri.Attachment0 = alignPos.Attachment0
        alignOri.Attachment1 = alignPos.Attachment1
        alignOri.MaxTorque = 100000
        alignOri.Responsiveness = 200
        alignOri.Parent = handle

        handle.Parent = workspace
        task.wait()
        handle.Parent = accessory

        bytexgui:Notification{
            Title = "Success!",
            Text = "Player reanimated successfully.",
            Duration = 5,
        }
        end
end

function runScript(scr)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/bytexlol/bytexreanimation/refs/heads/main/scripts/"..scr..".lua"))()
end

local reanim = bytexgui:tab{
    Icon = "rbxassetid://92920576968733",
    Name = "Reanimation"
}

local scr = bytexgui:tab{
    Icon = "rbxassetid://4227397352",
    Name = "Scripts"
}

reanim:button({
    Name = "Respawn",
    Desc = "Press twice",
    Callback = function()
        player = game.Players.LocalPlayer
        local character = player.Character
        character:BreakJoints()
        character:WaitForChild("Humanoid"):Destroy()
        character:WaitForChild("Head"):Destroy()
        character:WaitForChild("Torso"):Destroy()
        player.CharacterAdded:Wait()
        character:WaitForChild("Humanoid"):Destroy()
    end,
})

reanim:Toggle{
	Name = "Permadeath",
	StartingState = false,
	Description = nil,
	Callback = function(state) Bytex_Permadeath = state return Bytex_Permadeath end
}

reanim:Toggle{
	Name = "Use Hats",
	StartingState = true,
	Description = nil,
	Callback = function(state) Bytex_UseHats = state return Bytex_UseHats end
}

reanim:dropdown({
    Name = "Fling Part (R15)",
    Description = "Sets the R15 fling part.",
    StartingText = "RightHand",
    Items = {
        "RightHand",
        "LeftHand",
        "RightFoot",
        "LeftFoot",
        "RightUpperArm",
        "LeftUpperArm",
        "RightLowerArm",
        "LeftLowerArm",
        "RightLowerLeg",
        "LeftLowerLeg",
        "RightUpperLeg",
        "LeftUpperLeg",
    },
    Callback = function(item) Bytex_R15FlingPart = item return Bytex_R15FlingPart end
})

reanim:dropdown({
    Name = "Fling Part (R6)",
    Description = "Sets the R6 fling part.",
    StartingText = "Left Leg",
    Items = {
        "Left Leg",
        "Right Leg",
        "Left Arm",
        "Right Arm",
    },
    Callback = function(item) Bytex_R6FlingPart = item return Bytex_R6FlingPart end
})

reanim:textbox({
    Name = "R6 Fake Limb Hat ID (Default = 63690008)",
    Callback = function(item) Bytex_R6FakeLimb = game:GetObjects("rbxassetid://"..tostring(item))[1].Name return Bytex_R6FakeLimb end
})

reanim:textbox({
    Name = "Give Hat Prefix (Default = -gh)",
    Callback = function(item) Bytex_GiveHatPrefix = item return Bytex_GiveHatPrefix end
})

scr:button({
    Name = "Sniper",
    Callback = function()
        local BytexConvert_HatID = 80504366986388
        local BytexConvert_HatCFrame = CFrame.new(0, -1.5, -0.6) * CFrame.Angles(math.rad(-90), math.rad(90) , 0)
        local BytexConvert_HatLimbWeld = "Right Arm"

        Reanimate(BytexConvert_HatID, BytexConvert_HatCFrame, BytexConvert_HatLimbWeld)
        runScript('sniper')
    end,
})

scr:button({
    Name = "Elio Blasio",
    Callback = function()
        local BytexConvert_HatID = 4933294084
        local BytexConvert_HatCFrame = CFrame.new(0, -1.2, -0.6) * CFrame.Angles(math.rad(-40), math.rad(-90) , 0)
        local BytexConvert_HatLimbWeld = "Right Arm"

        Reanimate(BytexConvert_HatID, BytexConvert_HatCFrame, BytexConvert_HatLimbWeld)
        runScript('elioblasio')
    end,
})

scr:button({
    Name = "Trap Rifle",
    Callback = function()
        local BytexConvert_HatID = 4933294084
        local BytexConvert_HatCFrame = CFrame.new(0, -1.2, -0.6) * CFrame.Angles(math.rad(-40), math.rad(-90) , 0)
        local BytexConvert_HatLimbWeld = "Right Arm"

        Reanimate(BytexConvert_HatID, BytexConvert_HatCFrame, BytexConvert_HatLimbWeld)
        runScript('traprifle')
    end,
})

scr:button({
    Name = "Minigun",
    Callback = function()
        local BytexConvert_HatID = 18577802391
        local BytexConvert_HatCFrame = CFrame.new(0.4, -1.2, -1) * CFrame.Angles(math.rad(50), math.rad(90) , 0)
        local BytexConvert_HatLimbWeld = "Right Arm"

        Reanimate(BytexConvert_HatID, BytexConvert_HatCFrame, BytexConvert_HatLimbWeld)
        runScript('minigun')
    end,
})

scr:button({
    Name = "Shotgun",
    Callback = function()
        local BytexConvert_HatID = 76734658816459
        local BytexConvert_HatCFrame = CFrame.new(0, -1.2, -0.6) * CFrame.Angles(math.rad(-90), math.rad(180) , 0)
        local BytexConvert_HatLimbWeld = "Right Arm"

        Reanimate(BytexConvert_HatID, BytexConvert_HatCFrame, BytexConvert_HatLimbWeld)
        runScript('shotgun')
    end,
})

bytexgui:Notification{
    Title = "Welcome to Bytex!",
    Text = "Scripts and customization converted/made by 2faint. Reanimation made by Gelatek",
    Duration = 5,
}

wait(1)

if game.GameId ~= 6016588693 then
    bytexgui:Prompt{
        Followup = false,
        Title = "Warning",
        Text = "This script may not work in this game. Click OK if you want to be teleported into Just a baseplate",
        Buttons = {
            ok = function()
                game:GetService("TeleportService"):Teleport(17574618959, game.Players.LocalPlayer)
            end,
            cancel = function()
                
            end
        }
    }
end
