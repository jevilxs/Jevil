local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/trinyxScripts/nexus-ui/refs/heads/main/nexuslib.lua"))()
local main = Library:new{
	Name = "Jevilxs (discord: kolivandel)",
	Style = "Bottom",
	Theme = "Dark",
    KeySystem = false
}
local Tab1 = main:CreateTab({Icon = "rbxassetid://83262328821985",Text = "Update"})
local Tab2 = main:CreateTab({Icon = "rbxassetid://83262328821985",Text = "Main"})
local Tab3 = main:CreateTab({Icon = "rbxassetid://83262328821985",Text = "Misc"})
local Tab4 = main:CreateTab({Icon = "rbxassetid://83262328821985",Text = "Teleports"})
local Tab5 = main:CreateTab({Icon = "rbxassetid://83262328821985",Text = "Player"})

local label = Tab1:Label({
	Name = "Изменена GUI"
})
local label = Tab1:Label({
	Name = "Добавлены новые скрипты"
})
local label = Tab1:Label({
	Name = "Добавлены новые функции: GodMode, Noclip, ResetTP ..."
})


local label = Tab2:Label({
	Name = "Тут основные функции"
})

local btn = Tab2:Button({
	Name = "Reset Character", 
	callback = function()

        local player = game.Players.LocalPlayer

        local function killAndRespawn()
            local character = player.Character or player.CharacterAdded:Wait()
            local position = character:GetPrimaryPartCFrame()
            
            character.Humanoid.Health = 0 
            
            local newCharacter = player.CharacterAdded:Wait()
            task.wait(0.1)
            newCharacter:SetPrimaryPartCFrame(position)
        end

        killAndRespawn()

end})


local btn2 = Tab2:Button({
	Name = "GodMode", 
	callback = function()
	

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Функция делает игрока бессмертным
local function makeImmortal()
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.HealthChanged:Connect(function()
                humanoid.Health = humanoid.MaxHealth -- Не даем здоровью упасть
            end)
        end
    end
end


makeImmortal()

		
    end})

	
local btn3 = Tab2:Button({
	Name = "Reset Character", 
	callback = function()

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

local btn4 = Tab2:Button({
	Name = "Сбор монет", 
	callback = function()
		for _, v in pairs(game:GetDescendants()) do
        if v.Name == "CoinMesh" and v:IsA("BasePart") then
            v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            wait(0.01)
        end
		end
		end})
	
end

local btn3 = Tab2:Button({
	Name = "Noclip [Beta]", 
	callback = function()
			
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local noclip = false
local runService = game:GetService("RunService")
local noclipConnection

-- Создаём ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:FindFirstChildOfClass("PlayerGui")

-- Создаём основную кнопку
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 100, 0, 50)
button.Position = UDim2.new(0.5, -50, 0.5, -25)
button.Text = "Noclip"
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = screenGui
button.Draggable = true
button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
button.BackgroundTransparency = 0.7

-- Создаём кнопку закрытия
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = button
closeButton.BackgroundTransparency = 1

-- Функция для переключения noclip
local function toggleNoclip()
    noclip = not noclip
    button.BackgroundColor3 = noclip and Color3.fromRGB(255, 0, 255) or Color3.fromRGB(0, 0, 0)
    
    if noclip then
        noclipConnection = runService.Stepped:Connect(function()
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Подключаем клик по кнопке
button.MouseButton1Click:Connect(toggleNoclip)

-- Закрытие GUI при нажатии на крестик
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

			
end})
local btn5 = Tab2:Button({
	Name = "Chat Spying [Beta]", 
	callback = function()
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
privateProperties.Text = "{JEVIL SPY "..(enabled and "EN" or "DIS").."ABLED}"
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
privateProperties.Text = "{JEVIL SPY "..(enabled and "EN" or "DIS").."ABLED}"
player:WaitForChild("PlayerGui"):WaitForChild("Chat")
StarterGui:SetCore("ChatMakeSystemMessage",privateProperties)
wait(3)
local chatFrame = player.PlayerGui.Chat.Frame
chatFrame.ChatChannelParentFrame.Visible = true
chatFrame.ChatBarParentFrame.Position = chatFrame.ChatChannelParentFrame.Position+UDim2.new(UDim.new(),chatFrame.ChatChannelParentFrame.Size.Y)
end})
