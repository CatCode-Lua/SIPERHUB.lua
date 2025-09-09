-- Script de Super Poderes para Roblox Mobile
-- Por: [Tu Nombre]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variables de estado
local isFlying = false
local isInvisible = false
local originalWalkSpeed = humanoid.WalkSpeed
local originalVisibility = true

-- Crear la interfaz de usuario
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SuperPowersUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- Marco principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 250)
mainFrame.Position = UDim2.new(0, 50, 0, 200)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Corner para bordes redondeados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Barra de título
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Position = UDim2.new(0.15, 0, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Super Poderes"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 16
titleText.Parent = titleBar

-- Botón de minimizar/cerrar
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(0.85, 0, 0, 0)
minimizeButton.BackgroundTransparency = 1
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 20
minimizeButton.Parent = titleBar

-- Contenedor de botones
local buttonsContainer = Instance.new("Frame")
buttonsContainer.Name = "ButtonsContainer"
buttonsContainer.Size = UDim2.new(1, -20, 1, -50)
buttonsContainer.Position = UDim2.new(0, 10, 0, 40)
buttonsContainer.BackgroundTransparency = 1
buttonsContainer.Parent = mainFrame

-- Botón de velocidad
local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedButton"
speedButton.Size = UDim2.new(1, 0, 0, 40)
speedButton.Position = UDim2.new(0, 0, 0, 0)
speedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedButton.Text = "Velocidad: " .. humanoid.WalkSpeed
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.Gotham
speedButton.TextSize = 14
speedButton.Parent = buttonsContainer

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedButton

-- Botón de vuelo
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(1, 0, 0, 40)
flyButton.Position = UDim2.new(0, 0, 0, 50)
flyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
flyButton.Text = "Volar: OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 100, 100)
flyButton.Font = Enum.Font.Gotham
flyButton.TextSize = 14
flyButton.Parent = buttonsContainer

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flyButton

-- Botón de invisibilidad
local invisibleButton = Instance.new("TextButton")
invisibleButton.Name = "InvisibleButton"
invisibleButton.Size = UDim2.new(1, 0, 0, 40)
invisibleButton.Position = UDim2.new(0, 0, 0, 100)
invisibleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
invisibleButton.Text = "Invisible: OFF"
invisibleButton.TextColor3 = Color3.fromRGB(255, 100, 100)
invisibleButton.Font = Enum.Font.Gotham
invisibleButton.TextSize = 14
invisibleButton.Parent = buttonsContainer

local invisibleCorner = Instance.new("UICorner")
invisibleCorner.CornerRadius = UDim.new(0, 8)
invisibleCorner.Parent = invisibleButton

-- Variables para el vuelo
local flySpeed = 50
local flyEnabled = false
local bodyVelocity
local bodyGyro

-- Función para activar/desactivar vuelo
local function toggleFly()
    flyEnabled = not flyEnabled
    isFlying = flyEnabled
    
    if flyEnabled then
        flyButton.Text = "Volar: ON"
        flyButton.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Crear BodyVelocity y BodyGyro para el vuelo
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Parent = humanoidRootPart
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.P = 1000
        bodyGyro.D = 50
        bodyGyro.CFrame = humanoidRootPart.CFrame
        bodyGyro.Parent = humanoidRootPart
        
        humanoid.PlatformStand = true
    else
        flyButton.Text = "Volar: OFF"
        flyButton.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
        
        humanoid.PlatformStand = false
    end
end

-- Función para manejar el movimiento durante el vuelo
local function handleFly(input)
    if not flyEnabled or not bodyVelocity or not bodyGyro then return end
    
    local camera = workspace.CurrentCamera
    local forward = camera.CFrame.LookVector
    local right = camera.CFrame.RightVector
    local up = Vector3.new(0, 1, 0)
    
    local direction = Vector3.new(0, 0, 0)
    
    if input:IsKeyDown(Enum.KeyCode.W) then
        direction = direction + forward
    end
    if input:IsKeyDown(Enum.KeyCode.S) then
        direction = direction - forward
    end
    if input:IsKeyDown(Enum.KeyCode.A) then
        direction = direction - right
    end
    if input:IsKeyDown(Enum.KeyCode.D) then
        direction = direction + right
    end
    if input:IsKeyDown(Enum.KeyCode.Space) then
        direction = direction + up
    end
    if input:IsKeyDown(Enum.KeyCode.LeftControl) then
        direction = direction - up
    end
    
    if direction.Magnitude > 0 then
        direction = direction.Unit * flySpeed
    end
    
    bodyVelocity.Velocity = direction
    bodyGyro.CFrame = camera.CFrame
end

-- Función para toggle de velocidad
local function toggleSpeed()
    if humanoid.WalkSpeed == 50 then
        humanoid.WalkSpeed = originalWalkSpeed
        speedButton.Text = "Velocidad: " .. humanoid.WalkSpeed
    else
        originalWalkSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = 50
        speedButton.Text = "Velocidad: " .. humanoid.WalkSpeed
    end
end

-- Función para toggle de invisibilidad
local function toggleInvisibility()
    isInvisible = not isInvisible
    
    if isInvisible then
        invisibleButton.Text = "Invisible: ON"
        invisibleButton.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Hacer invisible el personaje
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                if part:FindFirstChildOfClass("Decal") then
                    part:FindFirstChildOfClass("Decal").Transparency = 1
                end
            elseif part:IsA("Accessory") then
                local handle = part:FindFirstChild("Handle")
                if handle then
                    handle.Transparency = 1
                end
            end
        end
    else
        invisibleButton.Text = "Invisible: OFF"
        invisibleButton.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        -- Restaurar visibilidad
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
                if part:FindFirstChildOfClass("Decal") then
                    part:FindFirstChildOfClass("Decal").Transparency = 0
                end
            elseif part:IsA("Accessory") then
                local handle = part:FindFirstChild("Handle")
                if handle then
                    handle.Transparency = 0
                end
            end
        end
    end
end

-- Función para minimizar la interfaz
local function toggleMinimize()
    if buttonsContainer.Visible then
        buttonsContainer.Visible = false
        mainFrame.Size = UDim2.new(0, 200, 0, 30)
        minimizeButton.Text = "+"
    else
        buttonsContainer.Visible = true
        mainFrame.Size = UDim2.new(0, 200, 0, 250)
        minimizeButton.Text = "-"
    end
end

-- Conectar eventos de los botones
speedButton.MouseButton1Click:Connect(toggleSpeed)
flyButton.MouseButton1Click:Connect(toggleFly)
invisibleButton.MouseButton1Click:Connect(toggleInvisibility)
minimizeButton.MouseButton1Click:Connect(toggleMinimize)

-- Conectar eventos de teclado para el vuelo
UserInputService.InputBegan:Connect(function(input)
    if flyEnabled then
        handleFly(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if flyEnabled and input.UserInputType == Enum.UserInputType.Touch then
        handleFly(input)
    end
end)

-- Manejar la recreación del personaje
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Restaurar configuración si estaba activa
    if isFlying then
        toggleFly() -- Desactivar vuelo primero
        toggleFly() -- Reactivar vuelo
    end
    
    if isInvisible then
        toggleInvisibility() -- Desactivar invisibilidad primero
        toggleInvisibility() -- Reactivar invisibilidad
    end
end)

-- Mensaje de confirmación
print("Script de Super Poderes cargado exitosamente!")
print("Características:")
print("- Botón de velocidad (toggle 16/50)")
print("- Botón de vuelo con controles WASD + Space/Ctrl")
print("- Botón de invisibilidad")
print("- Interfaz móvil con minimizar y arrastrar")