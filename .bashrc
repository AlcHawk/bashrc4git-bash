## Color setting
COLOR_BLACK="\033[0;30m"
COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[0;33m"
COLOR_BLUE="\033[0;34m"
COLOR_PURPLE="\033[0;35m"
COLOR_CYAN="\033[0;36m"
COLOR_WHITE="\033[0;37m"
COLOR_DARKGRAY="\033[1;30m"
COLOR_LRED="\033[1;31m"
COLOR_LGREEN="\033[1;32m"
COLOR_LYELLOW="\033[1;33m"
COLOR_LBLUE="\033[1;34m"
COLOR_LPURPLE="\033[1;35m"
COLOR_LCYAN="\033[1;36m"
COLOR_LWHITE="\033[1;37m"
COLOR_OCHRE="\033[38;5;95m"
COLOR_RESET="\033[0m"

## Git setting
alias gtst='git status'
alias gtbr='git branch'
alias gtckut='git checkout'
alias gtckutbr='git checkout -b'
alias gtcfg='git config'
alias gtadd='git add'
alias gtaddA='git add -A'
alias gtctm='git commit -m'
alias gtres='git reset'
alias gtresH='git reset HEAD'
alias gtlog='git log'
GIT_PS1_SHOWDIRTYSTATE='yes'
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="auto git"

# function set_git_prompt {
#     PS1="\[\033]0;$MSYSTEM:${PWD//[^[:ascii:]]/?}\007\]\n\[\033[32m\]\u@\h \[\033[33m\]\W \[$COLOR_RESET\]$(_gt_head_)\[\033[35m\]$(_gt_br_)\[$COLOR_DARKGRAY\]$(_gt_lrepo_)\[$COLOR_BLUE\]$(_gt_lahead_)\[$COLOR_RED\]$(_gt_lbehind_)\[$COLOR_RESET\]$(_gt_bar_)\[$COLOR_YELLOW\]$(_gt_clr_)\[$COLOR_LGREEN\]$(_gt_stg_)\[$COLOR_LRED\]$(_gt_chg_not_)\[$COLOR_WHITE\]$(_gt_untrack_)\[$COLOR_RESET\]$(_gt_tail_)\n$ "
# }
# PROMPT_COMMAND=set_git_prompt

function _gt_br_ {  local isgitrepo=$(git status 2>&1 | grep 'Not a git repository' | wc -l) 
                    if [ "$isgitrepo" -eq "0" ]; then
                        if [ "$(git status 2>&1 | grep 'HEAD detach' | wc -l)" -ne "1" ]; then
                            echo $(git status 2>&1 | grep 'On branch' | cut -d ' ' -f3)
                        else
                            echo ":"$(git status 2>&1 | grep 'HEAD detached' | cut -d ' ' -f4)
                        fi
                    fi; }

function _gt_head_ {    local isgitrepo=$(git status 2>&1 | grep 'Not a git repository' | wc -l) 
                        if [ "$isgitrepo" -eq "0" ]; then  
                            echo "("; fi;}

function _gt_tail_ {    local isgitrepo=$(git status 2>&1 | grep 'Not a git repository' | wc -l) 
                        if [ "$isgitrepo" -eq "0" ]; then  
                            echo ")"; fi;}

function _gt_lrepo_ {   local isgitrepo=$(git status 2>&1 | grep 'Not a git repository' | wc -l) 
                        if [ "$isgitrepo" -eq "0" ] && [ "$(git status | grep 'up-to-date\|ahead\|behind' | wc -l)" -eq "0" ] ; then  
                            echo " L"; fi;}

function _gt_lahead_ {  local isgitrepo=$(git status 2>&1 | grep 'Not a git repository' | wc -l) 
                        if [ "$isgitrepo" -eq "0" ] && [ "$(git status | grep 'ahead' | wc -l)" -eq "1" ] ; then  
                            echo "↑"$(gtst | grep 'ahead' | awk '{print $8}'); fi;}

function _gt_lbehind_ { local isgitrepo=$(git status 2>&1 | grep 'Not a git repository' | wc -l) 
                        if [ "$isgitrepo" -eq "0" ] && [ "$(git status | grep 'behind' | wc -l)" -eq "1" ] ; then  
                            echo "↓"$(gtst | grep 'behind' | awk '{print $8}'); fi;}

function _gt_bar_ { local isgitrepo=$(git status 2>&1 | grep 'Not a git repository' | wc -l) 
                    if [ "$isgitrepo" -eq "0" ] ; then  
                        echo "|"; fi;}

function _gt_clr_ { local isgitrepo=$(git status 2>&1 | grep 'Not a git repository' | wc -l) 
                    if [ "$isgitrepo" -eq "0" ] && [ $(git status | grep 'working directory clean' | wc -l) -eq "1" ] ; then  
                        echo "✔"; fi;}

function _gt_stg_ { local isgitrepo=$(git status 2>&1 | grep 'Not a git repository' | wc -l) 
                    if [ "$isgitrepo" -eq "0" ] ; then
                        local line_num_chg_not_cmt=$(git status | awk '/Changes not staged for commit/{print NR;}')
                        if [ "$line_num_chg_not_cmt" == "" ]; then
                            line_num_chg_not_cmt="$(git status | wc -l)"
                        else
                            line_num_chg_not_cmt="$line_num_chg_not_cmt"
                        fi
                        local keep_part="1,$(($line_num_chg_not_cmt))p"
                        local gtl_stg=$(git status | sed -n "$keep_part" | grep 'new file\|modified\|renamed\|deleted' | wc -l | awk '{print $1}')
                        if [ "$gtl_stg" != "0" ]; then
                            echo "●"$gtl_stg
                        fi
                    fi;}

function _gt_chg_not_ { local isgitrepo=$(git status 2>&1 | grep 'Not a git repository' | wc -l) 
                        if [ "$isgitrepo" -eq "0" ] ; then
                            local line_num_chg_not_cmt=$(git status | awk '/Changes not staged for commit/{print NR;}')
                            if [ "$line_num_chg_not_cmt" == "" ]; then
                                line_num_chg_not_cmt="$(git status | wc -l)"
                            else
                                line_num_chg_not_cmt="$line_num_chg_not_cmt"
                            fi
                            local del_part="1,$(($line_num_chg_not_cmt))d"
                            local gtl_chg_not=$(git status | sed "$del_part" | grep 'new file\|modified\|renamed\|deleted' | wc -l | awk '{print $1}')
                            if [ "$gtl_chg_not" != "0" ]; then
                                echo "+"$gtl_chg_not
                            fi
                        fi;}

function _gt_untrack_ { local isgitrepo=$(git status 2>&1 | grep 'Not a git repository' | wc -l) 
                        if [ "$isgitrepo" -eq "0" ] ; then
                            local gtl_untrack=$(git status -s | grep '??' | wc -l)
                            if [ "$gtl_untrack" -ne "0" ]; then
                                echo "…"$gtl_untrack
                            fi
                        fi;}


