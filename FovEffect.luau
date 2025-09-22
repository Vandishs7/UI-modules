local FovEffect = {}
FovEffect.__index = FovEffect

local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

local ActiveEffect

function FovEffect.new(frame, fovChange)
	local self = setmetatable({}, FovEffect)
	self.Frame = frame
	self.OrigSize = frame.Size
	self.OrigFov = Camera.FieldOfView
	self.FovChange = fovChange or -40
	self.IsOpen = false

	self.Blur = Instance.new("BlurEffect")
	self.Blur.Size = 0
	self.Blur.Parent = Lighting

	self.TweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)

	frame.Size = UDim2.new(0, 0, 0, 0)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	return self
end

function FovEffect:MakeFrameTween(scale, alpha)
	return TweenService:Create(self.Frame, self.TweenInfo, {
		Size = UDim2.new(
			self.OrigSize.X.Scale * scale,
			self.OrigSize.X.Offset * scale,
			self.OrigSize.Y.Scale * scale,
			self.OrigSize.Y.Offset * scale
		),
		BackgroundTransparency = alpha
	})
end

function FovEffect:MakeCamTween(fov, blurSize)
	local t1 = TweenService:Create(Camera, self.TweenInfo, {FieldOfView = fov})
	local t2 = self.Blur.Parent and TweenService:Create(self.Blur, self.TweenInfo, {Size = blurSize})
	return t1, t2
end

function FovEffect:Open()
	if ActiveEffect and ActiveEffect ~= self then ActiveEffect:Close() end
	ActiveEffect = self
	self.Frame.Visible = true
	local ft = self:MakeFrameTween(1, 0)
	local ct, bt = self:MakeCamTween(self.OrigFov + self.FovChange, 20)
	ft:Play(); ct:Play(); if bt then bt:Play() end
	self.IsOpen = true
end

function FovEffect:Close()
	local ft = self:MakeFrameTween(0, 1)
	local ct, bt = self:MakeCamTween(self.OrigFov, 0)
	ft:Play(); ct:Play(); if bt then bt:Play() end
	ft.Completed:Connect(function()
		self.Frame.Visible = false
		self.IsOpen = false
		if ActiveEffect == self then ActiveEffect = nil end
	end)
end

function FovEffect:Toggle()
	if self.IsOpen then
		self:Close()
	else
		self:Open()
	end
end

return FovEffect
