# Oh-My-Zsh Theme
# 2020 July
# https://github.com/rafaelromao/profiles
#
# Credits for the base work to:
# https://github.com/zakaziko99/agnosterzak-ohmyzsh-theme
# https://github.com/JanDeDobbeleer/oh-my-posh/blob/master/Themes/Paradox.psm1
# https://github.com/lyze/posh-git-sh

CURRENT_BG='NONE'

# Characters
SEGMENT_SEPARATOR="\ue0b0"
BRANCH="\ue0a0"
CROSS="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2699"

# Posh-Git reference colors

# VirtualEnvForegroundColor="White"
# PromptHighlightColor"DarkBlue"
# DriveForegroundColor"DarkBlue"
# PromptSymbolColor"White"
# AdminIconForegroundColor"DarkYellow"
# PathBackgroundColor"DarkCyan"
# CommandFailedIconForegroundColor="DarkRed"
# SessionInfoForegroundColor"White"
# WithBackgroundColor"Magenta"
# SessionInfoBackgroundColor"Black"
# VirtualEnvBackgroundColor"Red"
# WithForegroundColor"DarkRed"
# PromptForegroundColor"White"
# PromptBackgroundColor"DarkBlue"

# GitLocalChangesColor"DarkYellow"
# GitNoLocalChangesAndAheadAndBehindColor="DarkRed"
# GitForegroundColor"White"
# GitDefaultColor"DarkGreen"
# GitNoLocalChangesAndBehindColor="DarkRed"
# GitNoLocalChangesAndAheadColor="DarkMagenta"

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    print -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    print -n "%{$bg%}%{$fg%}"
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && print -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    print -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    print -n "%{%k%}"
  fi
  print -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  if [[ -n "$SSH_CLIENT" ]]; then
    prompt_segment red white "%{$fg_bold[white]%(!.%{%F{white}%}.)%}$USER@%m%{$fg_no_bold[white]%}"
  else
    prompt_segment "#073642" white "%{$fg[white]%(!.%{%F{white}%}.)%}$USER@%m%{$fg_no_bold[white]%}"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    git_status=$(git status --porcelain 2> /dev/null)
    if [[ -n $dirty ]]; then
      bgclr='yellow'
      fgclr='white'
    else
      bgclr='green'
      fgclr='white'
    fi

    local number_of_untracked_files=$(\grep -c "^??" <<< "${git_status}")
    local number_added=$(\grep -c "^A" <<< "${git_status}")
    local number_modified=$(\grep -c "^.M" <<< "${git_status}")
    local number_added_modified=$(\grep -c "^M" <<< "${git_status}")
    local number_added_renamed=$(\grep -c "^R" <<< "${git_status}")
    local number_deleted=$(\grep -c "^.D" <<< "${git_status}")
    local number_added_deleted=$(\grep -c "^D" <<< "${git_status}")
    local number_of_stashes="$(git stash list -n1 2> /dev/null | wc -l)"
    local upstream=$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2> /dev/null)
    
    if [[ -n "${upstream}" && "${upstream}" != "@{upstream}" ]]; then
      has_upstream=true; 
    fi
    
    if [[ $has_upstream == true ]]; then
      local current_commit_hash=$(git rev-parse HEAD 2> /dev/null)
      commits_diff="$(git log --pretty=oneline --topo-order --left-right ${current_commit_hash}...${upstream} 2> /dev/null)"
      commits_ahead=$(\grep -c "^<" <<< "$commits_diff")
      commits_behind=$(\grep -c "^>" <<< "$commits_diff")
    fi

    if [[ $commits_ahead -gt 0 ]]; then
      bgclr='magenta'
      fgclr='white'
    fi

    if [[ $commits_behind -gt 0 ]]; then
      bgclr='red'
      fgclr='white'
    fi

    if [[ $number_of_untracked_files -gt 0 ]]; then 
      bgclr='yellow'
      fgclr='white'
    fi

    if [[ $number_added -gt 0 ]]; then 
      bgclr='yellow'
      fgclr='white'
    fi

    if [[ $number_modified -gt 0 ]]; then
      bgclr='yellow'
      fgclr='white'
    fi

    if [[ $number_added_renamed -gt 0 ]]; then 
      bgclr='yellow'
      fgclr='white'
    fi

    if [[ $number_added_modified -gt 0 ]]; then 
      bgclr='yellow'
      fgclr='white'
    fi

    if [[ $number_deleted -gt 0 ]]; then
      bgclr='red'
      fgclr='white'
    fi

    if [[ $number_added_deleted -gt 0 ]]; then
      bgclr='red'
      fgclr='white'
    fi

    if [[ $number_of_stashes -gt 0 ]]; then
      bgclr='magenta'
      fgclr='white'
    fi

    . $ZSH/themes/git-prompt.sh
    gitstring=$(__posh_git_echo)

    prompt_segment $bgclr $fgclr

    print -n "%{$fg[$fgclr]%}$BRANCH $gitstring%{$fg_no_bold[$fgclr]%}"
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment cyan white "%{$fg[white]%}%~%{$fg_no_bold[white]%}"
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment blue black "(`basename $virtualenv_path`)"
  fi
}

prompt_time() {
  prompt_segment blue white "%{$fg[white]%}%D{%a %e %b - %H:%M}%{$fg_no_bold[white]%}"
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}$CROSS"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}$LIGHTNING"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$GEAR"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_context
  CURRENT_BG='%f'
  prompt_time
  prompt_virtualenv
  prompt_dir
  prompt_git
  prompt_end
  CURRENT_BG='NONE'
  print -n "\n"
  print -n "%{$fg[blue]%}❯%{%f%}%{%k%}"
}

PROMPT='%{%f%b%k%}$(build_prompt) '
