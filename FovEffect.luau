local FovEffect = {}
FovEffect.__index = FovEffect

local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

local ActiveEffect = nil

function FovEffect.new(frame, fovChange) 
	local self = setmetatable({}, FovEffect)
	self.Frame = frame
	self.OrigSize = frame.Size
	self.OrigFov = Camera.FieldOfView
	self.FovChange = -40 
	self.IsOpen = false
	
	

	self.Blur = Instance.new("BlurEffect")
	self.Blur.Size = 0
	self.Blur.Parent = Lighting

	self.TweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)

	self.Frame.Size = UDim2.new(0, 0, 0, 0)
	self.Frame.BackgroundTransparency = 1
	self.Frame.Visible = false

	return self
end

function FovEffect:MakeFrameTween(scale, alpha)
	local newSize = UDim2.new(
		self.OrigSize.X.Scale * scale,
		self.OrigSize.X.Offset * scale,
		self.OrigSize.Y.Scale * scale,
		self.OrigSize.Y.Offset * scale
	)
	return TweenService:Create(self.Frame, self.TweenInfo, {Size = newSize, BackgroundTransparency = alpha})
end

function FovEffect:MakeCamTween(fov, blurSize)
	local camTween = TweenService:Create(Camera, self.TweenInfo, {FieldOfView = fov})
	local blurTween
	if self.Blur and self.Blur.Parent then
		blurTween = TweenService:Create(self.Blur, self.TweenInfo, {Size = blurSize})
	end
	return camTween, blurTween
end

function FovEffect:Open()
	if ActiveEffect and ActiveEffect ~= self then
		ActiveEffect:Close()
	end
	ActiveEffect = self

	self.Frame.Visible = true
	local frameTween = self:MakeFrameTween(1, 0)
	local camTween, blurTween = self:MakeCamTween(self.OrigFov + self.FovChange, 20) 
	frameTween:Play()
	camTween:Play()
	if blurTween then blurTween:Play() end
	self.IsOpen = true
end

function FovEffect:Close()
	local frameTween = self:MakeFrameTween(0, 1)
	local camTween, blurTween = self:MakeCamTween(self.OrigFov, 0)
	frameTween:Play()
	camTween:Play()
	if blurTween then blurTween:Play() end
	frameTween.Completed:Connect(function()
		self.Frame.Visible = false
		self.IsOpen = false
		if ActiveEffect == self then
			ActiveEffect = nil
		end
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
