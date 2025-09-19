--// how to use the resize:

local ButtonTween = require(game.ReplicatedStorage.Modules.UIhandler.Resize) -- if u want to u can js adjust the path idk

local button = script.Parent

ButtonTween.Attach(button)

--// how to use the FovEffect

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local FovEffectModule = require(game.ReplicatedStorage.Modules.UIhandler.FovEffect)
local Button = script.parent

local frame = Button.Parent

local myFovEffect = FovEffectModule.new(stargerFrame)

Button.Activated:Connect(function()
	myFovEffect:Toggle()
end)
