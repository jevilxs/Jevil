local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Govnocode ",
    SubTitle = "by Jevilxs",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl 
})


local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "rbxassetid://10709807111" }),
	Misc = Window:AddTab({ Title = "Misc", Icon = "rbxassetid://10734963400" }),
	Basic = Window:AddTab({ Title = "Player", Icon = "rbxassetid://10747372167" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Tabs.Main:AddParagraph({
        Title = "Main scripts",
        Content = "Тут находятся основные скрипты."
    })



    Tabs.Main:AddButton({
        Title = "AntiRagdoll",
        Description = "Выключает ragdoll.",
        Callback = function()
game:GetService("ReplicatedStorage").LocalRagdollEvent:Destroy()
local player = game.Players.LocalPlayer

local function killCharacter()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Health = 0
        print("Персонаж убит.")
    else
        print("Humanoid не найден.")
    end
end

-- Если персонаж уже загружен, убить его сразу
if player.Character then
    killCharacter()
end
end
    })

Tabs.Main:AddButton({
        Title = "Сбор монет",
        Description = "Собирает китайские монеты.",
        Callback = function()
		for _, v in pairs(game:GetDescendants()) do
        if v.Name == "CoinMesh" and v:IsA("BasePart") then
            v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            wait(0.1)
        end
		end
		end})
end



Tabs.Main:AddButton({
        Title = "Chat spying",
        Description = "Включает spying чата.",
        Callback = function()
enabled = true
--if true will xhexk your messages too
spyOnMyself = true
--if true will xhat the logs publikly (fun, risky)
public = false
--if true will use /me to stand out
publicItalics = false
--KUSTOMIZE private logs
privateProperties = {
Color = Color3.fromRGB(0,255,255); 
Font = Enum.Font.SourceSansBold;
TextSize = 18;
}
--////////////////////////////////////////////////////////////////
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() or Players.LocalPlayer
local saymsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
local getmsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")
local instance = (_G.chatSpyInstance or 0) + 1
_G.chatSpyInstance = instance

local function onChatted(p,msg)
if _G.chatSpyInstance == instance then
if p==player and msg:lower():sub(1,6)==".lu" then
enabled = not enabled
wait(0.3)
privateProperties.Text = "{LOLLYPOP SPY "..(enabled and "EN" or "DIS").."ABLED}"
StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
elseif enabled and (spyOnMyself==true or p~=player) then
msg = msg:gsub("[\n\r]",''):gsub("\t",' '):gsub("[ ]+",' ')
local hidden = true
local conn = getmsg.OnClientEvent:Connect(function(packet,channel)
if packet.SpeakerUserId==p.UserId and packet.Message==msg:sub(#msg-#packet.Message+1) and (channel=="All" or (channel=="Team" and public==false and p.Team==player.Team)) then
hidden = false
end
end)
wait(1)
conn:Disconnect()
if hidden and enabled then
if public then
saymsg:FireServer((publicItalics and "/me " or '').."{SPY} [".. p.Name .."]: "..msg,"All")
else
privateProperties.Text = "{SPY} [".. p.Name .."]: "..msg
StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
end
end
end
end
end

for _,p in ipairs(Players:GetPlayers()) do
p.Chatted:Connect(function(msg) onChatted(p,msg) end)
end
Players.PlayerAdded:Connect(function(p)
p.Chatted:Connect(function(msg) onChatted(p,msg) end)
end)
privateProperties.Text = "{LOLLYPOP SPY "..(enabled and "EN" or "DIS").."ABLED}"
player:WaitForChild("PlayerGui"):WaitForChild("Chat")
StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
wait(3)
local chatFrame = player.PlayerGui.Chat.Frame
chatFrame.ChatChannelParentFrame.Visible = true
chatFrame.ChatBarParentFrame.Position = chatFrame.ChatChannelParentFrame.Position+UDim2.new(UDim.new(),chatFrame.ChatChannelParentFrame.Size.Y)
end})


Tabs.Misc:AddParagraph({
        Title = "Misc scripts",
        Content = "Тут находятся дополнительные скрипты."
    })

local Slider = Tabs.Basic:AddSlider("Slider", {
        Title = "Speed",
        Description = "Меняет скорость игрока.",
        Default = 16,
        Min = 0,
        Max = 300,
        Rounding = 1,
        Callback = function(Value)
            print("Slider was changed:", Value)
        end
    })

    Slider:OnChanged(function(Value)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
local newSpeed = Value
if humanoid then
    humanoid.WalkSpeed = newSpeed
end

end)
Slider:SetValue(16)


 local Slider = Tabs.Basic:AddSlider("Slider", {
        Title = "Gravity",
        Description = "Меняет гравитацию игрока.",
        Default = 196.2,
        Min = 0,
        Max = 196.2,
        Rounding = 1,
        Callback = function(Value)
            print("Slider was changed:", Value)
        end
    })

    Slider:OnChanged(function(Value)
        local newGravity = Value -- Установите нужное значение гравитации (по умолчанию 196.2)

game.Workspace.Gravity = newGravity
    end)

    Slider:SetValue(196.2)

    local Slider = Tabs.Basic:AddSlider("Slider", {
        Title = "Jump Power",
        Description = "Меняет силу прыжка игрока.",
        Default = 50,
        Min = 0,
        Max = 350,
        Rounding = 1,
        Callback = function(Value)
            print("Slider was changed:", Value)
        end
    })

    Slider:OnChanged(function(Value)
        local newJumpPower = Value 

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")

if humanoid then
    humanoid.UseJumpPower = true
    humanoid.JumpPower = newJumpPower
    
end
    end)

    Slider:SetValue(50)


local Dropdown = Tabs.Basic:AddDropdown("Dropdown", {
    Title = "Gravity presets",
    Values = {"Default gravity", "Low gravity"},
    Multi = false,
    Default = 1,
})

Dropdown:SetValue("Default gravity")

Dropdown:OnChanged(function(Value)
    print("Dropdown changed:", Value)

    if Value == "Default gravity" then
        local newGravity = 196.2
game.Workspace.Gravity = newGravity
		local newJumpPower = 50 
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
    humanoid.UseJumpPower = true
    humanoid.JumpPower = newJumpPower
end
    elseif Value == "Low gravity" then
        local newGravity = 47.7
game.Workspace.Gravity = newGravity
		local newJumpPower = 48.8 
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
    humanoid.UseJumpPower = true
    humanoid.JumpPower = newJumpPower
end
    end
end)




Tabs.Misc:AddButton({
        Title = "Jerk off",
        Description = "",
        Callback = function()
loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
end})

Tabs.Main:AddButton({
        Title = "Infinite Yield",
        Description = "Включает Infinite Yield",
        Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end})

Tabs.Misc:AddButton({
        Title = "Orca hub",
        Description = "",
        Callback = function()
loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua'))()
end})

Tabs.Misc:AddButton({
        Title = "Emotes",
        Description = "",
        Callback = function()
loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Gi7331/scripts/main/Emote.lua"))()
end})

Tabs.Misc:AddButton({
        Title = "Canon",
        Description = "",
        Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Cannon%20Ball'))()
end})

Tabs.Misc:AddButton({
        Title = "Eazvy hub",
        Description = "",
        Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Eazvy/public-scripts/main/Universal_Animations_Emotes.lua"))()
end})

Tabs.Misc:AddButton({
        Title = "System Broken",
        Description = "",
        Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/script"))()
end})

Tabs.Misc:AddButton({
        Title = "Nitrogen",
        Description = "Password - nitrogencomingback",
        Callback = function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/nitrogenhbexp/beta-script/refs/heads/main/script'),true))()
end})



-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Govnocode by Jevilxs",
    Content = "Скрипт полностью загрузился, удачного пользования!",
    Duration = 10
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
