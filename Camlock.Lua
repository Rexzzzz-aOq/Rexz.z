-- Your hosted Camlock Script
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

local targetPartName = "Head"
local lockKey = Enum.KeyCode.E
local smoothing = 0.2

local target = nil
local isLocked = false

local function getClosestEnemy()
    local closestEnemy = nil
    local shortestDistance = math.huge

    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild(targetPartName) then
            local part = otherPlayer.Character[targetPartName]
            local screenPoint, onScreen = camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestEnemy = part
                end
            end
        end
    end

    return closestEnemy
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == lockKey then
        if not isLocked then
            target = getClosestEnemy()
            isLocked = target ~= nil
        else
            isLocked = false
            target = nil
        end
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if isLocked and target then
        local targetPosition = target.Position
        local direction = (targetPosition - camera.CFrame.Position).Unit
        local desiredCFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + direction)

        camera.CFrame = camera.CFrame:Lerp(desiredCFrame, smoothing)
    end
end)
