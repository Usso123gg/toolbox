# ╔══════════════════════════════════════════════════════════════╗
# ║  Sam's Windows Toolbox v1.0                                 ║
# ║  Post-install automation — apps, tweaks, wallpaper, updates ║
# ║  Run: irm "YOUR_URL/SamToolbox.ps1" | iex                  ║
# ║  Or:  powershell -ExecutionPolicy Bypass -File SamToolbox.ps1║
# ╚══════════════════════════════════════════════════════════════╝

#Requires -RunAsAdministrator

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ── Theme Colors ──────────────────────────────────────────────
$script:Colors = @{
    BgDark      = [System.Drawing.Color]::FromArgb(18, 18, 24)
    BgPanel     = [System.Drawing.Color]::FromArgb(26, 26, 36)
    BgCard      = [System.Drawing.Color]::FromArgb(34, 34, 48)
    BgHover     = [System.Drawing.Color]::FromArgb(44, 44, 62)
    Accent      = [System.Drawing.Color]::FromArgb(0, 180, 216)
    AccentDim   = [System.Drawing.Color]::FromArgb(0, 120, 150)
    Success     = [System.Drawing.Color]::FromArgb(0, 200, 120)
    Warning     = [System.Drawing.Color]::FromArgb(255, 180, 0)
    Danger      = [System.Drawing.Color]::FromArgb(220, 50, 50)
    TextPrimary = [System.Drawing.Color]::FromArgb(230, 230, 240)
    TextDim     = [System.Drawing.Color]::FromArgb(140, 140, 160)
    Border      = [System.Drawing.Color]::FromArgb(50, 50, 70)
}

$script:FontFamily = "Segoe UI"
$script:LogBox = $null

# ── App Catalog ───────────────────────────────────────────────
# Each entry: DisplayName, WingetID, Category
$script:AppCatalog = @(
    # ── Browser ──
    @("Brave",              "Brave.Brave",                  "Browser")
    @("Firefox",            "Mozilla.Firefox",              "Browser")
    @("Chrome",             "Google.Chrome",                "Browser")
    @("Zen Browser",        "Zen-Team.Zen-Browser",         "Browser")
    @("Tor Browser",        "TorProject.TorBrowser",        "Browser")

    # ── Comunicazione ──
    @("Discord",            "Discord.Discord",              "Comunicazione")
    @("Telegram",           "Telegram.TelegramDesktop",     "Comunicazione")
    @("WhatsApp",           "WhatsApp.WhatsApp",            "Comunicazione")
    @("Signal",             "OpenWhisperSystems.Signal",    "Comunicazione")
    @("Slack",              "SlackTechnologies.Slack",      "Comunicazione")
    @("Zoom",               "Zoom.Zoom",                   "Comunicazione")
    @("Teams",              "Microsoft.Teams",              "Comunicazione")

    # ── Gaming ──
    @("Steam",              "Valve.Steam",                  "Gaming")
    @("Rockstar Launcher",  "Rockstar.Launcher",            "Gaming")
    @("Epic Games",         "EpicGames.EpicGamesLauncher",  "Gaming")
    @("EA App",             "ElectronicArts.EADesktop",     "Gaming")
    @("GOG Galaxy",         "GOG.Galaxy",                   "Gaming")

    # ── NVIDIA / GPU ──
    @("NVIDIA App",         "Nvidia.NvidiaApp",             "GPU & Driver")
    @("GeForce Experience", "Nvidia.GeForceExperience",     "GPU & Driver")
    @("GPU-Z",              "TechPowerUp.GPU-Z",            "GPU & Driver")
    @("MSI Afterburner",    "Guru3D.Afterburner",           "GPU & Driver")

    # ── Multimedia ──
    @("VLC",                "VideoLAN.VLC",                 "Multimedia")
    @("Spotify",            "Spotify.Spotify",              "Multimedia")
    @("OBS Studio",         "OBSProject.OBSStudio",         "Multimedia")
    @("HandBrake",          "HandBrake.HandBrake",          "Multimedia")
    @("Audacity",           "Audacity.Audacity",            "Multimedia")
    @("foobar2000",         "PeterPawlowski.foobar2000",    "Multimedia")

    # ── Utility ──
    @("AnyDesk",            "AnyDeskSoftware.AnyDesk",      "Utility")
    @("7-Zip",              "7zip.7zip",                    "Utility")
    @("WinRAR",             "RARLab.WinRAR",                "Utility")
    @("Notepad++",          "Notepad++.Notepad++",          "Utility")
    @("PowerToys",          "Microsoft.PowerToys",          "Utility")
    @("Everything Search",  "voidtools.Everything",         "Utility")
    @("qBittorrent",        "qBittorrent.qBittorrent",     "Utility")
    @("TreeSize Free",      "JAMSoftware.TreeSize.Free",    "Utility")
    @("WizTree",            "AntibodySoftware.WizTree",     "Utility")

    # ── Sviluppo ──
    @("VS Code",            "Microsoft.VisualStudioCode",   "Sviluppo")
    @("Git",                "Git.Git",                      "Sviluppo")
    @("Node.js LTS",        "OpenJS.NodeJS.LTS",            "Sviluppo")
    @("Python 3",           "Python.Python.3.12",           "Sviluppo")
    @("Windows Terminal",   "Microsoft.WindowsTerminal",    "Sviluppo")
    @("Docker Desktop",     "Docker.DockerDesktop",         "Sviluppo")

    # ── Sicurezza ──
    @("Bitwarden",          "Bitwarden.Bitwarden",          "Sicurezza")
    @("KeePassXC",          "KeePassXCTeam.KeePassXC",     "Sicurezza")
    @("ProtonVPN",          "ProtonTechnologies.ProtonVPN", "Sicurezza")
    @("Malwarebytes",       "Malwarebytes.Malwarebytes",    "Sicurezza")

    # ── System ──
    @("Windows Activation", "ACTIVATION_SCRIPT",            "System")
    @("Spotify Lite",       "SPOTIFY_LITE_DOWNLOAD",        "System")
)

# ── Tweaks Catalog ────────────────────────────────────────────
$script:TweaksCatalog = @(
    # Essential
    @("Disabilita Telemetria",              "Essential", {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord -Force
        Get-Service DiagTrack -ErrorAction SilentlyContinue | Stop-Service -Force -PassThru | Set-Service -StartupType Disabled
        Get-Service dmwappushservice -ErrorAction SilentlyContinue | Stop-Service -Force -PassThru | Set-Service -StartupType Disabled
    })
    @("Disabilita Cronologia Attività",     "Essential", {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Value 0 -Type DWord -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Value 0 -Type DWord -Force
    })
    @("Disabilita Location Tracking",       "Essential", {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" -Name "DisableLocation" -Value 1 -Type DWord -Force
    })
    @("Disabilita Bing nel Menu Start",     "Essential", {
        $path = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
        if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        Set-ItemProperty -Path $path -Name "DisableSearchBoxSuggestions" -Value 1 -Type DWord -Force
    })
    @("Disabilita Widgets",                 "Essential", {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Dsh" -Name "AllowNewsAndInterests" -Value 0 -Type DWord -Force
        Get-AppxPackage *WebExperience* | Remove-AppxPackage -ErrorAction SilentlyContinue
    })
    @("Abilita End Task con Click Destro",  "Essential", {
        $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings"
        if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        Set-ItemProperty -Path $path -Name "TaskbarEndTask" -Value 1 -Type DWord -Force
    })
    @("Pulizia Disco",                      "Essential", {
        Start-Process cleanmgr -ArgumentList "/sagerun:1" -Wait
    })
    @("Crea Punto di Ripristino",           "Essential", {
        Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
        Checkpoint-Computer -Description "SamToolbox_Restore" -RestorePointType MODIFY_SETTINGS
    })
    @("Rimuovi File Temporanei",            "Essential", {
        Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    })
    @("Disabilita Risultati Store nella Ricerca", "Essential", {
        $path = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
        if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        Set-ItemProperty -Path $path -Name "NoUseStoreOpenWith" -Value 1 -Type DWord -Force
    })

    # Performance
    @("Abilita Game Mode",                  "Performance", {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1 -Type DWord -Force
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Value 1 -Type DWord -Force
    })
    @("Disabilita Animazioni UI",           "Performance", {
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Type Binary -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value "0" -Force
    })
    @("Piano Energetico: Prestazioni Max",  "Performance", {
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
        $guid = (powercfg -list | Select-String "Prestazioni massime|Ultimate Performance" | ForEach-Object { ($_ -split '\s+')[3] }) | Select-Object -First 1
        if ($guid) { powercfg -setactive $guid }
    })
    @("Disabilita Delivery Optimization",   "Performance", {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" -Name "DODownloadMode" -Value 0 -Type DWord -Force
    })
    @("Ottimizza Servizi Non Necessari",    "Performance", {
        $services = @("SysMain", "WSearch", "DiagTrack", "MapsBroker", "lfsvc", "RetailDemo")
        foreach ($svc in $services) {
            Get-Service $svc -ErrorAction SilentlyContinue | Stop-Service -Force -PassThru | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue
        }
    })
    @("Disabilita Cortana",                 "Performance", {
        $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        Set-ItemProperty -Path $path -Name "AllowCortana" -Value 0 -Type DWord -Force
    })

    # Privacy
    @("Disabilita Advertising ID",          "Privacy", {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0 -Type DWord -Force
    })
    @("Disabilita Feedback & Diagnostics",  "Privacy", {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Value 0 -Type DWord -Force
        $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
        if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        Set-ItemProperty -Path $path -Name "DoNotShowFeedbackNotifications" -Value 1 -Type DWord -Force
    })
    @("Disabilita App Background",          "Privacy", {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1 -Type DWord -Force
    })
    @("Disabilita Timeline",               "Privacy", {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Value 0 -Type DWord -Force
    })
    @("Blocca Suggerimenti App Start Menu", "Privacy", {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 0 -Type DWord -Force
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Value 0 -Type DWord -Force
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Value 0 -Type DWord -Force
    })
    @("Disabilita Consumer Features",       "Privacy", {
        $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
        if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        Set-ItemProperty -Path $path -Name "DisableWindowsConsumerFeatures" -Value 1 -Type DWord -Force
    })

    # Explorer
    @("Mostra Estensioni File",             "Explorer", {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Type DWord -Force
    })
    @("Mostra File Nascosti",              "Explorer", {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1 -Type DWord -Force
    })
    @("Abilita Percorsi Lunghi",           "Explorer", {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -Type DWord -Force
    })
    @("Disabilita Lock Screen",            "Explorer", {
        $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
        if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        Set-ItemProperty -Path $path -Name "NoLockScreen" -Value 1 -Type DWord -Force
    })
    @("Taskbar: Icone Centrate OFF",       "Explorer", {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 0 -Type DWord -Force
    })
    @("Classic Context Menu (Win11)",      "Explorer", {
        New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Force -Value "" | Out-Null
    })
    @("Disabilita Sticky Keys",            "Explorer", {
        Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Value "506" -Force
    })
    @("NumLock all'Avvio",                 "Explorer", {
        Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Value "2" -Force
    })
)

# ── Bloatware lista rimozione ─────────────────────────────────
$script:BloatwareList = @(
    "Microsoft.BingNews"
    "Microsoft.BingWeather"
    "Microsoft.GamingApp"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.People"
    "Microsoft.PowerAutomateDesktop"
    "Microsoft.Todos"
    "Microsoft.WindowsAlarms"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.YourPhone"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "Clipchamp.Clipchamp"
    "Microsoft.549981C3F5F10"  # Cortana
    "MicrosoftTeams"
    "Microsoft.OutlookForWindows"
    "Microsoft.WindowsCommunicationsApps"
    "Microsoft.SkypeApp"
)

# ══════════════════════════════════════════════════════════════
#  HELPER FUNCTIONS
# ══════════════════════════════════════════════════════════════

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "HH:mm:ss"
    $entry = "[$timestamp] [$Level] $Message"
    if ($script:LogBox) {
        $script:LogBox.Invoke([Action]{
            $script:LogBox.AppendText("$entry`r`n")
            $script:LogBox.SelectionStart = $script:LogBox.Text.Length
            $script:LogBox.ScrollToCaret()
        })
    }
    Write-Host $entry
}

function Ensure-Winget {
    $wg = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $wg) {
        Write-Log "winget non trovato — installazione in corso..." "WARN"
        try {
            Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe -ErrorAction Stop
            Start-Sleep -Seconds 3
        } catch {
            Write-Log "Impossibile installare winget automaticamente. Installa App Installer dal Microsoft Store." "ERROR"
            return $false
        }
    }
    return $true
}

function Install-AppViaWinget {
    param([string]$Name, [string]$Id)
    Write-Log "Installazione: $Name ($Id)..."

    # Handle special cases
    if ($Id -eq "ACTIVATION_SCRIPT") {
        try {
            Write-Log "Esecuzione script di attivazione Windows..."
            Invoke-Expression (Invoke-RestMethod -Uri "https://get.activated.win")
            Write-Log "$Name completato." "OK"
        } catch {
            Write-Log "$Name — errore: $($_.Exception.Message)" "ERROR"
        }
        return
    }

    if ($Id -eq "SPOTIFY_LITE_DOWNLOAD") {
        try {
            Write-Log "Apertura link download Spotify Lite..."
            Start-Process "https://www.mediafire.com/file/p1cg6tonjrwir9l/Spotify_Lite.exe/file"
            Write-Log "$Name — link aperto nel browser." "OK"
        } catch {
            Write-Log "$Name — errore: $($_.Exception.Message)" "ERROR"
        }
        return
    }

    # Standard winget installation
    try {
        $result = winget install --id $Id --accept-source-agreements --accept-package-agreements --silent 2>&1
        $exitCode = $LASTEXITCODE
        if ($exitCode -eq 0) {
            Write-Log "$Name installato con successo." "OK"
        } elseif ($result -match "already installed|già installat") {
            Write-Log "$Name è già installato." "INFO"
        } else {
            Write-Log "$Name — installazione fallita (exit: $exitCode)." "ERROR"
        }
    } catch {
        Write-Log "$Name — errore: $($_.Exception.Message)" "ERROR"
    }
}

function Set-WallpaperFromUrl {
    param([string]$Url, [string]$Style = "Fill")
    $wallpaperPath = "$env:USERPROFILE\Pictures\SamWallpaper.jpg"
    try {
        Write-Log "Download sfondo da: $Url"
        Invoke-WebRequest -Uri $Url -OutFile $wallpaperPath -UseBasicParsing
        Set-Wallpaper -Path $wallpaperPath -Style $Style
        Write-Log "Sfondo impostato con successo." "OK"
    } catch {
        Write-Log "Errore download sfondo: $($_.Exception.Message)" "ERROR"
    }
}

function Set-Wallpaper {
    param([string]$Path, [string]$Style = "Fill")
    $styleMap = @{ "Fill"=10; "Fit"=6; "Stretch"=2; "Tile"=0; "Center"=0; "Span"=22 }
    $styleVal = $styleMap[$Style]
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value $styleVal -Force
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -Value 0 -Force

    Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
    [Wallpaper]::SystemParametersInfo(0x0014, 0, $Path, 0x01 -bor 0x02) | Out-Null
}

function Set-WallpaperFromFile {
    param([string]$Path)
    if (Test-Path $Path) {
        $dest = "$env:USERPROFILE\Pictures\SamWallpaper$([System.IO.Path]::GetExtension($Path))"
        Copy-Item $Path $dest -Force
        Set-Wallpaper -Path $dest -Style "Fill"
        Write-Log "Sfondo impostato da: $Path" "OK"
    } else {
        Write-Log "File sfondo non trovato: $Path" "ERROR"
    }
}

function Set-Wallpaper {
    param([string]$Path, [string]$Style = "Fill")
    $styleMap = @{ "Fill"=10; "Fit"=6; "Stretch"=2; "Tile"=0; "Center"=0; "Span"=22 }
    $styleVal = $styleMap[$Style]
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value $styleVal -Force
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -Value 0 -Force

    Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
    [Wallpaper]::SystemParametersInfo(0x0014, 0, $Path, 0x01 -bor 0x02) | Out-Null
}

function Set-WallpaperFromFile {
    param([string]$Path)
    if (Test-Path $Path) {
        $dest = "$env:USERPROFILE\Pictures\SamWallpaper$([System.IO.Path]::GetExtension($Path))"
        Copy-Item $Path $dest -Force
        Set-Wallpaper -Path $dest -Style "Fill"
        Write-Log "Sfondo impostato da: $Path" "OK"
    } else {
        Write-Log "File sfondo non trovato: $Path" "ERROR"
    }
}

# ══════════════════════════════════════════════════════════════
#  BUILD THE GUI
# ══════════════════════════════════════════════════════════════

function Build-MainForm {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Sam's Toolbox v1.0"
    $form.Size = New-Object System.Drawing.Size(1100, 750)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = $script:Colors.BgDark
    $form.ForeColor = $script:Colors.TextPrimary
    $form.Font = New-Object System.Drawing.Font($script:FontFamily, 10)
    $form.FormBorderStyle = "FixedSingle"
    $form.MaximizeBox = $false

    # ── Title bar ─────────────────────────────────────────────
    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = "⚡ SAM'S TOOLBOX"
    $titleLabel.Font = New-Object System.Drawing.Font($script:FontFamily, 16, [System.Drawing.FontStyle]::Bold)
    $titleLabel.ForeColor = $script:Colors.Accent
    $titleLabel.Location = New-Object System.Drawing.Point(20, 10)
    $titleLabel.AutoSize = $true
    $form.Controls.Add($titleLabel)

    $versionLabel = New-Object System.Windows.Forms.Label
    $versionLabel.Text = "v1.0 — Post-Install Automation"
    $versionLabel.Font = New-Object System.Drawing.Font($script:FontFamily, 9)
    $versionLabel.ForeColor = $script:Colors.TextDim
    $versionLabel.Location = New-Object System.Drawing.Point(220, 16)
    $versionLabel.AutoSize = $true
    $form.Controls.Add($versionLabel)

    # ── Tab Control ───────────────────────────────────────────
    $tabControl = New-Object System.Windows.Forms.TabControl
    $tabControl.Location = New-Object System.Drawing.Point(10, 45)
    $tabControl.Size = New-Object System.Drawing.Size(1065, 520)
    $tabControl.Font = New-Object System.Drawing.Font($script:FontFamily, 10, [System.Drawing.FontStyle]::Bold)
    $form.Controls.Add($tabControl)

    # ── TAB: Installa App ─────────────────────────────────────
    $tabInstall = New-Object System.Windows.Forms.TabPage
    $tabInstall.Text = "  Installa App  "
    $tabInstall.BackColor = $script:Colors.BgPanel
    $tabControl.TabPages.Add($tabInstall)

    # Category filter buttons
    $categories = @("Tutti") + ($script:AppCatalog | ForEach-Object { $_[2] } | Sort-Object -Unique)
    $catPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $catPanel.Location = New-Object System.Drawing.Point(10, 5)
    $catPanel.Size = New-Object System.Drawing.Size(1040, 35)
    $catPanel.FlowDirection = "LeftToRight"
    $catPanel.BackColor = $script:Colors.BgPanel
    $tabInstall.Controls.Add($catPanel)

    $appPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $appPanel.Location = New-Object System.Drawing.Point(10, 45)
    $appPanel.Size = New-Object System.Drawing.Size(1040, 400)
    $appPanel.AutoScroll = $true
    $appPanel.FlowDirection = "LeftToRight"
    $appPanel.BackColor = $script:Colors.BgPanel
    $tabInstall.Controls.Add($appPanel)

    $script:AppCheckboxes = @{}

    function Populate-Apps {
        param([string]$Filter = "Tutti")
        $appPanel.Controls.Clear()
        $script:AppCheckboxes.Clear()
        foreach ($app in $script:AppCatalog) {
            if ($Filter -ne "Tutti" -and $app[2] -ne $Filter) { continue }
            $cb = New-Object System.Windows.Forms.CheckBox
            $cb.Text = $app[0]
            $cb.Tag = $app[1]
            $cb.Size = New-Object System.Drawing.Size(200, 28)
            $cb.ForeColor = $script:Colors.TextPrimary
            $cb.Font = New-Object System.Drawing.Font($script:FontFamily, 9.5)
            $cb.Margin = New-Object System.Windows.Forms.Padding(5, 3, 5, 3)
            $appPanel.Controls.Add($cb)
            $script:AppCheckboxes[$app[1]] = $cb
        }
    }

    foreach ($cat in $categories) {
        $btn = New-Object System.Windows.Forms.Button
        $btn.Text = $cat
        $btn.Size = New-Object System.Drawing.Size(110, 28)
        $btn.FlatStyle = "Flat"
        $btn.ForeColor = $script:Colors.TextPrimary
        $btn.BackColor = $script:Colors.BgCard
        $btn.Font = New-Object System.Drawing.Font($script:FontFamily, 8.5)
        $btn.FlatAppearance.BorderColor = $script:Colors.Border
        $btn.Tag = $cat
        $btn.Add_Click({ Populate-Apps -Filter $this.Tag })
        $catPanel.Controls.Add($btn)
    }

    # Preset buttons
    $presetPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $presetPanel.Location = New-Object System.Drawing.Point(10, 450)
    $presetPanel.Size = New-Object System.Drawing.Size(1040, 40)
    $presetPanel.FlowDirection = "LeftToRight"
    $presetPanel.BackColor = $script:Colors.BgPanel
    $tabInstall.Controls.Add($presetPanel)

    # Sam's preset
    $btnSamPreset = New-Object System.Windows.Forms.Button
    $btnSamPreset.Text = "⚡ Preset Sam"
    $btnSamPreset.Size = New-Object System.Drawing.Size(140, 32)
    $btnSamPreset.FlatStyle = "Flat"
    $btnSamPreset.ForeColor = $script:Colors.BgDark
    $btnSamPreset.BackColor = $script:Colors.Accent
    $btnSamPreset.Font = New-Object System.Drawing.Font($script:FontFamily, 9, [System.Drawing.FontStyle]::Bold)
    $btnSamPreset.Add_Click({
        $samApps = @("Brave.Brave","AnyDeskSoftware.AnyDesk","Valve.Steam","Rockstar.Launcher",
                     "Nvidia.NvidiaApp","VideoLAN.VLC","Discord.Discord","7zip.7zip",
                     "Spotify.Spotify","qBittorrent.qBittorrent","EpicGames.EpicGamesLauncher")
        foreach ($key in $script:AppCheckboxes.Keys) {
            $script:AppCheckboxes[$key].Checked = $samApps -contains $key
        }
    })
    $presetPanel.Controls.Add($btnSamPreset)

    $btnSelectAll = New-Object System.Windows.Forms.Button
    $btnSelectAll.Text = "Seleziona Tutti"
    $btnSelectAll.Size = New-Object System.Drawing.Size(130, 32)
    $btnSelectAll.FlatStyle = "Flat"
    $btnSelectAll.ForeColor = $script:Colors.TextPrimary
    $btnSelectAll.BackColor = $script:Colors.BgCard
    $btnSelectAll.Add_Click({ foreach ($cb in $script:AppCheckboxes.Values) { $cb.Checked = $true } })
    $presetPanel.Controls.Add($btnSelectAll)

    $btnDeselectAll = New-Object System.Windows.Forms.Button
    $btnDeselectAll.Text = "Deseleziona"
    $btnDeselectAll.Size = New-Object System.Drawing.Size(130, 32)
    $btnDeselectAll.FlatStyle = "Flat"
    $btnDeselectAll.ForeColor = $script:Colors.TextPrimary
    $btnDeselectAll.BackColor = $script:Colors.BgCard
    $btnDeselectAll.Add_Click({ foreach ($cb in $script:AppCheckboxes.Values) { $cb.Checked = $false } })
    $presetPanel.Controls.Add($btnDeselectAll)

    Populate-Apps

    # ── TAB: Tweaks ───────────────────────────────────────────
    $tabTweaks = New-Object System.Windows.Forms.TabPage
    $tabTweaks.Text = "  Tweaks  "
    $tabTweaks.BackColor = $script:Colors.BgPanel
    $tabControl.TabPages.Add($tabTweaks)

    $tweakPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $tweakPanel.Location = New-Object System.Drawing.Point(10, 10)
    $tweakPanel.Size = New-Object System.Drawing.Size(1040, 430)
    $tweakPanel.AutoScroll = $true
    $tweakPanel.FlowDirection = "LeftToRight"
    $tweakPanel.BackColor = $script:Colors.BgPanel
    $tabTweaks.Controls.Add($tweakPanel)

    $script:TweakCheckboxes = @()
    $currentCategory = ""
    foreach ($tweak in $script:TweaksCatalog) {
        if ($tweak[1] -ne $currentCategory) {
            $currentCategory = $tweak[1]
            $catLabel = New-Object System.Windows.Forms.Label
            $catLabel.Text = "── $currentCategory ──"
            $catLabel.Font = New-Object System.Drawing.Font($script:FontFamily, 10, [System.Drawing.FontStyle]::Bold)
            $catLabel.ForeColor = $script:Colors.Accent
            $catLabel.Size = New-Object System.Drawing.Size(1020, 25)
            $catLabel.Margin = New-Object System.Windows.Forms.Padding(5, 8, 5, 2)
            $tweakPanel.Controls.Add($catLabel)
        }
        $cb = New-Object System.Windows.Forms.CheckBox
        $cb.Text = $tweak[0]
        $cb.Tag = $tweak[2]
        $cb.Size = New-Object System.Drawing.Size(330, 24)
        $cb.ForeColor = $script:Colors.TextPrimary
        $cb.Font = New-Object System.Drawing.Font($script:FontFamily, 9.5)
        $cb.Margin = New-Object System.Windows.Forms.Padding(5, 2, 5, 2)
        $tweakPanel.Controls.Add($cb)
        $script:TweakCheckboxes += $cb
    }

    # Tweak preset buttons
    $tweakBtnPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $tweakBtnPanel.Location = New-Object System.Drawing.Point(10, 450)
    $tweakBtnPanel.Size = New-Object System.Drawing.Size(1040, 40)
    $tweakBtnPanel.FlowDirection = "LeftToRight"
    $tweakBtnPanel.BackColor = $script:Colors.BgPanel
    $tabTweaks.Controls.Add($tweakBtnPanel)

    $btnAllTweaks = New-Object System.Windows.Forms.Button
    $btnAllTweaks.Text = "⚡ Tutti Consigliati"
    $btnAllTweaks.Size = New-Object System.Drawing.Size(160, 32)
    $btnAllTweaks.FlatStyle = "Flat"
    $btnAllTweaks.ForeColor = $script:Colors.BgDark
    $btnAllTweaks.BackColor = $script:Colors.Accent
    $btnAllTweaks.Font = New-Object System.Drawing.Font($script:FontFamily, 9, [System.Drawing.FontStyle]::Bold)
    $btnAllTweaks.Add_Click({ foreach ($cb in $script:TweakCheckboxes) { $cb.Checked = $true } })
    $tweakBtnPanel.Controls.Add($btnAllTweaks)

    $btnClearTweaks = New-Object System.Windows.Forms.Button
    $btnClearTweaks.Text = "Deseleziona"
    $btnClearTweaks.Size = New-Object System.Drawing.Size(130, 32)
    $btnClearTweaks.FlatStyle = "Flat"
    $btnClearTweaks.ForeColor = $script:Colors.TextPrimary
    $btnClearTweaks.BackColor = $script:Colors.BgCard
    $btnClearTweaks.Add_Click({ foreach ($cb in $script:TweakCheckboxes) { $cb.Checked = $false } })
    $tweakBtnPanel.Controls.Add($btnClearTweaks)

    # ── TAB: Bloatware ────────────────────────────────────────
    $tabBloat = New-Object System.Windows.Forms.TabPage
    $tabBloat.Text = "  Rimuovi Bloatware  "
    $tabBloat.BackColor = $script:Colors.BgPanel
    $tabControl.TabPages.Add($tabBloat)

    $bloatPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $bloatPanel.Location = New-Object System.Drawing.Point(10, 10)
    $bloatPanel.Size = New-Object System.Drawing.Size(1040, 430)
    $bloatPanel.AutoScroll = $true
    $bloatPanel.FlowDirection = "LeftToRight"
    $bloatPanel.BackColor = $script:Colors.BgPanel
    $tabBloat.Controls.Add($bloatPanel)

    $script:BloatCheckboxes = @()
    foreach ($pkg in $script:BloatwareList) {
        $displayName = $pkg -replace "Microsoft\.", "" -replace "Clipchamp\.", ""
        $cb = New-Object System.Windows.Forms.CheckBox
        $cb.Text = $displayName
        $cb.Tag = $pkg
        $cb.Size = New-Object System.Drawing.Size(250, 24)
        $cb.ForeColor = $script:Colors.TextPrimary
        $cb.Font = New-Object System.Drawing.Font($script:FontFamily, 9.5)
        $cb.Margin = New-Object System.Windows.Forms.Padding(5, 2, 5, 2)
        $bloatPanel.Controls.Add($cb)
        $script:BloatCheckboxes += $cb
    }

    $bloatBtnPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $bloatBtnPanel.Location = New-Object System.Drawing.Point(10, 450)
    $bloatBtnPanel.Size = New-Object System.Drawing.Size(1040, 40)
    $bloatBtnPanel.FlowDirection = "LeftToRight"
    $bloatBtnPanel.BackColor = $script:Colors.BgPanel
    $tabBloat.Controls.Add($bloatBtnPanel)

    $btnAllBloat = New-Object System.Windows.Forms.Button
    $btnAllBloat.Text = "⚡ Seleziona Tutti"
    $btnAllBloat.Size = New-Object System.Drawing.Size(160, 32)
    $btnAllBloat.FlatStyle = "Flat"
    $btnAllBloat.ForeColor = $script:Colors.BgDark
    $btnAllBloat.BackColor = $script:Colors.Warning
    $btnAllBloat.Font = New-Object System.Drawing.Font($script:FontFamily, 9, [System.Drawing.FontStyle]::Bold)
    $btnAllBloat.Add_Click({ foreach ($cb in $script:BloatCheckboxes) { $cb.Checked = $true } })
    $bloatBtnPanel.Controls.Add($btnAllBloat)

    $btnClearBloat = New-Object System.Windows.Forms.Button
    $btnClearBloat.Text = "Deseleziona"
    $btnClearBloat.Size = New-Object System.Drawing.Size(130, 32)
    $btnClearBloat.FlatStyle = "Flat"
    $btnClearBloat.ForeColor = $script:Colors.TextPrimary
    $btnClearBloat.BackColor = $script:Colors.BgCard
    $btnClearBloat.Add_Click({ foreach ($cb in $script:BloatCheckboxes) { $cb.Checked = $false } })
    $bloatBtnPanel.Controls.Add($btnClearBloat)

    # ── TAB: Updates ──────────────────────────────────────────
    $tabUpdates = New-Object System.Windows.Forms.TabPage
    $tabUpdates.Text = "  Windows Update  "
    $tabUpdates.BackColor = $script:Colors.BgPanel
    $tabControl.TabPages.Add($tabUpdates)

    $updLabel = New-Object System.Windows.Forms.Label
    $updLabel.Text = "Profili Windows Update — scegli come ricevere gli aggiornamenti."
    $updLabel.Font = New-Object System.Drawing.Font($script:FontFamily, 11)
    $updLabel.ForeColor = $script:Colors.TextPrimary
    $updLabel.Location = New-Object System.Drawing.Point(20, 20)
    $updLabel.AutoSize = $true
    $tabUpdates.Controls.Add($updLabel)

    # Recommended
    $grpRec = New-Object System.Windows.Forms.GroupBox
    $grpRec.Text = "Consigliato"
    $grpRec.ForeColor = $script:Colors.Success
    $grpRec.Font = New-Object System.Drawing.Font($script:FontFamily, 10, [System.Drawing.FontStyle]::Bold)
    $grpRec.Location = New-Object System.Drawing.Point(20, 60)
    $grpRec.Size = New-Object System.Drawing.Size(320, 200)
    $tabUpdates.Controls.Add($grpRec)

    $recDesc = New-Object System.Windows.Forms.Label
    $recDesc.Text = "• Ritarda feature update 365 giorni`n• Ritarda quality update 4 giorni`n• Esclude driver da quality update`n• Blocca riavvii automatici`n`nDisponibile su Pro, Enterprise, Education."
    $recDesc.Font = New-Object System.Drawing.Font($script:FontFamily, 9)
    $recDesc.ForeColor = $script:Colors.TextPrimary
    $recDesc.Location = New-Object System.Drawing.Point(10, 25)
    $recDesc.Size = New-Object System.Drawing.Size(300, 120)
    $grpRec.Controls.Add($recDesc)

    $btnApplyRec = New-Object System.Windows.Forms.Button
    $btnApplyRec.Text = "Applica Consigliato"
    $btnApplyRec.Size = New-Object System.Drawing.Size(180, 35)
    $btnApplyRec.Location = New-Object System.Drawing.Point(70, 155)
    $btnApplyRec.FlatStyle = "Flat"
    $btnApplyRec.ForeColor = $script:Colors.BgDark
    $btnApplyRec.BackColor = $script:Colors.Success
    $btnApplyRec.Font = New-Object System.Drawing.Font($script:FontFamily, 9, [System.Drawing.FontStyle]::Bold)
    $btnApplyRec.Add_Click({
        Write-Log "Applicazione profilo aggiornamenti: Consigliato..."
        $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
        if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        Set-ItemProperty -Path $path -Name "DeferFeatureUpdates" -Value 1 -Type DWord -Force
        Set-ItemProperty -Path $path -Name "DeferFeatureUpdatesPeriodInDays" -Value 365 -Type DWord -Force
        Set-ItemProperty -Path $path -Name "DeferQualityUpdates" -Value 1 -Type DWord -Force
        Set-ItemProperty -Path $path -Name "DeferQualityUpdatesPeriodInDays" -Value 4 -Type DWord -Force
        Set-ItemProperty -Path $path -Name "ExcludeWUDriversInQualityUpdate" -Value 1 -Type DWord -Force
        $auPath = "$path\AU"
        if (!(Test-Path $auPath)) { New-Item -Path $auPath -Force | Out-Null }
        Set-ItemProperty -Path $auPath -Name "NoAutoRebootWithLoggedOnUsers" -Value 1 -Type DWord -Force
        Write-Log "Profilo Consigliato applicato." "OK"
    })
    $grpRec.Controls.Add($btnApplyRec)

    # Default
    $grpDef = New-Object System.Windows.Forms.GroupBox
    $grpDef.Text = "Ripristina Default"
    $grpDef.ForeColor = $script:Colors.TextPrimary
    $grpDef.Font = New-Object System.Drawing.Font($script:FontFamily, 10, [System.Drawing.FontStyle]::Bold)
    $grpDef.Location = New-Object System.Drawing.Point(360, 60)
    $grpDef.Size = New-Object System.Drawing.Size(320, 200)
    $tabUpdates.Controls.Add($grpDef)

    $defDesc = New-Object System.Windows.Forms.Label
    $defDesc.Text = "• Rimuove policy di Windows Update`n• Ripristina servizi di update`n• Riabilita task schedulati`n`nUsa per annullare le modifiche."
    $defDesc.Font = New-Object System.Drawing.Font($script:FontFamily, 9)
    $defDesc.ForeColor = $script:Colors.TextPrimary
    $defDesc.Location = New-Object System.Drawing.Point(10, 25)
    $defDesc.Size = New-Object System.Drawing.Size(300, 100)
    $grpDef.Controls.Add($defDesc)

    $btnApplyDef = New-Object System.Windows.Forms.Button
    $btnApplyDef.Text = "Ripristina Default"
    $btnApplyDef.Size = New-Object System.Drawing.Size(180, 35)
    $btnApplyDef.Location = New-Object System.Drawing.Point(70, 155)
    $btnApplyDef.FlatStyle = "Flat"
    $btnApplyDef.ForeColor = $script:Colors.TextPrimary
    $btnApplyDef.BackColor = $script:Colors.BgCard
    $btnApplyDef.Font = New-Object System.Drawing.Font($script:FontFamily, 9, [System.Drawing.FontStyle]::Bold)
    $btnApplyDef.Add_Click({
        Write-Log "Ripristino impostazioni Windows Update default..."
        Remove-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Recurse -Force -ErrorAction SilentlyContinue
        Get-Service wuauserv -ErrorAction SilentlyContinue | Set-Service -StartupType Automatic -PassThru | Start-Service
        Write-Log "Windows Update ripristinato a default." "OK"
    })
    $grpDef.Controls.Add($btnApplyDef)

    # Disable
    $grpDis = New-Object System.Windows.Forms.GroupBox
    $grpDis.Text = "Disabilita Update"
    $grpDis.ForeColor = $script:Colors.Danger
    $grpDis.Font = New-Object System.Drawing.Font($script:FontFamily, 10, [System.Drawing.FontStyle]::Bold)
    $grpDis.Location = New-Object System.Drawing.Point(700, 60)
    $grpDis.Size = New-Object System.Drawing.Size(320, 200)
    $tabUpdates.Controls.Add($grpDis)

    $disDesc = New-Object System.Windows.Forms.Label
    $disDesc.Text = "⚠ Solo per utenti avanzati!`n`n• Disabilita policy di auto-update`n• Ferma servizi e task schedulati`n• Cancella file update scaricati`n`nNessun aggiornamento di sicurezza!"
    $disDesc.Font = New-Object System.Drawing.Font($script:FontFamily, 9)
    $disDesc.ForeColor = $script:Colors.TextPrimary
    $disDesc.Location = New-Object System.Drawing.Point(10, 25)
    $disDesc.Size = New-Object System.Drawing.Size(300, 120)
    $grpDis.Controls.Add($disDesc)

    $btnDisable = New-Object System.Windows.Forms.Button
    $btnDisable.Text = "Disabilita Update"
    $btnDisable.Size = New-Object System.Drawing.Size(180, 35)
    $btnDisable.Location = New-Object System.Drawing.Point(70, 155)
    $btnDisable.FlatStyle = "Flat"
    $btnDisable.ForeColor = [System.Drawing.Color]::White
    $btnDisable.BackColor = $script:Colors.Danger
    $btnDisable.Font = New-Object System.Drawing.Font($script:FontFamily, 9, [System.Drawing.FontStyle]::Bold)
    $btnDisable.Add_Click({
        $confirm = [System.Windows.Forms.MessageBox]::Show(
            "Sei sicuro? Nessun aggiornamento di sicurezza verrà installato.",
            "Conferma", "YesNo", "Warning")
        if ($confirm -eq "Yes") {
            Write-Log "Disabilitazione Windows Update..."
            $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
            if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
            Set-ItemProperty -Path $path -Name "NoAutoUpdate" -Value 1 -Type DWord -Force
            Get-Service wuauserv -ErrorAction SilentlyContinue | Stop-Service -Force -PassThru | Set-Service -StartupType Disabled
            Get-Service UsoSvc -ErrorAction SilentlyContinue | Stop-Service -Force -PassThru | Set-Service -StartupType Disabled
            Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Log "Windows Update disabilitato." "OK"
        }
    })
    $grpDis.Controls.Add($btnDisable)

    # ── TAB: Sfondo ───────────────────────────────────────────
    $tabWallpaper = New-Object System.Windows.Forms.TabPage
    $tabWallpaper.Text = "  Sfondo  "
    $tabWallpaper.BackColor = $script:Colors.BgPanel
    $tabControl.TabPages.Add($tabWallpaper)

    $wpLabel = New-Object System.Windows.Forms.Label
    $wpLabel.Text = "Imposta sfondo desktop — da file locale o URL."
    $wpLabel.Font = New-Object System.Drawing.Font($script:FontFamily, 11)
    $wpLabel.ForeColor = $script:Colors.TextPrimary
    $wpLabel.Location = New-Object System.Drawing.Point(20, 20)
    $wpLabel.AutoSize = $true
    $tabWallpaper.Controls.Add($wpLabel)

    # File picker
    $wpFileLabel = New-Object System.Windows.Forms.Label
    $wpFileLabel.Text = "File locale:"
    $wpFileLabel.Location = New-Object System.Drawing.Point(20, 70)
    $wpFileLabel.AutoSize = $true
    $wpFileLabel.ForeColor = $script:Colors.TextPrimary
    $tabWallpaper.Controls.Add($wpFileLabel)

    $wpFilePath = New-Object System.Windows.Forms.TextBox
    $wpFilePath.Location = New-Object System.Drawing.Point(120, 68)
    $wpFilePath.Size = New-Object System.Drawing.Size(600, 26)
    $wpFilePath.BackColor = $script:Colors.BgCard
    $wpFilePath.ForeColor = $script:Colors.TextPrimary
    $wpFilePath.Font = New-Object System.Drawing.Font($script:FontFamily, 10)
    $tabWallpaper.Controls.Add($wpFilePath)

    $btnBrowse = New-Object System.Windows.Forms.Button
    $btnBrowse.Text = "Sfoglia..."
    $btnBrowse.Location = New-Object System.Drawing.Point(730, 66)
    $btnBrowse.Size = New-Object System.Drawing.Size(100, 30)
    $btnBrowse.FlatStyle = "Flat"
    $btnBrowse.ForeColor = $script:Colors.TextPrimary
    $btnBrowse.BackColor = $script:Colors.BgCard
    $btnBrowse.Add_Click({
        $ofd = New-Object System.Windows.Forms.OpenFileDialog
        $ofd.Filter = "Immagini|*.jpg;*.jpeg;*.png;*.bmp;*.webp|Tutti|*.*"
        if ($ofd.ShowDialog() -eq "OK") { $wpFilePath.Text = $ofd.FileName }
    })
    $tabWallpaper.Controls.Add($btnBrowse)

    $btnApplyFile = New-Object System.Windows.Forms.Button
    $btnApplyFile.Text = "Imposta da File"
    $btnApplyFile.Location = New-Object System.Drawing.Point(840, 66)
    $btnApplyFile.Size = New-Object System.Drawing.Size(150, 30)
    $btnApplyFile.FlatStyle = "Flat"
    $btnApplyFile.ForeColor = $script:Colors.BgDark
    $btnApplyFile.BackColor = $script:Colors.Accent
    $btnApplyFile.Font = New-Object System.Drawing.Font($script:FontFamily, 9, [System.Drawing.FontStyle]::Bold)
    $btnApplyFile.Add_Click({
        if ($wpFilePath.Text) { Set-WallpaperFromFile -Path $wpFilePath.Text }
    })
    $tabWallpaper.Controls.Add($btnApplyFile)

    # URL
    $wpUrlLabel = New-Object System.Windows.Forms.Label
    $wpUrlLabel.Text = "Da URL:"
    $wpUrlLabel.Location = New-Object System.Drawing.Point(20, 120)
    $wpUrlLabel.AutoSize = $true
    $wpUrlLabel.ForeColor = $script:Colors.TextPrimary
    $tabWallpaper.Controls.Add($wpUrlLabel)

    $wpUrl = New-Object System.Windows.Forms.TextBox
    $wpUrl.Location = New-Object System.Drawing.Point(120, 118)
    $wpUrl.Size = New-Object System.Drawing.Size(600, 26)
    $wpUrl.BackColor = $script:Colors.BgCard
    $wpUrl.ForeColor = $script:Colors.TextPrimary
    $wpUrl.Font = New-Object System.Drawing.Font($script:FontFamily, 10)
    $wpUrl.Text = "https://"
    $tabWallpaper.Controls.Add($wpUrl)

    $btnApplyUrl = New-Object System.Windows.Forms.Button
    $btnApplyUrl.Text = "Imposta da URL"
    $btnApplyUrl.Location = New-Object System.Drawing.Point(730, 116)
    $btnApplyUrl.Size = New-Object System.Drawing.Size(150, 30)
    $btnApplyUrl.FlatStyle = "Flat"
    $btnApplyUrl.ForeColor = $script:Colors.BgDark
    $btnApplyUrl.BackColor = $script:Colors.Accent
    $btnApplyUrl.Font = New-Object System.Drawing.Font($script:FontFamily, 9, [System.Drawing.FontStyle]::Bold)
    $btnApplyUrl.Add_Click({
        if ($wpUrl.Text -and $wpUrl.Text -ne "https://") { Set-WallpaperFromUrl -Url $wpUrl.Text }
    })
    $tabWallpaper.Controls.Add($btnApplyUrl)

    # Wallpaper folder
    $wpFolderLabel = New-Object System.Windows.Forms.Label
    $wpFolderLabel.Text = "Cartella sfondi (imposta random):"
    $wpFolderLabel.Location = New-Object System.Drawing.Point(20, 170)
    $wpFolderLabel.AutoSize = $true
    $wpFolderLabel.ForeColor = $script:Colors.TextPrimary
    $tabWallpaper.Controls.Add($wpFolderLabel)

    $wpFolderPath = New-Object System.Windows.Forms.TextBox
    $wpFolderPath.Location = New-Object System.Drawing.Point(250, 168)
    $wpFolderPath.Size = New-Object System.Drawing.Size(470, 26)
    $wpFolderPath.BackColor = $script:Colors.BgCard
    $wpFolderPath.ForeColor = $script:Colors.TextPrimary
    $wpFolderPath.Font = New-Object System.Drawing.Font($script:FontFamily, 10)
    $tabWallpaper.Controls.Add($wpFolderPath)

    $btnBrowseFolder = New-Object System.Windows.Forms.Button
    $btnBrowseFolder.Text = "Sfoglia..."
    $btnBrowseFolder.Location = New-Object System.Drawing.Point(730, 166)
    $btnBrowseFolder.Size = New-Object System.Drawing.Size(100, 30)
    $btnBrowseFolder.FlatStyle = "Flat"
    $btnBrowseFolder.ForeColor = $script:Colors.TextPrimary
    $btnBrowseFolder.BackColor = $script:Colors.BgCard
    $btnBrowseFolder.Add_Click({
        $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
        if ($fbd.ShowDialog() -eq "OK") { $wpFolderPath.Text = $fbd.SelectedPath }
    })
    $tabWallpaper.Controls.Add($btnBrowseFolder)

    $btnRandomWp = New-Object System.Windows.Forms.Button
    $btnRandomWp.Text = "Random dalla Cartella"
    $btnRandomWp.Location = New-Object System.Drawing.Point(840, 166)
    $btnRandomWp.Size = New-Object System.Drawing.Size(170, 30)
    $btnRandomWp.FlatStyle = "Flat"
    $btnRandomWp.ForeColor = $script:Colors.BgDark
    $btnRandomWp.BackColor = $script:Colors.Success
    $btnRandomWp.Font = New-Object System.Drawing.Font($script:FontFamily, 9, [System.Drawing.FontStyle]::Bold)
    $btnRandomWp.Add_Click({
        if ($wpFolderPath.Text -and (Test-Path $wpFolderPath.Text)) {
            $images = Get-ChildItem $wpFolderPath.Text -File -Include "*.jpg","*.jpeg","*.png","*.bmp" -Recurse
            if ($images.Count -gt 0) {
                $pick = $images | Get-Random
                Set-WallpaperFromFile -Path $pick.FullName
            } else {
                Write-Log "Nessuna immagine trovata nella cartella." "WARN"
            }
        }
    })
    $tabWallpaper.Controls.Add($btnRandomWp)

    # ── LOG BOX (bottom) ──────────────────────────────────────
    $script:LogBox = New-Object System.Windows.Forms.TextBox
    $script:LogBox.Multiline = $true
    $script:LogBox.ScrollBars = "Vertical"
    $script:LogBox.ReadOnly = $true
    $script:LogBox.Location = New-Object System.Drawing.Point(10, 575)
    $script:LogBox.Size = New-Object System.Drawing.Size(1065, 100)
    $script:LogBox.BackColor = [System.Drawing.Color]::FromArgb(12, 12, 16)
    $script:LogBox.ForeColor = $script:Colors.Success
    $script:LogBox.Font = New-Object System.Drawing.Font("Consolas", 9)
    $form.Controls.Add($script:LogBox)

    # ── ACTION BUTTONS (bottom bar) ───────────────────────────
    $btnRun = New-Object System.Windows.Forms.Button
    $btnRun.Text = "⚡ ESEGUI TUTTO"
    $btnRun.Size = New-Object System.Drawing.Size(200, 40)
    $btnRun.Location = New-Object System.Drawing.Point(10, 680)
    $btnRun.FlatStyle = "Flat"
    $btnRun.ForeColor = [System.Drawing.Color]::White
    $btnRun.BackColor = $script:Colors.Accent
    $btnRun.Font = New-Object System.Drawing.Font($script:FontFamily, 12, [System.Drawing.FontStyle]::Bold)
    $btnRun.Add_Click({
        $btnRun.Enabled = $false
        $btnRun.Text = "In esecuzione..."

        # Ensure winget
        if (!(Ensure-Winget)) {
            $btnRun.Text = "⚡ ESEGUI TUTTO"
            $btnRun.Enabled = $true
            return
        }

        # Install selected apps
        $selectedApps = $script:AppCheckboxes.GetEnumerator() | Where-Object { $_.Value.Checked }
        foreach ($app in $selectedApps) {
            Install-AppViaWinget -Name $app.Value.Text -Id $app.Key
        }

        # Apply selected tweaks
        foreach ($cb in $script:TweakCheckboxes) {
            if ($cb.Checked) {
                Write-Log "Tweak: $($cb.Text)..."
                try {
                    & $cb.Tag
                    Write-Log "Tweak '$($cb.Text)' applicato." "OK"
                } catch {
                    Write-Log "Tweak '$($cb.Text)' fallito: $($_.Exception.Message)" "ERROR"
                }
            }
        }

        # Remove selected bloatware
        foreach ($cb in $script:BloatCheckboxes) {
            if ($cb.Checked) {
                Write-Log "Rimozione bloatware: $($cb.Text)..."
                try {
                    Get-AppxPackage -Name $cb.Tag -AllUsers -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
                    Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object { $_.PackageName -like "*$($cb.Tag)*" } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
                    Write-Log "Rimosso: $($cb.Text)" "OK"
                } catch {
                    Write-Log "Errore rimozione $($cb.Text): $($_.Exception.Message)" "ERROR"
                }
            }
        }

        Write-Log "════════════════════════════════════════" "INFO"
        Write-Log "OPERAZIONI COMPLETATE! Riavvia per applicare tutto." "OK"
        $btnRun.Text = "⚡ ESEGUI TUTTO"
        $btnRun.Enabled = $true
    })
    $form.Controls.Add($btnRun)

    # Restart button
    $btnRestart = New-Object System.Windows.Forms.Button
    $btnRestart.Text = "Riavvia PC"
    $btnRestart.Size = New-Object System.Drawing.Size(130, 40)
    $btnRestart.Location = New-Object System.Drawing.Point(220, 680)
    $btnRestart.FlatStyle = "Flat"
    $btnRestart.ForeColor = [System.Drawing.Color]::White
    $btnRestart.BackColor = $script:Colors.Warning
    $btnRestart.Font = New-Object System.Drawing.Font($script:FontFamily, 10, [System.Drawing.FontStyle]::Bold)
    $btnRestart.Add_Click({
        $confirm = [System.Windows.Forms.MessageBox]::Show("Riavviare il PC adesso?", "Riavvio", "YesNo", "Question")
        if ($confirm -eq "Yes") { Restart-Computer -Force }
    })
    $form.Controls.Add($btnRestart)

    # WinUtil button
    $btnWinUtil = New-Object System.Windows.Forms.Button
    $btnWinUtil.Text = "Apri WinUtil (CTT)"
    $btnWinUtil.Size = New-Object System.Drawing.Size(170, 40)
    $btnWinUtil.Location = New-Object System.Drawing.Point(360, 680)
    $btnWinUtil.FlatStyle = "Flat"
    $btnWinUtil.ForeColor = $script:Colors.TextPrimary
    $btnWinUtil.BackColor = $script:Colors.BgCard
    $btnWinUtil.Font = New-Object System.Drawing.Font($script:FontFamily, 9, [System.Drawing.FontStyle]::Bold)
    $btnWinUtil.Add_Click({
        Start-Process powershell -ArgumentList '-NoProfile -Command "irm https://christitus.com/win | iex"' -Verb RunAs
    })
    $form.Controls.Add($btnWinUtil)

    Write-Log "Sam's Toolbox v1.0 avviato. Seleziona e premi ESEGUI TUTTO."

    $form.ShowDialog() | Out-Null
}

# ══════════════════════════════════════════════════════════════
#  LAUNCH
# ══════════════════════════════════════════════════════════════
Build-MainForm
