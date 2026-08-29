# Sam's Windows Toolbox v1.0

Toolbox post-installazione Windows con GUI — app, tweaks, bloatware removal, wallpaper, Windows Update.

## Esecuzione Locale

```
click destro su RunSamToolbox.bat → Esegui come amministratore
```

Oppure da PowerShell (admin):
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\SamToolbox.ps1
```

## Esecuzione Remota (stile CTT WinUtil)

Carica `SamToolbox.ps1` su un hosting (GitHub raw, tuo server, ecc), poi:

```powershell
irm "https://tuodominio.com/SamToolbox.ps1" | iex
```

### Hosting su GitHub (gratis)

1. Crea repo su GitHub
2. Carica `SamToolbox.ps1`
3. Prendi il link RAW del file
4. Usa: `irm "https://raw.githubusercontent.com/TUOUSER/TUOREPO/main/SamToolbox.ps1" | iex`

### Hosting su tuo server

1. Carica il file `.ps1` sul tuo webserver
2. Assicurati che il MIME type sia `text/plain`
3. Usa: `irm "https://tuodominio.com/SamToolbox.ps1" | iex`

## Integrazione con Windows ISO Custom

Per integrare nella tua ISO Windows X Lite:

1. Copia `SamToolbox.ps1` e `RunSamToolbox.bat` dentro la ISO in `$OEM$\$$\Setup\Scripts\`
2. Crea `SetupComplete.cmd` nella stessa cartella:

```batch
@echo off
powershell -ExecutionPolicy Bypass -File "%WINDIR%\Setup\Scripts\SamToolbox.ps1"
```

Oppure post-install manuale:
1. Installa Windows da chiavetta
2. Apri PowerShell come admin
3. `irm "TUO_URL" | iex`

## Personalizzazione

### Aggiungere app
Nel blocco `$script:AppCatalog`, aggiungi:
```powershell
@("Nome App", "winget.id.app", "Categoria")
```

Per trovare l'ID winget: `winget search "nome app"`

### Aggiungere tweaks
Nel blocco `$script:TweaksCatalog`, aggiungi:
```powershell
@("Nome Tweak", "Categoria", {
    # codice PowerShell del tweak
})
```

### Preset Sam
Modifica la lista `$samApps` nel click handler del bottone "Preset Sam" con i winget ID delle tue app preferite.
