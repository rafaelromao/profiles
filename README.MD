# zsh

OS: Mac OS, Linux

- install powerline fonts https://github.com/powerline/fonts
- install firacode fonts https://github.com/tonsky/FiraCode
- `brew install zsh-syntax-highlighting` ([Mac OS](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md))
- `sudo apt-get zsh-syntax-highlighting` ([Ubuntu](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md))
- `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- `cd $ZSH`
- `rm -rf .git`
- `cd ~`
- `git clone https://github.com/zdharma/fast-syntax-highlighting fsh`
- `rm -rf fsh/.git`
- `git init`
- `git remote add origin git@github.com:rafaelromao/profiles.git`
- `git fetch`
- `git checkout -f zsh`
- `source ~/.zshrc`
- follow https://github.com/rafaelromao/profiles/tree/powershell

![](.oh-my-zsh/pretty-prompt.png?raw=true)

