# Oh-My-Zsh Theme Complement
# 2020 July
# https://github.com/rafaelromao/profiles
#
# Credits for the base work to:
# https://github.com/zakaziko99/agnosterzak-ohmyzsh-theme
# https://github.com/JanDeDobbeleer/oh-my-posh/blob/master/Themes/Paradox.psm1
# https://github.com/lyze/posh-git-sh

__posh_git_echo () {
    if [ "$(git config --bool bash.enableGitStatus)" = 'false' ]; then
        return;
    fi

    local Red='\033[0;31m'
    local Green='\033[0;32m'
    local BrightRed='\033[0;91m'
    local BrightGreen='\033[0;92m'
    local BrightYellow='\033[0;93m'
    local BrightCyan='\033[0;96m'

    local DefaultForegroundColor=
    local DefaultBackgroundColor=

    local BeforeText='['
    local BeforeForegroundColor=
    local BeforeBackgroundColor=
    local DelimText=' |'
    local DelimForegroundColor=
    local DelimBackgroundColor=

    local AfterText=']'
    local AfterForegroundColor=
    local AfterBackgroundColor=

    local BranchForegroundColor=
    local BranchBackgroundColor=
    local BranchAheadForegroundColor=
    local BranchAheadBackgroundColor=
    local BranchBehindForegroundColor=
    local BranchBehindBackgroundColor=
    local BranchBehindAndAheadForegroundColor=
    local BranchBehindAndAheadBackgroundColor=

    local BeforeIndexText=''
    local BeforeIndexForegroundColor=
    local BeforeIndexBackgroundColor=

    local IndexForegroundColor=
    local IndexBackgroundColor=

    local WorkingForegroundColor=
    local WorkingBackgroundColor=

    local StashForegroundColor=
    local StashBackgroundColor=
    local BeforeStash='('
    local AfterStash=')'

    local RebaseForegroundColor=
    local RebaseBackgroundColor=

    local BranchBehindAndAheadDisplay=`git config --get bash.branchBehindAndAheadDisplay`
    if [ -z "$BranchBehindAndAheadDisplay" ]; then
        BranchBehindAndAheadDisplay="full"
    fi

    local EnableFileStatus=`git config --bool bash.enableFileStatus`
    case "$EnableFileStatus" in
        true)  EnableFileStatus=true ;;
        false) EnableFileStatus=false ;;
        *)     EnableFileStatus=true ;;
    esac
    local ShowStatusWhenZero=`git config --bool bash.showStatusWhenZero`
    case "$ShowStatusWhenZero" in
        true)  ShowStatusWhenZero=true ;;
        false) ShowStatusWhenZero=false ;;
        *)     ShowStatusWhenZero=false ;;
    esac
    local EnableStashStatus=`git config --bool bash.enableStashStatus`
    case "$EnableStashStatus" in
        true)  EnableStashStatus=true ;;
        false) EnableStashStatus=false ;;
        *)     EnableStashStatus=true ;;
    esac
    local EnableStatusSymbol=`git config --bool bash.enableStatusSymbol`
    case "$EnableStatusSymbol" in
        true)  EnableStatusSymbol=true ;;
        false) EnableStatusSymbol=false ;;
        *)     EnableStatusSymbol=true ;;
    esac

    local BranchIdenticalStatusSymbol=''
    local BranchAheadStatusSymbol=''
    local BranchBehindStatusSymbol=''
    local BranchBehindAndAheadStatusSymbol=''
    local BranchWarningStatusSymbol=''
    if $EnableStatusSymbol; then
      BranchIdenticalStatusSymbol=$' ≣' # Three horizontal lines
      BranchAheadStatusSymbol=$' \xE2\x86\x91' # Up Arrow
      BranchBehindStatusSymbol=$' \xE2\x86\x93' # Down Arrow
      BranchBehindAndAheadStatusSymbol=$'\xE2\x86\x95' # Up and Down Arrow
      BranchWarningStatusSymbol=' ≢'
    fi

    # these globals are updated by __posh_git_ps1_upstream_divergence
    __POSH_BRANCH_AHEAD_BY=0
    __POSH_BRANCH_BEHIND_BY=0

    local is_detached=false

    local g=$(__posh_gitdir)
    if [ -z "$g" ]; then
        return # not a git directory
    fi
    local rebase=''
    local b=''
    local step=''
    local total=''
    if [ -d "$g/rebase-merge" ]; then
        b=$(cat "$g/rebase-merge/head-name" 2>/dev/null)
        step=$(cat "$g/rebase-merge/msgnum" 2>/dev/null)
        total=$(cat "$g/rebase-merge/end" 2>/dev/null)
        if [ -f "$g/rebase-merge/interactive" ]; then
            rebase='|REBASE-i'
        else
            rebase='|REBASE-m'
        fi
    else
        if [ -d "$g/rebase-apply" ]; then
            step=$(cat "$g/rebase-apply/next")
            total=$(cat "$g/rebase-apply/last")
            if [ -f "$g/rebase-apply/rebasing" ]; then
                rebase='|REBASE'
            elif [ -f "$g/rebase-apply/applying" ]; then
                rebase='|AM'
            else
                rebase='|AM/REBASE'
            fi
        elif [ -f "$g/MERGE_HEAD" ]; then
            rebase='|MERGING'
        elif [ -f "$g/CHERRY_PICK_HEAD" ]; then
            rebase='|CHERRY-PICKING'
        elif [ -f "$g/REVERT_HEAD" ]; then
            rebase='|REVERTING'
        elif [ -f "$g/BISECT_LOG" ]; then
            rebase='|BISECTING'
        fi

        b=$(git symbolic-ref HEAD 2>/dev/null) || {
            is_detached=true
            local output=$(git config -z --get bash.describeStyle)
            if [ -n "$output" ]; then
                GIT_PS1_DESCRIBESTYLE=$output
            fi
            b=$(
            case "${GIT_PS1_DESCRIBESTYLE-}" in
            (contains)
                git describe --contains HEAD ;;
            (branch)
                git describe --contains --all HEAD ;;
            (describe)
                git describe HEAD ;;
            (* | default)
                git describe --tags --exact-match HEAD ;;
            esac 2>/dev/null) ||

            b=$(cut -c1-7 "$g/HEAD" 2>/dev/null)... ||
            b='unknown'
            b="($b)"
        }
    fi

    # if [ -n "$step" ] && [ -n "$total" ]; then
    #     rebase="$rebase $step/$total"
    # fi

    local hasStash=false
    local stashCount=0
    local isBare=''

    if [ 'true' = "$(git rev-parse --is-inside-git-dir 2>/dev/null)" ]; then
        if [ 'true' = "$(git rev-parse --is-bare-repository 2>/dev/null)" ]; then
            isBare='BARE:'
        else
            b='GIT_DIR!'
        fi
    elif [ 'true' = "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
        if $EnableStashStatus; then
            git rev-parse --verify refs/stash >/dev/null 2>&1 && hasStash=true
            if $hasStash; then
                stashCount=$(git stash list | wc -l | tr -d '[:space:]')
            fi
        fi
        __posh_git_ps1_upstream_divergence
        local divergence_return_code=$?
    fi

    # show index status and working directory status
    if $EnableFileStatus; then
        local indexAdded=0
        local indexModified=0
        local indexDeleted=0
        local indexUnmerged=0
        local filesAdded=0
        local filesModified=0
        local filesDeleted=0
        local filesUnmerged=0
        while IFS="\n" read -r tag rest
        do
            case "${tag:0:1}" in
                A )
                    (( indexAdded++ ))
                    ;;
                M )
                    (( indexModified++ ))
                    ;;
                T )
                    (( indexModified++ ))
                    ;;
                R )
                    (( indexModified++ ))
                    ;;
                C )
                    (( indexModified++ ))
                    ;;
                D )
                    (( indexDeleted++ ))
                    ;;
                U )
                    (( indexUnmerged++ ))
                    ;;
            esac
            case "${tag:1:1}" in
                \? )
                    (( filesAdded++ ))
                    ;;
                A )
                    (( filesAdded++ ))
                    ;;
                M )
                    (( filesModified++ ))
                    ;;
                T )
                    (( filesModified++ ))
                    ;;
                D )
                    (( filesDeleted++ ))
                    ;;
                U )
                    (( filesUnmerged++ ))
                    ;;
            esac
        done <<< "`git status --porcelain 2>/dev/null`"
    fi

    local gitstring=
    local branchstring="$isBare${b##refs/heads/}"

    # before-branch text
    # gitstring="$BeforeBackgroundColor$BeforeForegroundColor$BeforeText"

    branchstring+="${rebase:+$RebaseForegroundColor$RebaseBackgroundColor$rebase}"

    # branch
    if (( $__POSH_BRANCH_BEHIND_BY > 0 && $__POSH_BRANCH_AHEAD_BY > 0 )); then
        gitstring+="$BranchBehindAndAheadBackgroundColor$BranchBehindAndAheadForegroundColor$branchstring"
        if [ "$BranchBehindAndAheadDisplay" = "full" ]; then
            gitstring+="$BranchBehindStatusSymbol$__POSH_BRANCH_BEHIND_BY$BranchAheadStatusSymbol$__POSH_BRANCH_AHEAD_BY"
        elif [ "$BranchBehindAndAheadDisplay" = "compact" ]; then
            gitstring+=" $__POSH_BRANCH_BEHIND_BY$BranchBehindAndAheadStatusSymbol$__POSH_BRANCH_AHEAD_BY"
        else
            gitstring+=" $BranchBehindAndAheadStatusSymbol"
        fi
    elif (( $__POSH_BRANCH_BEHIND_BY > 0 )); then
        gitstring+="$BranchBehindBackgroundColor$BranchBehindForegroundColor$branchstring"
        if [ "$BranchBehindAndAheadDisplay" = "full" -o "$BranchBehindAndAheadDisplay" = "compact" ]; then
            gitstring+="$BranchBehindStatusSymbol$__POSH_BRANCH_BEHIND_BY"
        else
            gitstring+="$BranchBehindStatusSymbol"
        fi
    elif (( $__POSH_BRANCH_AHEAD_BY > 0 )); then
        gitstring+="$BranchAheadBackgroundColor$BranchAheadForegroundColor$branchstring"
        if [ "$BranchBehindAndAheadDisplay" = "full" -o "$BranchBehindAndAheadDisplay" = "compact" ]; then
            gitstring+="$BranchAheadStatusSymbol$__POSH_BRANCH_AHEAD_BY"
        else
            gitstring+="$BranchAheadStatusSymbol"
        fi
    elif (( $divergence_return_code )); then
        # ahead and behind are both 0, but there was some problem while executing the command.
        gitstring+="$BranchBackgroundColor$BranchForegroundColor$branchstring$BranchWarningStatusSymbol"
    else
        # ahead and behind are both 0, and the divergence was determined successfully
        gitstring+="$BranchBackgroundColor$BranchForegroundColor$branchstring$BranchIdenticalStatusSymbol"
    fi

    # index status
    if $EnableFileStatus; then
        local indexCount="$(( $indexAdded + $indexModified + $indexDeleted + $indexUnmerged ))"
        local workingCount="$(( $filesAdded + $filesModified + $filesDeleted + $filesUnmerged ))"
        if (( $indexCount != 0 )) || $ShowStatusWhenZero; then
            gitstring+="$IndexBackgroundColor$IndexForegroundColor +$indexAdded ~$indexModified -$indexDeleted"
        fi
        if (( $indexUnmerged != 0 )); then
            gitstring+=" $IndexBackgroundColor$IndexForegroundColor!$indexUnmerged"
        fi
        if (( $indexCount != 0 && ($workingCount != 0 || $ShowStatusWhenZero) )); then
            gitstring+="$DelimBackgroundColor$DelimForegroundColor$DelimText"
        fi
        if (( $workingCount != 0 )) || $ShowStatusWhenZero; then
            gitstring+="$WorkingBackgroundColor$WorkingForegroundColor +$filesAdded ~$filesModified -$filesDeleted"
        fi
        if (( $workingCount != 0 || $filesUnmerged != 0 )); then
            gitstring+=" $WorkingBackgroundColor$WorkingForegroundColor!"
            if (($filesUnmerged != 0 )); then
                gitstring+="$filesUnmerged"
            fi
        else
            if [ -z "$(git status --porcelain)" ]; then 
            else
                gitstring+=" ~"
            fi
        fi
    fi

    if $EnableStashStatus && $hasStash; then
        gitstring+="$DefaultBackgroundColor$DefaultForegroundColor $StashBackgroundColor$StashForegroundColor$BeforeStash$stashCount$AfterStash"
    fi

    # after-branch text
    # gitstring+="$AfterBackgroundColor$AfterForegroundColor$AfterText"
    gitstring+="$DefaultBackgroundColor$DefaultForegroundColor"
    echo "$gitstring"
}

# Returns the location of the .git/ directory.
__posh_gitdir ()
{
    # Note: this function is duplicated in git-completion.bash
    # When updating it, make sure you update the other one to match.
    if [ -z "${1-}" ]; then
        if [ -n "${__posh_git_dir-}" ]; then
            echo "$__posh_git_dir"
        elif [ -n "${GIT_DIR-}" ]; then
            test -d "${GIT_DIR-}" || return 1
            echo "$GIT_DIR"
        elif [ -d .git ]; then
            echo .git
        else
            git rev-parse --git-dir 2>/dev/null
        fi
    elif [ -d "$1/.git" ]; then
        echo "$1/.git"
    else
        echo "$1"
    fi
}

# Updates the global variables `__POSH_BRANCH_AHEAD_BY` and `__POSH_BRANCH_BEHIND_BY`.
__posh_git_ps1_upstream_divergence ()
{
    local key value
    local svn_remote svn_url_pattern
    local upstream=git          # default
    local legacy=''

    svn_remote=()
    # get some config options from git-config
    local output="$(git config -z --get-regexp '^(svn-remote\..*\.url|bash\.showUpstream)$' 2>/dev/null | tr '\0\n' '\n ')"
    while read -r key value; do
        case "$key" in
        bash.showUpstream)
            GIT_PS1_SHOWUPSTREAM="$value"
            if [ -z "${GIT_PS1_SHOWUPSTREAM}" ]; then
                return
            fi
            ;;
        svn-remote.*.url)
            svn_remote[ $((${#svn_remote[@]} + 1)) ]="$value"
            svn_url_pattern+="\\|$value"
            upstream=svn+git # default upstream is SVN if available, else git
            ;;
        esac
    done <<< "$output"

    # parse configuration values
    for option in ${GIT_PS1_SHOWUPSTREAM}; do
        case "$option" in
        git|svn) upstream="$option" ;;
        legacy)  legacy=1  ;;
        esac
    done

    # Find our upstream
    case "$upstream" in
    git)    upstream='@{upstream}' ;;
    svn*)
        # get the upstream from the "git-svn-id: ..." in a commit message
        # (git-svn uses essentially the same procedure internally)
        local svn_upstream=($(git log --first-parent -1 \
                    --grep="^git-svn-id: \(${svn_url_pattern#??}\)" 2>/dev/null))
        if (( 0 != ${#svn_upstream[@]} )); then
            svn_upstream=${svn_upstream[ ${#svn_upstream[@]} - 2 ]}
            svn_upstream=${svn_upstream%@*}
            local n_stop="${#svn_remote[@]}"
            local n
            for ((n=1; n <= n_stop; n++)); do
                svn_upstream=${svn_upstream#${svn_remote[$n]}}
            done

            if [ -z "$svn_upstream" ]; then
                # default branch name for checkouts with no layout:
                upstream=${GIT_SVN_ID:-git-svn}
            else
                upstream=${svn_upstream#/}
            fi
        elif [ 'svn+git' = "$upstream" ]; then
            upstream='@{upstream}'
        fi
        ;;
    esac

    local return_code=
    __POSH_BRANCH_AHEAD_BY=0
    __POSH_BRANCH_BEHIND_BY=0
    # Find how many commits we are ahead/behind our upstream
    if [ -z "$legacy" ]; then
        local output=
        output=$(git rev-list --count --left-right $upstream...HEAD 2>/dev/null)
        return_code=$?
        IFS=$' \t\n' read -r __POSH_BRANCH_BEHIND_BY __POSH_BRANCH_AHEAD_BY <<< $output
    else
        local output
        output=$(git rev-list --left-right $upstream...HEAD 2>/dev/null)
        return_code=$?
        # produce equivalent output to --count for older versions of git
        while IFS=$' \t\n' read -r commit; do
            case "$commit" in
            "<*") (( __POSH_BRANCH_BEHIND_BY++ )) ;;
            ">*") (( __POSH_BRANCH_AHEAD_BY++ ))  ;;
            esac
        done <<< $output
    fi
    : ${__POSH_BRANCH_AHEAD_BY:=0}
    : ${__POSH_BRANCH_BEHIND_BY:=0}
    return $return_code
}
