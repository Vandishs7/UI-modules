local TweenService = game:GetService("TweenService")

local ButtonTween = {}


function ButtonTween.Attach(button)
	local normalSize = button.Size
	local hoverSize  = UDim2.new(normalSize.X.Scale * 1.1, normalSize.X.Offset,
		normalSize.Y.Scale * 1.1, normalSize.Y.Offset)
	local clickSize  = UDim2.new(normalSize.X.Scale * 0.8, normalSize.X.Offset,
		normalSize.Y.Scale * 0.8, normalSize.Y.Offset)
	local enlargedSize = UDim2.new(normalSize.X.Scale * 1.2, normalSize.X.Offset,
		normalSize.Y.Scale * 1.2, normalSize.Y.Offset)


	local isHovered = false
	local isClicked = false

	local function tweenTo(size, time)
		local info = TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		TweenService:Create(button, info, {Size = size}):Play()
	end

	local function onHover()
		if not isHovered and not isClicked then
			isHovered = true
			tweenTo(enlargedSize, 0.1)
			task.wait(0.1)
			if isHovered then
				tweenTo(hoverSize, 0.1)
			end
		end
	end

	local function onUnhover()
		isHovered = false
		if not isClicked then
			tweenTo(normalSize, 0.1)
		end
	end

	local function onClick()
		isClicked = true
		tweenTo(clickSize, 0.1)
		task.wait(0.1)
		tweenTo(hoverSize, 0.1)
		task.wait(0.1)
		tweenTo(normalSize, 0.1)
		isClicked = false
	end

	button.MouseEnter:Connect(onHover)
	button.MouseLeave:Connect(onUnhover)
	button.MouseButton1Down:Connect(onClick)
end

return ButtonTween
