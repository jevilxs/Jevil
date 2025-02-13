local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/trinyxScripts/nexus-ui/refs/heads/main/nexuslib.lua"))()
local main = Library:new{
	Name = "Jevilxs (discord: kolivandel)",
	Style = "Flex",
	Theme = "Dark",
    KeySystem = false
}
local Tab1 = main:CreateTab({Icon = "rbxassetid://83262328821985",Text = "Update"})
local Tab2 = main:CreateTab({Icon = "rbxassetid://10709752035",Text = "Main"})
local Tab3 = main:CreateTab({Icon = "rbxassetid://10734963400",Text = "Misc"})
local Tab4 = main:CreateTab({Icon = "rbxassetid://10747372167",Text = "Teleports"})
local Tab5 = main:CreateTab({Icon = "rbxassetid://10709807111",Text = "Player"})

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


local btntwo = Tab2:Button({
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

local btnthree = Tab2:Button({
	Name = "AntiRagdoll", 
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
			
end})

local btnfour = Tab2:Button({
	Name = "Сбор монет", 
	callback = function()

for _, v in pairs(game:GetDescendants()) do
        if v.Name == "CoinMesh" and v:IsA("BasePart") then
            v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            wait(0.1)
        end
        end
			
end})


local btnfive = Tab2:Button({
	Name = "Chat Spying", 
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
	





local btntabone = Tab3:Button({
	Name = "JerkOf", 
	callback = function()

loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
			
end})
			
local btntabtwo = Tab3:Button({
	Name = "Infinite Yield", 
	callback = function()
			
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
			
end})

local btntabthree = Tab3:Button({
	Name = "Orca hub", 
	callback = function()
			
loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua'))()
			
end})	

local btntabfour = Tab3:Button({
	Name = "Emotes", 
	callback = function()
			
loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Gi7331/scripts/main/Emote.lua"))()
			
end})	

local btntabfive = Tab3:Button({
	Name = "Canon", 
	callback = function()
			
loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Cannon%20Ball'))()
			
end})
												
local btntabsix = Tab3:Button({
	Name = "Eazvy hub", 
	callback = function()
			
loadstring(game:HttpGet("https://raw.githubusercontent.com/Eazvy/public-scripts/main/Universal_Animations_Emotes.lua"))()
			
end})		

local btntabseven = Tab3:Button({
	Name = "System Broken", 
	callback = function()
			
loadstring(game:HttpGet("https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/script"))()
			
end})
																		
local btntabeight = Tab3:Button({
	Name = "Nitrogen", 
	callback = function()
			
loadstring(game:HttpGet(('https://raw.githubusercontent.com/nitrogenhbexp/beta-script/refs/heads/main/script'),true))()
			
end})


local labeltab4 = Tab4:Label({
	Name = "Раздел с телепортами"
})

local otab4 = Tab4:Button({
	Name = "Спавн РГЧ", 
	callback = function()
	local targetObject = workspace:GetChildren()[90]
	if targetObject then
	    local player = game.Players.LocalPlayer
	    local targetPosition = targetObject.Position + Vector3.new(0, 5, 0)  
	    player.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
	end			
end})	

local ttab4 = Tab4:Button({
	Name = "Вип комната", 
	callback = function()
	local targetObject = workspace.VIP:GetChildren()[14]:GetChildren()[2]:GetChildren()[2]:GetChildren()[16]
	if targetObject then
	    local player = game.Players.LocalPlayer
	    local targetPosition = targetObject.Position + Vector3.new(0, 5, 0)  
	    player.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
	end		
end})	

local thtab4 = Tab4:Button({
	Name = "Розовая комната", 
	callback = function()
	local targetObject = workspace.map:GetChildren()[63].Bed.BedFrame:GetChildren()[2]
	if targetObject then
	    local player = game.Players.LocalPlayer
	    local targetPosition = targetObject.Position + Vector3.new(0, 5, 0)  
	    player.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
	end			
end})	

local ftab4 = Tab4:Button({
	Name = "Лестница", 
	callback = function()
	local targetObject = workspace.map:GetChildren()[175]
	if targetObject then
	    local player = game.Players.LocalPlayer
	    local targetPosition = targetObject.Position + Vector3.new(0, 5, 0)  
	    player.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
	end			
end})	

local SliderTab5 = Tab5:Slider({
         Name = "Speed",
         min = 0,
         max = 200,
         Default = 16,
         callback = function(v)
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local newSpeed = v
		if humanoid then
		    humanoid.WalkSpeed = newSpeed
		end
end})
