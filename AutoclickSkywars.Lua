local p = game:GetService("Players").LocalPlayer
local u = game:GetService("UserInputService")
local v = game:GetService("VirtualInputManager")
local s = 1/50 -- Tốc độ mặc định
local e = true
local h = false
local i = false
local uiActive = false -- Trạng thái Select UI
local uiCreated = false -- Kiểm tra nếu UI đã được tạo

local function z(m)
    local c = workspace.CurrentCamera.ViewportSize
    for _, r in ipairs({{0, c.X, c.Y*.8, c.Y}, {0, c.X*.3, c.Y*.6, c.Y}, {c.X*.7, c.X, c.Y*.6, c.Y}}) do
        if m.X >= r[1] and m.X <= r[2] and m.Y >= r[3] and m.Y <= r[4] then return false end
    end
    return true
end

local g = Instance.new("ScreenGui", game.CoreGui)
local o = Instance.new("TextButton", g)
o.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
o.Position = UDim2.new(0, 10, .5, 0)
o.Size = UDim2.new(0, 120, 0, 50)
o.Font = Enum.Font.GothamBold
o.Text = "Autoclick"
o.TextColor3 = Color3.fromRGB(255, 255, 255)
o.TextScaled = true

local f = Instance.new("Frame", g)
f.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
f.Position = UDim2.new(.3, 0, .3, 0)
f.Size = UDim2.new(0, 250, 0, 200)
f.Visible = false
f.Active = true
f.Draggable = true
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)

local x = Instance.new("TextButton", f)
x.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
x.Position = UDim2.new(.88, 0, .05, 0)
x.Size = UDim2.new(0, 25, 0, 25)
x.Font = Enum.Font.GothamBold
x.Text = "X"
x.TextColor3 = Color3.fromRGB(255, 255, 255)
x.TextScaled = true

local t = Instance.new("TextLabel", f)
t.BackgroundTransparency = 1
t.Size = UDim2.new(0, 200, 0, 30)
t.Font = Enum.Font.GothamBold
t.Text = "settings"
t.TextColor3 = Color3.fromRGB(255, 255, 255)
t.TextScaled = true

local b = Instance.new("TextBox", f)
b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
b.Position = UDim2.new(.1, 0, .22, 0)
b.Size = UDim2.new(0, 200, 0, 30)
b.Font = Enum.Font.Gotham
b.PlaceholderText = "Velocidad (ej: 50)"
b.Text = "50"
b.TextColor3 = Color3.fromRGB(255, 255, 255)
b.TextScaled = true
Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)

local a = Instance.new("TextButton", f)
a.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
a.Position = UDim2.new(.1, 0, .45, 0)
a.Size = UDim2.new(0, 200, 0, 30)
a.Font = Enum.Font.GothamBold
a.Text = "start"
a.TextColor3 = Color3.fromRGB(0, 0, 0)
a.TextScaled = true
Instance.new("UICorner", a).CornerRadius = UDim.new(0, 8)

local w = Instance.new("TextButton", f)
w.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
w.Position = UDim2.new(.1, 0, .58, 0)
w.Size = UDim2.new(0, 200, 0, 30)
w.Font = Enum.Font.GothamBold
w.Text = "Autoclick: ON"
w.TextColor3 = Color3.fromRGB(255, 255, 255)
w.TextScaled = true
Instance.new("UICorner", w).CornerRadius = UDim.new(0, 8)

local selectUI = Instance.new("TextButton", f)
selectUI.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
selectUI.Position = UDim2.new(.1, 0, .7, 0)
selectUI.Size = UDim2.new(0, 200, 0, 30)
selectUI.Font = Enum.Font.GothamBold
selectUI.Text = "Select UI: OFF"
selectUI.TextColor3 = Color3.fromRGB(255, 255, 255)
selectUI.TextScaled = true
Instance.new("UICorner", selectUI).CornerRadius = UDim.new(0, 8)

local l = Instance.new("TextLabel", f)
l.BackgroundTransparency = 1
l.Position = UDim2.new(.1, 0, .89, 0)
l.Size = UDim2.new(0, 200, 0, 20)
l.Font = Enum.Font.Gotham
l.Text = "Already active"
l.TextColor3 = Color3.fromRGB(255, 255, 255)
l.TextScaled = true

-- Logic autoclick không giới hạn CPS
spawn(function()
    local lastClick = tick()
    while true do
        if not e then
            i = false
            task.wait()
            continue
        end
        local currentTime = tick()
        if (currentTime - lastClick) >= s then
            pcall(function()
                if p.Character then
                    local t = p.Character:FindFirstChildOfClass("Tool")
                    if t and t:FindFirstChild("Handle") then
                        local n = t.Name:lower()
                        local tip = t.ToolTip:lower()
                        local isBow = n == "bow" -- Loại trừ bow
                        if isBow then
                            i = false
                            return
                        end

                        local k = n:find("sword") or n:find("swords") or n:find("speed") or n:find("heal") or n:find("shield") or 
                                  tip:find("speed") or tip:find("heal") or tip:find("shield")
                        if k then
                            t:Activate()
                            if not i then
                                pcall(function()
                                    t.Activated:Fire()
                                    local r = t:FindFirstChildOfClass("RemoteEvent")
                                    if r then r:FireServer() end
                                end)
                                i = true
                            end
                        elseif z(u:GetMouseLocation()) then -- Autoclick cho block/pickaxe
                            t:Activate()
                        else
                            i = false
                        end
                    end
                end
            end)
            lastClick = currentTime
        end
        task.wait()
    end
end)

-- Logic Select UI
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CustomToolUI"
gui.ResetOnSpawn = false

local UIS = game:GetService("UserInputService")

local tools = {
    { name = "Sword", pos = UDim2.new(0.1, 0, 0.7, 0) },
    { name = "Bow", pos = UDim2.new(0.3, 0, 0.7, 0) },
    { name = "Axe", pos = UDim2.new(0.5, 0, 0.7, 0) },
    { name = "Block", pos = UDim2.new(0.7, 0, 0.7, 0) },
}

local buttons = {}
local currentTool = nil -- Lưu công cụ đang cầm

-- Chuyển đổi trạng thái Select UI
selectUI.MouseButton1Click:Connect(function()
    uiActive = not uiActive
    selectUI.Text = uiActive and "Select UI: ON" or "Select UI: OFF"
    selectUI.BackgroundColor3 = uiActive and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(100, 100, 100)

    if uiActive and not uiCreated then
        for _, tool in pairs(tools) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 100, 0, 100) -- Tăng gấp đôi từ 50x50 lên 100x100
            btn.Position = tool.pos
            btn.Text = tool.name
            btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            btn.BackgroundTransparency = 0.5
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 14
            btn.TextStrokeTransparency = 0.8
            btn.Parent = gui
            btn.Active = true
            table.insert(buttons, btn)

            -- Logic click để bật/tắt công cụ
            btn.MouseButton1Click:Connect(function()
                local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                if not humanoid then return end

                -- Kiểm tra công cụ đang cầm (bất kể từ UI gốc hay UI tùy chỉnh)
                local currentHeldTool = humanoid.Parent:FindFirstChildOfClass("Tool")
                local isHoldingThisTool = currentHeldTool and currentHeldTool.Name == tool.name

                if isHoldingThisTool then
                    -- Nếu đang cầm công cụ này, bỏ trang bị
                    humanoid:UnequipTools()
                    currentTool = nil
                else
                    -- Nếu không cầm công cụ này, bỏ trang bị công cụ hiện tại (nếu có) và trang bị công cụ mới
                    if currentTool then
                        humanoid:UnequipTools()
                    end

                    local backpack = player:FindFirstChild("Backpack")
                    if backpack then
                        local foundTool = backpack:FindFirstChild(tool.name)
                        if foundTool then
                            humanoid:EquipTool(foundTool)
                            currentTool = tool.name
                        end
                    end
                end
            end)

            -- Kéo di chuyển nút
            local dragging = false
            local dragStart, startPos

            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch and uiActive then
                    dragging = true
                    dragStart = input.Position
                    startPos = btn.Position
                end
            end)

            btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UIS.TouchMoved:Connect(function(input)
                if dragging then
                    local delta = input.Position - dragStart
                    btn.Position = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
                end
            end)
        end
        uiCreated = true
    end

    -- Bật/tắt khả năng kéo thả
    for _, btn in pairs(buttons) do
        btn.Active = uiActive
    end
end)

spawn(function()
    wait(.5)
    if not h then
        v:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, nil)
        wait(.1)
        v:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, nil)
        h = true
    end
end)

o.MouseButton1Click:Connect(function()
    f.Visible = true
end)

x.MouseButton1Click:Connect(function()
    f.Visible = false
end)

a.MouseButton1Click:Connect(function()
    local n = tonumber(b.Text)
    if n and n >= 1 then
        s = 1/n
        l.Text = "Already active"
        l.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        l.Text = "error"
        l.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

local function k()
    w.Text = e and "Autoclick: ON" or "Autoclick: OFF"
    w.BackgroundColor3 = e and Color3.fromRGB(70, 130, 180) or Color3.fromRGB(100, 100, 100)
    b.Active = e
    b.TextTransparency = e and 0 or .5
    b.BackgroundColor3 = e and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    local n = tonumber(b.Text)
    if n and n >= 1 then
        l.Text = "Already active"
        s = 1/n
    else
        l.Text = "error"
    end
end

w.MouseButton1Click:Connect(function()
    e = not e
    i = false
    k()
end)

p.CharacterAdded:Connect(function()
    e = true
    i = false
    k()
end)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="Script Loaded", Text="Made by FearMongerX", Duration=6})
end)
