# Install-Module posh-git -Scope CurrentUser
# Install-Module oh-my-posh -Scope CurrentUser
# Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck

if (-Not (Get-Module -Name posh-git -ListAvailable)) {
    Import-Module posh-git -Force -ErrorAction SilentlyContinue
}
if (-Not (Get-Module -Name oh-my-posh -ListAvailable)) {
    Import-Module oh-my-posh -Force -ErrorAction SilentlyContinue
}
Set-Theme ParadoxRomao -ErrorAction SilentlyContinue

# https://github.com/PowerShell/PSReadLine
. "$(Split-Path $PROFILE)/PSReadLineProfile.ps1" -ErrorAction SilentlyContinue

Set-PSReadLineOption -Colors @{
    "Default" = [ConsoleColor]::DarkYellow;
    "ContinuationPrompt" = [ConsoleColor]::DarkGray;
    "String" = [ConsoleColor]::DarkYellow;
    "Command" = [ConsoleColor]::DarkGreen;
    "Parameter" = [ConsoleColor]::DarkCyan;
    "Number" = [ConsoleColor]::White;
    "Error" = [ConsoleColor]::Red;
    "Comment" = [ConsoleColor]::DarkGray;
    "Operator" = [ConsoleColor]::DarkCyan;
    "Keyword" = [ConsoleColor]::DarkYellow;
    "Emphasis" = [ConsoleColor]::Magenta;
    "Selection" = [ConsoleColor]::DarkGray;
    "Variable" = [ConsoleColor]::Green;
    "Type" = [ConsoleColor]::DarkCyan;
    "Member" = [ConsoleColor]::Green;
}

$PROFILE_DIR = $(Split-Path $PROFILE)