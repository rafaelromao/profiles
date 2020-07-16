# Install-Module posh-git -Scope CurrentUser
# Install-Module oh-my-posh -Scope CurrentUser
# Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck

Import-Module posh-git
Import-Module oh-my-posh
Set-Theme ParadoxRomao

# https://github.com/PowerShell/PSReadLine
. ./PSReadLineProfile.ps1

clear