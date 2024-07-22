--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Skibid Hook Sigma",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest"
})

local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local addCashRemote = ReplicatedStorage.Remotes.AddCash
local saveMaxAuraRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SaveMaxAura")
local auraEquipRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("AuraEquip")

local spamming = false

local function spamSaveMaxAura()
    local args = { [1] = 0 }
    while spamming do
        saveMaxAuraRemote:FireServer(unpack(args))
        task.wait()
    end
end

Tab:AddToggle({
    Name = "Buy Inventory Slots For Free",
    Default = false,
    Callback = function(Value)
        spamming = Value
        if spamming then
            task.spawn(spamSaveMaxAura)
        end
    end
})

local aurasOwned = game:GetService("Players").LocalPlayer:WaitForChild("AurasOwned"):GetChildren()
local auraNames = {}

for _, aura in ipairs(aurasOwned) do
    table.insert(auraNames, aura.Name)
end

Tab:AddDropdown({
    Name = "Select Aura",
    Default = auraNames,
    Options = auraNames,
    Callback = function(Value)
        local args = {
            [1] = ReplicatedStorage:WaitForChild("old"):WaitForChild("old"):WaitForChild(Value),
            [2] = false
        }
        auraEquipRemote:FireServer(unpack(args))
    end
})

Tab:AddToggle({
    Name = "Unlock Everything in Collection Client Side",
    Default = false,
    Callback = function(Value)
        for _, aura in ipairs(aurasOwned) do
            if aura:IsA("BoolValue") then
                aura.Value = Value
            end
        end
    end
})
