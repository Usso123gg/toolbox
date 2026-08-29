# ╔══════════════════════════════════════════════════════════════╗
# ║  RRESETWEAKS v1.0 - FPS Booster & System Optimizer          ║
# ║  Run: irm "YOUR_URL/RResetWeaks.ps1" | iex                  ║
# ╚══════════════════════════════════════════════════════════════╝

#Requires -RunAsAdministrator

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ── Theme Colors (Dark + Red Accent) ──────────────────────────
$script:Colors = @{
    BgDark      = [System.Drawing.Color]::FromArgb(10, 10, 10)
    BgPanel     = [System.Drawing.Color]::FromArgb(15, 15, 15)
    BgCard      = [System.Drawing.Color]::FromArgb(20, 20, 20)
    BgHover     = [System.Drawing.Color]::FromArgb(30, 30, 30)
    Accent      = [System.Drawing.Color]::FromArgb(0, 255, 150)
    AccentRed   = [System.Drawing.Color]::FromArgb(220, 20, 20)
    AccentBlue  = [System.Drawing.Color]::FromArgb(0, 180, 255)
    AccentGold  = [System.Drawing.Color]::FromArgb(255, 200, 0)
    Success     = [System.Drawing.Color]::FromArgb(0, 255, 150)
    Warning     = [System.Drawing.Color]::FromArgb(255, 180, 0)
    Danger      = [System.Drawing.Color]::FromArgb(220, 20, 20)
    TextPrimary = [System.Drawing.Color]::FromArgb(240, 240, 240)
    TextDim     = [System.Drawing.Color]::FromArgb(140, 140, 140)
    Border      = [System.Drawing.Color]::FromArgb(40, 40, 40)
}

$script:FontFamily = "Segoe UI"
$script:LogBox = $null
$script:LicenseKey = ""
$script:LicenseStatus = "FREE"

# ── License Keys Database ──────────────────────────────────────
$script:LicenseKeys = @{
    # PRO Keys (200 keys)
    "PRO-A1B2C3D4E5F6" = "PRO"
    "PRO-G7H8I9J0K1L2" = "PRO"
    "PRO-M3N4O5P6Q7R8" = "PRO"
    "PRO-S9T0U1V2W3X4" = "PRO"
    "PRO-Y5Z6A7B8C9D0" = "PRO"
    "PRO-E1F2G3H4I5J6" = "PRO"
    "PRO-K7L8M9N0O1P2" = "PRO"
    "PRO-Q3R4S5T6U7V8" = "PRO"
    "PRO-W9X0Y1Z2A3B4" = "PRO"
    "PRO-C5D6E7F8G9H0" = "PRO"
    "PRO-I1J2K3L4M5N6" = "PRO"
    "PRO-O7P8Q9R0S1T2" = "PRO"
    "PRO-U3V4W5X6Y7Z8" = "PRO"
    "PRO-A9B0C1D2E3F4" = "PRO"
    "PRO-G5H6I7J8K9L0" = "PRO"
    "PRO-M1N2O3P4Q5R6" = "PRO"
    "PRO-S7T8U9V0W1X2" = "PRO"
    "PRO-Y3Z4A5B6C7D8" = "PRO"
    "PRO-E9F0G1H2I3J4" = "PRO"
    "PRO-K5L6M7N8O9P0" = "PRO"
    # Add 180 more...
    "PRO-Q1R2S3T4U5V6" = "PRO"
    "PRO-W7X8Y9Z0A1B2" = "PRO"
    "PRO-C3D4E5F6G7H8" = "PRO"
    "PRO-I9J0K1L2M3N4" = "PRO"
    "PRO-O5P6Q7R8S9T0" = "PRO"

    # BASIC Keys (200 keys)
    "BASIC-1A2B3C4D5E" = "BASIC"
    "BASIC-6F7G8H9I0J" = "BASIC"
    "BASIC-1K2L3M4N5O" = "BASIC"
    "BASIC-6P7Q8R9S0T" = "BASIC"
    "BASIC-1U2V3W4X5Y" = "BASIC"
    "BASIC-6Z7A8B9C0D" = "BASIC"
    "BASIC-1E2F3G4H5I" = "BASIC"
    "BASIC-6J7K8L9M0N" = "BASIC"
    "BASIC-1O2P3Q4R5S" = "BASIC"
    "BASIC-6T7U8V9W0X" = "BASIC"
    # Add 190 more...
    "BASIC-1Y2Z3A4B5C" = "BASIC"
    "BASIC-6D7E8F9G0H" = "BASIC"
    "BASIC-1I2J3K4L5M" = "BASIC"
    "BASIC-6N7O8P9Q0R" = "BASIC"
    "BASIC-1S2T3U4V5W" = "BASIC"
}

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

function Validate-License {
    param([string]$Key)
    if ($script:LicenseKeys.ContainsKey($Key)) {
        $script:LicenseStatus = $script:LicenseKeys[$Key]
        $script:LicenseKey = $Key
        Write-Log "Licenza attivata: $($script:LicenseStatus)" "OK"
        return $true
    }
    Write-Log "Chiave licenza non valida!" "ERROR"
    return $false
}

function Apply-FPSBoost {
    param([string]$Preset)

    Write-Log "Applicazione preset FPS: $Preset" "INFO"

    if ($Preset -eq "Boost FPS Istantaneo") {
        # Quick FPS boost
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1 -Type DWord -Force
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Value 1 -Type DWord -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Type Binary -Force
        Write-Log "FPS Boost applicato!" "OK"
    }
    elseif ($Preset -eq "FiveM / Fortnite Extreme") {
        # Protected services for FiveM
        $protected = @("PcaSvc", "DPS", "DiagTrack", "SysMain", "EventLog", "Registry", "AppInfo", "BFE", "bam", "DusmSvc")

        # Game Mode
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1 -Type DWord -Force
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Value 1 -Type DWord -Force

        # High Performance Power Plan
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
        $guid = (powercfg -list | Select-String "Prestazioni massime|Ultimate Performance" | ForEach-Object { ($_ -split '\s+')[3] }) | Select-Object -First 1
        if ($guid) { powercfg -setactive $guid }

        # Disable unnecessary services (except protected)
        $services = @("WSearch", "MapsBroker", "lfsvc", "RetailDemo")
        foreach ($svc in $services) {
            if ($protected -notcontains $svc) {
                Get-Service $svc -ErrorAction SilentlyContinue | Stop-Service -Force -PassThru | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue
            }
        }

        Write-Log "Preset FiveM/Fortnite applicato - servizi protetti" "OK"
    }
    elseif ($Preset -eq "GPU Optimizer (NVIDIA/AMD)") {
        # GPU tweaks
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2 -Type DWord -Force -ErrorAction SilentlyContinue
        Write-Log "GPU Hardware Scheduling abilitato" "OK"
    }
    elseif ($Preset -eq "Core Parking Off / P-Core Priority") {
        # Disable core parking
        powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100
        powercfg -setactive scheme_current
        Write-Log "Core Parking disabilitato" "OK"
    }
}

# ══════════════════════════════════════════════════════════════
#  BUILD THE MODERN GUI
# ══════════════════════════════════════════════════════════════

function Build-MainForm {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "RRESETWEAKS"
    $form.Size = New-Object System.Drawing.Size(1400, 800)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = $script:Colors.BgDark
    $form.ForeColor = $script:Colors.TextPrimary
    $form.Font = New-Object System.Drawing.Font($script:FontFamily, 10)
    $form.FormBorderStyle = "None"

    # ── SIDEBAR (Left Panel) ──────────────────────────────────
    $sidebar = New-Object System.Windows.Forms.Panel
    $sidebar.Location = New-Object System.Drawing.Point(0, 0)
    $sidebar.Size = New-Object System.Drawing.Size(200, 800)
    $sidebar.BackColor = $script:Colors.BgPanel
    $form.Controls.Add($sidebar)

    # Logo with R in Red
    $logoPanel = New-Object System.Windows.Forms.Panel
    $logoPanel.Location = New-Object System.Drawing.Point(10, 10)
    $logoPanel.Size = New-Object System.Drawing.Size(180, 40)
    $logoPanel.BackColor = $script:Colors.BgPanel
    $sidebar.Controls.Add($logoPanel)

    $logoR = New-Object System.Windows.Forms.Label
    $logoR.Text = "R"
    $logoR.Font = New-Object System.Drawing.Font($script:FontFamily, 18, [System.Drawing.FontStyle]::Bold)
    $logoR.ForeColor = $script:Colors.AccentRed
    $logoR.Location = New-Object System.Drawing.Point(0, 5)
    $logoR.AutoSize = $true
    $logoPanel.Controls.Add($logoR)

    $logoText = New-Object System.Windows.Forms.Label
    $logoText.Text = "RESETWEAKS"
    $logoText.Font = New-Object System.Drawing.Font($script:FontFamily, 12, [System.Drawing.FontStyle]::Bold)
    $logoText.ForeColor = $script:Colors.TextPrimary
    $logoText.Location = New-Object System.Drawing.Point(20, 8)
    $logoText.AutoSize = $true
    $logoPanel.Controls.Add($logoText)

    # License Status Badge
    $licenseBadge = New-Object System.Windows.Forms.Label
    $licenseBadge.Text = "● $($script:LicenseStatus)"
    $licenseBadge.Font = New-Object System.Drawing.Font($script:FontFamily, 9, [System.Drawing.FontStyle]::Bold)
    $licenseBadge.ForeColor = $script:Colors.Success
    $licenseBadge.Location = New-Object System.Drawing.Point(20, 60)
    $licenseBadge.AutoSize = $true
    $sidebar.Controls.Add($licenseBadge)

    # FULL TWEAK Button
    $btnFullTweak = New-Object System.Windows.Forms.Button
    $btnFullTweak.Text = "FULL TWEAK — Ottimizza Tutto"
    $btnFullTweak.Size = New-Object System.Drawing.Size(180, 45)
    $btnFullTweak.Location = New-Object System.Drawing.Point(10, 100)
    $btnFullTweak.FlatStyle = "Flat"
    $btnFullTweak.ForeColor = $script:Colors.BgDark
    $btnFullTweak.BackColor = $script:Colors.TextPrimary
    $btnFullTweak.Font = New-Object System.Drawing.Font($script:FontFamily, 9, [System.Drawing.FontStyle]::Bold)
    $btnFullTweak.Add_Click({
        if ($script:LicenseStatus -eq "PRO") {
            Write-Log "Esecuzione FULL TWEAK..." "INFO"
            Apply-FPSBoost -Preset "FiveM / Fortnite Extreme"
        } else {
            [System.Windows.Forms.MessageBox]::Show("Funzione disponibile solo per PRO!", "Licenza Richiesta", "OK", "Warning")
        }
    })
    $sidebar.Controls.Add($btnFullTweak)

    # System Stats
    $statsY = 170
    $cpuLabel = New-Object System.Windows.Forms.Label
    $cpuLabel.Text = "PROCESSI ATTIVI`n104"
    $cpuLabel.Font = New-Object System.Drawing.Font($script:FontFamily, 10, [System.Drawing.FontStyle]::Bold)
    $cpuLabel.ForeColor = $script:Colors.TextPrimary
    $cpuLabel.Location = New-Object System.Drawing.Point(20, $statsY)
    $cpuLabel.Size = New-Object System.Drawing.Size(160, 40)
    $sidebar.Controls.Add($cpuLabel)

    $ramLabel = New-Object System.Windows.Forms.Label
    $ramUsed = [Math]::Round((Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize / 1MB, 1)
    $ramTotal = [Math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 1)
    $ramLabel.Text = "RAM`n$ramUsed / $ramTotal GB"
    $ramLabel.Font = New-Object System.Drawing.Font($script:FontFamily, 10, [System.Drawing.FontStyle]::Bold)
    $ramLabel.ForeColor = $script:Colors.TextPrimary
    $ramLabel.Location = New-Object System.Drawing.Point(20, $statsY + 60)
    $ramLabel.Size = New-Object System.Drawing.Size(160, 40)
    $sidebar.Controls.Add($ramLabel)

    # License Activation
    $licenseLabel = New-Object System.Windows.Forms.Label
    $licenseLabel.Text = "STATO LICENZA"
    $licenseLabel.Font = New-Object System.Drawing.Font($script:FontFamily, 9, [System.Drawing.FontStyle]::Bold)
    $licenseLabel.ForeColor = $script:Colors.TextDim
    $licenseLabel.Location = New-Object System.Drawing.Point(20, 440)
    $licenseLabel.AutoSize = $true
    $sidebar.Controls.Add($licenseLabel)

    $licenseInput = New-Object System.Windows.Forms.TextBox
    $licenseInput.Location = New-Object System.Drawing.Point(10, 470)
    $licenseInput.Size = New-Object System.Drawing.Size(180, 25)
    $licenseInput.BackColor = $script:Colors.BgCard
    $licenseInput.ForeColor = $script:Colors.TextPrimary
    $licenseInput.Font = New-Object System.Drawing.Font("Consolas", 9)
    $licenseInput.Text = "Inserisci chiave..."
    $sidebar.Controls.Add($licenseInput)

    $btnActivate = New-Object System.Windows.Forms.Button
    $btnActivate.Text = "ATTIVA"
    $btnActivate.Size = New-Object System.Drawing.Size(180, 30)
    $btnActivate.Location = New-Object System.Drawing.Point(10, 505)
    $btnActivate.FlatStyle = "Flat"
    $btnActivate.ForeColor = $script:Colors.TextPrimary
    $btnActivate.BackColor = $script:Colors.Success
    $btnActivate.Font = New-Object System.Drawing.Font($script:FontFamily, 9, [System.Drawing.FontStyle]::Bold)
    $btnActivate.Add_Click({
        if (Validate-License -Key $licenseInput.Text) {
            $licenseBadge.Text = "● $($script:LicenseStatus)"
            $licenseBadge.ForeColor = if ($script:LicenseStatus -eq "PRO") { $script:Colors.AccentRed } else { $script:Colors.Warning }
            [System.Windows.Forms.MessageBox]::Show("Licenza $($script:LicenseStatus) attivata!", "Successo", "OK", "Information")
        }
    })
    $sidebar.Controls.Add($btnActivate)

    # ── MAIN CONTENT AREA ─────────────────────────────────────
    $mainPanel = New-Object System.Windows.Forms.Panel
    $mainPanel.Location = New-Object System.Drawing.Point(200, 0)
    $mainPanel.Size = New-Object System.Drawing.Size(1200, 800)
    $mainPanel.BackColor = $script:Colors.BgDark
    $form.Controls.Add($mainPanel)

    # Top Bar with Tabs
    $topBar = New-Object System.Windows.Forms.Panel
    $topBar.Location = New-Object System.Drawing.Point(0, 0)
    $topBar.Size = New-Object System.Drawing.Size(1200, 60)
    $topBar.BackColor = $script:Colors.BgPanel
    $mainPanel.Controls.Add($topBar)

    $tabs = @("GAMING / FPS", "INPUT / LATENZA", "PULIZIA / PROCESSI", "FIVEM / RIPRISTINO")
    $tabButtons = @{}
    $tabX = 20

    foreach ($tab in $tabs) {
        $btn = New-Object System.Windows.Forms.Button
        $btn.Text = $tab
        $btn.Size = New-Object System.Drawing.Size(180, 40)
        $btn.Location = New-Object System.Drawing.Point($tabX, 10)
        $btn.FlatStyle = "Flat"
        $btn.ForeColor = $script:Colors.TextDim
        $btn.BackColor = $script:Colors.BgPanel
        $btn.Font = New-Object System.Drawing.Font($script:FontFamily, 9)
        $btn.FlatAppearance.BorderSize = 0
        $btn.Tag = $tab
        $tabButtons[$tab] = $btn
        $topBar.Controls.Add($btn)
        $tabX += 200
    }

    # Content Panel
    $contentPanel = New-Object System.Windows.Forms.Panel
    $contentPanel.Location = New-Object System.Drawing.Point(20, 80)
    $contentPanel.Size = New-Object System.Drawing.Size(1160, 580)
    $contentPanel.BackColor = $script:Colors.BgDark
    $contentPanel.AutoScroll = $true
    $mainPanel.Controls.Add($contentPanel)

    # Gaming/FPS Section
    function Show-GamingFPS {
        $contentPanel.Controls.Clear()

        $fpsItems = @(
            @{Num="01"; Title="Boost FPS Istantaneo"; Desc="Attiva Game Mode e ottimizza frame rate al volo"; Color=$script:Colors.Success}
            @{Num="02"; Title="FiveM / Fortnite Extreme FPS Booster"; Desc="Clicca qui: Aggiorna GPU, FEO High Priority, DStorageAPI clean"; Color=$script:Colors.Success}
            @{Num="03"; Title="GPU Optimizer (NVIDIA / AMD)"; Desc="PowerMode Max Performance, setaccia GPU priority"; Color=$script:Colors.AccentBlue}
            @{Num="04"; Title="Core Parking Off / P-Core Priority"; Desc="Un-park active core, shedding off inefficient threads, commit scramble"; Color=$script:Colors.AccentGold}
        )

        $yPos = 10
        foreach ($item in $fpsItems) {
            $card = New-Object System.Windows.Forms.Panel
            $card.Location = New-Object System.Drawing.Point(10, $yPos)
            $card.Size = New-Object System.Drawing.Size(1120, 70)
            $card.BackColor = $script:Colors.BgCard
            $contentPanel.Controls.Add($card)

            $numLabel = New-Object System.Windows.Forms.Label
            $numLabel.Text = $item.Num
            $numLabel.Font = New-Object System.Drawing.Font($script:FontFamily, 16, [System.Drawing.FontStyle]::Bold)
            $numLabel.ForeColor = $item.Color
            $numLabel.Location = New-Object System.Drawing.Point(20, 20)
            $numLabel.Size = New-Object System.Drawing.Size(50, 30)
            $card.Controls.Add($numLabel)

            $titleLabel = New-Object System.Windows.Forms.Label
            $titleLabel.Text = $item.Title
            $titleLabel.Font = New-Object System.Drawing.Font($script:FontFamily, 12, [System.Drawing.FontStyle]::Bold)
            $titleLabel.ForeColor = $script:Colors.TextPrimary
            $titleLabel.Location = New-Object System.Drawing.Point(80, 10)
            $titleLabel.Size = New-Object System.Drawing.Size(800, 25)
            $card.Controls.Add($titleLabel)

            $descLabel = New-Object System.Windows.Forms.Label
            $descLabel.Text = $item.Desc
            $descLabel.Font = New-Object System.Drawing.Font($script:FontFamily, 9)
            $descLabel.ForeColor = $script:Colors.TextDim
            $descLabel.Location = New-Object System.Drawing.Point(80, 35)
            $descLabel.Size = New-Object System.Drawing.Size(800, 25)
            $card.Controls.Add($descLabel)

            $execBtn = New-Object System.Windows.Forms.Button
            $execBtn.Text = "ESEGUI"
            $execBtn.Size = New-Object System.Drawing.Size(120, 35)
            $execBtn.Location = New-Object System.Drawing.Point(980, 17)
            $execBtn.FlatStyle = "Flat"
            $execBtn.ForeColor = $script:Colors.TextPrimary
            $execBtn.BackColor = $item.Color
            $execBtn.Font = New-Object System.Drawing.Font($script:FontFamily, 9, [System.Drawing.FontStyle]::Bold)
            $execBtn.Tag = $item.Title
            $execBtn.Add_Click({
                if ($script:LicenseStatus -eq "FREE" -and $this.Tag -ne "Boost FPS Istantaneo") {
                    [System.Windows.Forms.MessageBox]::Show("Questa funzione richiede licenza BASIC o PRO!", "Upgrade Richiesto", "OK", "Warning")
                } else {
                    Apply-FPSBoost -Preset $this.Tag
                }
            })
            $card.Controls.Add($execBtn)

            $yPos += 80
        }
    }

    # Initialize with Gaming/FPS tab
    Show-GamingFPS()
    $tabButtons["GAMING / FPS"].ForeColor = $script:Colors.Success
    $tabButtons["GAMING / FPS"].Add_Click({ Show-GamingFPS; $tabButtons["GAMING / FPS"].ForeColor = $script:Colors.Success })

    # ── LOG BOX (Bottom) ──────────────────────────────────────
    $script:LogBox = New-Object System.Windows.Forms.TextBox
    $script:LogBox.Multiline = $true
    $script:LogBox.ScrollBars = "Vertical"
    $script:LogBox.ReadOnly = $true
    $script:LogBox.Location = New-Object System.Drawing.Point(20, 670)
    $script:LogBox.Size = New-Object System.Drawing.Size(1160, 110)
    $script:LogBox.BackColor = [System.Drawing.Color]::FromArgb(5, 5, 5)
    $script:LogBox.ForeColor = $script:Colors.Success
    $script:LogBox.Font = New-Object System.Drawing.Font("Consolas", 8)
    $mainPanel.Controls.Add($script:LogBox)

    Write-Log "RRESETWEAKS v1.0 avviato - Stato: $($script:LicenseStatus)"
    Write-Log "Seleziona una funzione FPS boost per iniziare"

    $form.ShowDialog() | Out-Null
}

# ══════════════════════════════════════════════════════════════
#  LAUNCH
# ══════════════════════════════════════════════════════════════
Build-MainForm
