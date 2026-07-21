--[[
  redz hub Universal Open Source
  by plock4444
]]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/PlockScripts/Library-ui/refs/heads/main/Redzhubui"))()

local Window = Library:MakeWindow({
    Title = "redz Hub : Universal",
    SubTitle = "by real_redz",
    SaveFolder = "Redz | redz lib v5.lua"
})

Window:AddMinimizeButton({
    Button = {
        Image = "rbxassetid://15298567397",
        BackgroundTransparency = 0
    },
    Size = UDim2.new(0, 35, 0, 35),
    Corner = {
        CornerRadius = UDim.new(0, 6)
    },
})
local Esp = Window:MakeTab({"ESP", "User"})
local Misc = Window:MakeTab({"Misc", "Settings"})
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Noclip = false
local vu32 = (getgenv or getrenv or getfenv)()
local _ENV = (getgenv or getrenv or getfenv)()
local vu6 = game:GetService("VirtualUser")
local Settings = _ENV.rz_settings or {
    SmoothMode = false
}


local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");

local CoreGui = (gethui and gethui()) or game:GetService("CoreGui");

local Player = Players.LocalPlayer;

local function DistanceFromMyCharacter(Position)
local Character = Player.Character

if not Character or not Character.PrimaryPart then  
	return math.huge  
end  
  
local TargetPosition  
  
if typeof(Position) == "Instance" then  
	if Position:IsA("BasePart") then  
		TargetPosition = Position.Position  
	elseif Position:IsA("Model") and Position.PrimaryPart then  
		TargetPosition = Position.PrimaryPart.Position  
	else  
		return math.huge  
	end  
elseif typeof(Position) == "Vector3" then  
	TargetPosition = Position  
else  
	return math.huge  
end  
  
return (Character.PrimaryPart.Position - TargetPosition).Magnitude
end
     local Managers = {} do
     Managers.EspManager = (function()
     local EspManager = {}
          EspManager.__index = EspManager
          EspManager.__newindex = function(self, index, value)
if index == "Enabled" then
task.spawn(self.ToggleEsp, self, value)
else
rawset(self, index, value)
end
end

local CoreGuiEspFolder = Instance.new("Folder", CoreGui) do  
		CoreGuiEspFolder.Name = "redzHub-EspFolder"  
		  
		local _EspFolder = CoreGui:FindFirstChild(CoreGuiEspFolder.Name)  
		  
		if _EspFolder and _EspFolder ~= CoreGuiEspFolder then  
			_EspFolder:Destroy()  
		end  
	end  
	  
	local EspTemplate = Instance.new("BoxHandleAdornment") do  
		local BoxHandleAdornment = EspTemplate  
		BoxHandleAdornment.Size = Vector3.new(1, 0, 1, 0)  
		BoxHandleAdornment.AlwaysOnTop = true  
		BoxHandleAdornment.ZIndex = 10  
		BoxHandleAdornment.Transparency = 0  
		  
		local BillboardGui = Instance.new("BillboardGui", BoxHandleAdornment)  
		BillboardGui.Size = UDim2.new(0, 100, 0, 150)  
		BillboardGui.StudsOffset = Vector3.new(0, 2, 0)  
		BillboardGui.AlwaysOnTop = true  
		  
		local TextLabel = Instance.new("TextLabel", BillboardGui)  
		TextLabel.BackgroundTransparency = 1  
		TextLabel.Position = UDim2.new(0, 0, 0, -50)  
		TextLabel.Size = UDim2.new(0, 100, 0, 100)  
		TextLabel.TextSize = 10  
		TextLabel.TextStrokeTransparency = 0  
		TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom  
		TextLabel.Text = "..."  
		TextLabel.ZIndex = 15  
		TextLabel.RichText = true  
	end  
	  
	local DefaultEspColor = Color3.fromRGB(255, 255, 255)  
	local HumHealth = "%s<font color='rgb(160, 160, 160)'> [ %im ]</font>\n<font color='rgb(25, 240, 25)'>[%i/%i]</font>"  
	local CreatedEsps = {}  
    EspManager.CreatedEsps = CreatedEsps  
	local function GetBasePart(Instance)  
		if Instance:IsA("BasePart") then  
			return Instance  
		elseif Instance:IsA("Model") then  
			return Instance.PrimaryPart or Instance:GetPivot()  
		elseif Instance.Parent:IsA("Model") then  
			return Instance.Parent.PrimaryPart or Instance.Parent:GetPivot()  
		end  
	end  
	  
	function EspManager:SetCustomEspDisplay(Action)  
		self.CustomEspDisplay = Action  
		return self  
	end  
	  
	function EspManager:SetObjects(Objects)  
		self.GetObjectsAction = Objects  
		return self  
	end  
	  
	function EspManager:GetInstance(Action)  
		self.OnlyOneInstanceAction = Action  
		return self  
	end  
	  
	function EspManager:SetInstanceName(Instance, Name)  
		self.EspsNames[Instance] = Name  
		return self  
	end  
	  
	function EspManager:SetAllInstancesName(Name)  
		self.CustomInstanceName = Name  
		return self  
	end  
	  
	function EspManager:WaitChildsAdded()  
		self._WaitChildsAdded = true  
		return self  
	end  
	  
	function EspManager:SetEspColor(Action)  
		self.EspColor = Action  
		return self  
	end  
	  
	function EspManager:SetAlwaysValidate()  
		self.AlwaysValidateInstance = true  
		return self  
	end  
	  
	function EspManager:Validator(Action)  
		self.ValidateInstance = Action  
		return self  
	end  
	  
	function EspManager:ChangeEspSize(Size)  
		self.EspSize = Size  
		  
		for i = 1, #CreatedEsps do  
			for _, Esp in pairs(CreatedEsps[i].EspObjects) do  
				Esp.BoxHandleAdornment.BillboardGui.TextLabel.TextSize = Size  
			end  
		end  
		  
		return self  
	end  
	  
	function EspManager:StartRunningEsp(Esp)  
		local Instance = Esp.Instance  
		local BoxHandleAdornment = Esp.BoxHandleAdornment  
		local TextLabel = BoxHandleAdornment.BillboardGui.TextLabel  
		local Folder = self.EspFolder  
		local IsModel = Instance:IsA("Model")  
		local CachedBasePart = nil  
		  
		while task.wait(Settings.SmoothMode and 0.25 or 0) do  
			if not BoxHandleAdornment or not BoxHandleAdornment.Parent then  
				return self:Clear(Esp)  
			elseif self.AlwaysValidateInstance and not self.ValidateInstance(Instance) then  
				return self:Clear(Esp)  
			elseif not Instance:IsDescendantOf(workspace) and not Instance:IsDescendantOf(ReplicatedStorage) then  
				return self:Clear(Esp)  
			end  
			  
			CachedBasePart = CachedBasePart or GetBasePart(Instance)  
			  
			if not CachedBasePart then  
				return self:Clear(Esp)  
			end  
			  
			local Distance = math.floor((DistanceFromMyCharacter(CachedBasePart)) / 5)  
			local Humanoid = IsModel and Instance:FindFirstChildOfClass("Humanoid")  
			  
			if Humanoid then  
				TextLabel.Text = HumHealth:format(Instance.Name, Distance, math.floor(Humanoid.Health), math.floor(Humanoid.MaxHealth))  
			elseif self.CustomEspDisplay then  
				TextLabel.Text = self.CustomEspDisplay(Instance, Distance)  
			else  
				local Name = self.CustomInstanceName or self.EspsNames[Instance] or Instance.Name  
				TextLabel.Text = ("%s < %i >"):format(Name, Distance)  
			end  
		end  
	end  
	  
	function EspManager:Create(Instance)  
		if self.EspObjects[Instance] then return end  
		  
		local Esp = {  
			Instance = Instance,  
			BoxHandleAdornment = nil  
		}  
		  
		local BoxHandleAdornment = EspTemplate:Clone()  
		local BillboardGui = BoxHandleAdornment.BillboardGui  
		local TextLabel = BillboardGui.TextLabel  
		  
		BillboardGui.Adornee = (Instance:IsA("BasePart") or Instance:IsA("Model")) and Instance or Instance.Parent  
		TextLabel.TextColor3 = type(self.EspColor) == "function" and self.EspColor(Instance) or self.EspColor or DefaultEspColor  
		TextLabel.Text = self.CustomInstanceName or "..."  
		TextLabel.TextSize = self.EspSize or TextLabel.TextSize  
		BoxHandleAdornment.Parent = self.EspFolder  
		  
		self.EspObjects[Instance] = Esp  
		Esp.BoxHandleAdornment = BoxHandleAdornment  
		  
		task.spawn(self.StartRunningEsp, self, Esp)  
		  
		return Esp  
	end  
	  
	function EspManager:Clear(Esp)  
		if Esp then  
			self.EspObjects[Esp.Instance] = nil  
			if Esp.BoxHandleAdornment then Esp.BoxHandleAdornment:Destroy() end  
		else  
			table.clear(self.EspObjects)  
			self.EspFolder:ClearAllChildren()  
		end  
	end  
	  
	function EspManager:ToggleEsp(Value)  
		local Environment = "redzHub_Esp_" .. self.SpecialTag  
		_ENV[Environment] = Value  
  
		if not Value then  
			return self:Clear()  
		end  
  
		while _ENV[Environment] do  
			local ObjectsAction = self.GetObjectsAction  
	  
			if self.OnlyOneInstanceAction then  
				local Instance = self.OnlyOneInstanceAction()  
		  
				if Instance then  
					self:Create(Instance)  
				end  
		  
			elseif ObjectsAction then  
				local Instances  
		  
				if typeof(ObjectsAction) == "function" then
					Instances = ObjectsAction()
				elseif typeof(ObjectsAction) == "Instance" then
					Instances = ObjectsAction:GetChildren()
				else
					Instances = ObjectsAction
					end

				if type(Instances) ~= "table" then
					Instances = {}
				end
		  
				local Validate = self.ValidateInstance  
				local CreatedEsps = self.EspObjects  
				local CreatedNew = false  
		  
				for i = 1, #Instances do  
					local Instance = Instances[i]  
			  
					if not CreatedEsps[Instance] and (not Validate or Validate(Instance)) then  
						CreatedNew = true  
						self:Create(Instance)  
					end  
				end  
		  
				if not CreatedNew and self._WaitChildsAdded and typeof(ObjectsAction) == "Instance" then  
					ObjectsAction.ChildAdded:Wait()  
				end  
			end  
	  
			task.wait(0.25)  
		end  
	end  
	  
	function EspManager.new(Tag)  
		local EspFolder = Instance.new("Folder", CoreGuiEspFolder)  
		EspFolder.Name = Tag  
		  
		local self = setmetatable({  
			SpecialTag = Tag,  
			EspObjects = {},  
			EspsNames = {},  
			EspFolder = EspFolder  
		}, EspManager)  
		  
		table.insert(CreatedEsps, self)  
		  
		return self  
 	end  
	  
 	return EspManager  
   end)()
end
local PlayerESP = Managers.EspManager.new("Players")

   PlayerESP:SetObjects(function()
   local PlayersTable = {}

   for _,v in pairs(game:GetService("Players"):GetPlayers()) do  
  	if v ~= Player and v.Character then  
		table.insert(PlayersTable, v.Character)  
     	end  
     end  
  return PlayersTable
end)

PlayerESP:Validator(function(Character)
return Character
and Character:FindFirstChild("HumanoidRootPart")
and Character:FindFirstChildOfClass("Humanoid")
end)

local function ToggleAntiAFK(State)
    vu32.AntiAFK = State

    task.spawn(function()
        while vu32.AntiAFK do
            vu6:CaptureController()
            vu6:ClickButton1(Vector2.new(999999, 999999))
            task.wait(600)
        end
    end)
end

Esp:AddSection("ESP")
Esp:AddSlider({
	Name = "ESP Size",
	Flag = "S-EspSize",
	Min = 7,
	Max = 15,
	Default = 10,
	Increment = 1,
	Callback = function(v)
		for i = 1, #Managers.EspManager.CreatedEsps do
			Managers.EspManager.CreatedEsps[i]:ChangeEspSize(v)
		end
	end
})
Esp:AddToggle({
  Name = "ESP Players",
  Flag = "B-EspPlayers",
  Default = false,
  Callback = function(v)
      PlayerESP.Enabled = v
  end
})
Misc:AddSection("Local-Player")
Movement = loadstring(game:HttpGet("https://pastefy.app/AUTo6O5h/raw"))()

Misc:AddToggle({
    Name = "Enable Speed Hack",
    Flag = "S-SpeedJump",
    Description = "",
    Default = false,
    Callback = function(v)
        Movement:Toggle(v)
    end
})
Misc:AddSlider({
    Name = "Walk Speed",
    Flag = "S-WalkSpeed",
    Min = 16,
    Max = 300,
    Default = 58,
    Callback = function(v)
        Movement:SetSpeed(v)
    end
})

Misc:AddSection("Others")

Misc:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(Value)
        Noclip = Value
    end
})

RunService.Stepped:Connect(function()
    if not Noclip then return end

    local Character = Players.LocalPlayer.Character
    if not Character then return end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid or Humanoid.Health <= 0 then return end

    for _, v in ipairs(Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end)
Misc:AddToggle({
    "Anti AFK",
    true,
    ToggleAntiAFK,
    "M-AntiAFK"
})
