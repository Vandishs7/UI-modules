local FovEffect = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

FovEffect.ZoomFOV = 20
FovEffect.DefaultFOV = 70
FovEffect.TweenTime = 0.4
FovEffect.BlurSize = 24

local uiStates = {}

local function isInsideFrame(gui, frame)
	return gui == frame or gui:IsDescendantOf(frame)
end

local function hideOtherUI(frame)
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	uiStates[frame] = {}

	for _, gui in ipairs(playerGui:GetDescendants()) do
		if gui:IsA("GuiObject") and not isInsideFrame(gui, frame) then
			uiStates[frame][gui] = gui.Visible
			gui.Visible = false
		end
	end
end

local function restoreUI(frame)
	local saved = uiStates[frame]
	if saved then
		for gui, wasVisible in pairs(saved) do
			if gui and gui.Parent then
				gui.Visible = wasVisible
			end
		end
		uiStates[frame] = nil
	end
end

function FovEffect:Open(frame)
	local camera = workspace.CurrentCamera
	hideOtherUI(frame)

	local blur = Instance.new("BlurEffect")
	blur.Name = "UICustomBlur"
	blur.Size = 0
	blur.Parent = Lighting

	TweenService:Create(blur, TweenInfo.new(self.TweenTime), { Size = self.BlurSize }):Play()
	TweenService:Create(camera, TweenInfo.new(self.TweenTime), { FieldOfView = self.ZoomFOV }):Play()

	frame.Visible = true
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.new(0.5, 0, 0, -frame.AbsoluteSize.Y)

	local targetPos = UDim2.new(0.5, 0, 0.5, 0)
	TweenService:Create(
		frame,
		TweenInfo.new(self.TweenTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Position = targetPos }
	):Play()
end

function FovEffect:Close(frame)
	local camera = workspace.CurrentCamera
	restoreUI(frame)

	local blur = Lighting:FindFirstChild("UICustomBlur")
	if blur then
		local tween = TweenService:Create(blur, TweenInfo.new(self.TweenTime), { Size = 0 })
		tween:Play()
		tween.Completed:Connect(function()
			blur:Destroy()
		end)
	end

	TweenService:Create(camera, TweenInfo.new(self.TweenTime), { FieldOfView = self.DefaultFOV }):Play()

	local offscreenPos = UDim2.new(0.5, 0, 1.5, 0)
	local tween = TweenService:Create(
		frame,
		TweenInfo.new(self.TweenTime, Enum.EasingStyle.Back, Enum.EasingDirection.In),
		{ Position = offscreenPos }
	)
	tween:Play()
	tween.Completed:Connect(function()
		frame.Visible = false
	end)
end

return FovEffect
