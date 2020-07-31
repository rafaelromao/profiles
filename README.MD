# Powershell

OS: Mac OS, Linux, Windows 10

- follow https://github.com/rafaelromao/profiles/tree/zsh (Mac OS, Linux)
- follow https://github.com/rafaelromao/profiles/tree/WindowsTerminal (Windows 10)
- `brew cask install powershell` ([Mac OS](https://docs.microsoft.com/pt-br/powershell/scripting/install/installing-powershell-core-on-macos?view=powershell-7))
- `sudo apt-get install powershell` ([Ubuntu](https://docs.microsoft.com/pt-br/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7))
- `winget install --id Microsoft.PowerShell --exact` ([Windows 10](https://docs.microsoft.com/pt-br/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7))
- `pwsh`
- `cd $(Split-Path $PROFILE)`
- `Install-Module Posh-Git -Force`
- `Install-Module Oh-My-Posh -Force`
- `Install-Module PSReadLine -Force`
- `git init`
- `git remote add origin git@github.com:rafaelromao/profiles.git`
- `git fetch`
- `git checkout -f powershell`
- `. $PROFILE`
- follow https://github.com/rafaelromao/profiles/tree/iTerm2

![](pretty-prompt.PNG?raw=true)
