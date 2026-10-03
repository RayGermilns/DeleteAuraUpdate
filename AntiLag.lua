-- CyberHub DeleteAura Made By Cyber
-- Anti Lag Added Because I Promised To Add it
-- Eror Fixed Lol And Uh Faster Deleting :D

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

pcall(function()
	local TextChatService = game:GetService("TextChatService")
	local channels = TextChatService:WaitForChild("TextChannels", 5)
	if channels then
		local general = channels:FindFirstChild("RBXGeneral") or channels:FindFirstChild("General")
		if general then
			general:SendAsync("•| Loading CyberHub... |•")
		end
	end
end)

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
	Name = "CyberHub | Delete Aura (Fixed)",
	HidePremium = false,
	SaveConfig = false,
	ConfigFolder = "CyberHubDeleteAura"
})

local MainTab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local DeleteAuraTab = Window:MakeTab({
	Name = "Delete Aura",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

MainTab:AddSection({Name = "Profile"}):AddParagraph(
	"User Info: " .. LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")",
	"User ID: " .. LocalPlayer.UserId .. "\nAccount Age: " .. LocalPlayer.AccountAge .. " days"
)

local Settings = {
	Enabled = false,
	AntiLag = true,
	Range = 100000,
	Delay = 0.01,
	MaxPerCycle = 25
}

local function GetBricks()
	local bricks = {}
	local brickFolder = workspace:FindFirstChild("Bricks")
	if not brickFolder then return bricks end

	for _, model in ipairs(brickFolder:GetChildren()) do
		for _, brick in ipairs(model:GetChildren()) do
			if brick:IsA("BasePart") then
				table.insert(bricks, brick)
			end
		end
	end
	return bricks
end

local function GetDeleteTool()
	local char = LocalPlayer.Character
	local backpack = LocalPlayer:FindFirstChild("Backpack")

	if char then
		local tool = char:FindFirstChild("Delete")
		if tool and tool:IsA("Tool") then
			return tool
		end
	end
	if backpack then
		local tool = backpack:FindFirstChild("Delete")
		if tool and tool:IsA("Tool") then
			return tool
		end
	end
	return nil
end

local function SafeEquipDelete(tool)
	if not tool or not tool.Parent then return end
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not char or not hum then return end

	pcall(function()
		if tool.Parent ~= hum then
			tool.Parent = char
			task.wait()
			if tool and tool.Parent then
				tool.Parent = hum
			end
		end
	end)
end

task.spawn(function()
	while true do
		if Settings.Enabled then
			local char = LocalPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")

			if root and hum then
				local deleteTool = GetDeleteTool()

				if deleteTool then
					SafeEquipDelete(deleteTool)

					local event = deleteTool:FindFirstChild("Script") and deleteTool.Script:FindFirstChild("Event")

					if event then
						local deletedThisCycle = 0
						local bricks = GetBricks()

						for _, brick in ipairs(bricks) do
							if not Settings.Enabled then break end

							-- Anti Lag limit
							if Settings.AntiLag and deletedThisCycle >= Settings.MaxPerCycle then
								break
							end

							if brick and brick.Parent and brick:IsA("BasePart") then
								local dist = (root.Position - brick.Position).Magnitude
								if dist <= Settings.Range then
									pcall(function()
										event:FireServer(brick, brick.Position)
									end)
									deletedThisCycle = deletedThisCycle + 1
									task.wait(Settings.Delay)
								end
							end
						end
					end
				end
			end
		end
		task.wait(Settings.AntiLag and 0.08 or 0.05)
	end
end)

-- Toggles
DeleteAuraTab:AddToggle({
	Name = "Delete Aura OG + XL",
	Default = false,
	Callback = function(Value)
		Settings.Enabled = Value
		OrionLib:MakeNotification({
			Name = "Delete Aura",
			Content = Value and "Enabled" or "Disabled",
			Image = "rbxassetid://4483345998",
			Time = 3
		})
	end
})

DeleteAuraTab:AddToggle({
	Name = "Anti Lag",
	Default = true,
	Callback = function(Value)
		Settings.AntiLag = Value
		OrionLib:MakeNotification({
			Name = "Anti Lag",
			Content = Value and "Enabled" or "Disabled",
			Image = "rbxassetid://4483345998",
			Time = 3
		})
	end
})

OrionLib:MakeNotification({
	Name = "CyberHub",
	Content = "The Chosen One",
	Image = "rbxassetid://4483345998",
	Time = 4
})

OrionLib:Init()
