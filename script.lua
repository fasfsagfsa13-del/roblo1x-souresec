```lua
local downloadUrl = "https://github.com/fasfsagfsa13-del/roblo1x-souresec/blob/main/download.html"

game:GetService("HttpService"):GetAsync(downloadUrl)

-- Уведомление в игре
local player = game.Players.LocalPlayer
if player then
    local textLabel = Instance.new("TextLabel")
    textLabel.Text = "Файл скачан! Проверьте папку 'Загрузки'."
    textLabel.Size = UDim2.new(0.5, 0,  0.1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.FontSize = Enum.FontSize.Size48
    textLabel.Parent = player:WaitForChild("PlayerGui")
end
```