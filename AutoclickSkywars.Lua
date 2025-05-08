local p = game:GetService("Players").LocalPlayer
local u = game:GetService("UserInputService")
local v = game:GetService("VirtualInputManager")
local s = 1/50 -- Tốc độ mặc định (sẽ không giới hạn CPS)
local e = true
local h = false
local i = false

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
w.Position = UDim2.new(.1, 0, .7, 0)
w.Size = UDim2.new(0, 200, 0, 30)
w.Font = Enum.Font.GothamBold
w.Text = "Autoclick: ON"
w.TextColor3 = Color3.fromRGB(255, 255, 255)
w.TextScaled = true
Instance.new("UICorner", w).CornerRadius = UDim.new(0, 8)

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
        task.wait() -- Độ trễ tối thiểu để không gây lag
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
