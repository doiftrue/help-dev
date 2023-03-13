# Adds git info to prompt shell

# @see https://unix.stackexchange.com/questions/124407/what-color-codes-can-i-use-in-my-bash-ps1-prompt

__change_my_prompt() {
  local exitCode="$?" # This needs to be first

  # Regular
  local Black="\[\033[0;30m\]"
  local Red="\[\033[0;31m\]"
  local Green="\[\033[0;32m\]"
  local Yellow="\[\033[0;33m\]"
  local Blue="\[\033[0;34m\]"
  local Purple="\[\033[0;35m\]"
  local Cyan="\[\033[0;36m\]"
  local White="\[\033[0;37m\]"
  # Bold
  local bBlack="\[\033[1;30m\]"
  local bRed="\[\033[1;31m\]"
  local bGreen="\[\033[01;32m\]"
  local bYellow="\[\033[1;33m\]"
  local bBlue="\[\033[1;34m\]"
  local bPurple="\[\033[1;35m\]"
  local bCyan="\[\033[1;36m\]"
  local bWhite="\[\033[1;37m\]"
  # Reset
  local CN="\[\033[00m\]"

  # colour branch name depending on state
  local _gitBranch="$(__git_ps1 "(%s)")"
  local _gitColor="$Green"
  if   [[ "$_gitBranch" =~ "*" ]]; then _gitColor="$Red"    # if repository is dirty
  elif [[ "$_gitBranch" =~ "+" ]]; then _gitColor="$Red"    # if there are staged files
  elif [[ "$_gitBranch" =~ "$" ]]; then _gitColor="$Yellow" # if there is something stashed
  elif [[ "$_gitBranch" =~ "%" ]]; then _gitColor="$Purple" # if there are only untracked files
  fi

  local _user="$bPurple\u"   # \u@\h - user & host
  local _location="$bBlue\w" # capital 'W': current directory, small 'w': full file path

  if [ $exitCode != 0 ]; then
      exitCodeStr=" $Red[$exitCode]$CN"
  else
      exitCodeStr=""
  fi

  # Build the PS1 (Prompt String)
  PS1="$_user:$_location$_gitColor$_gitBranch$CN${exitCodeStr} \$ "
}

# if .git-prompt.sh exists, set options and execute it
GIT_PS1_SHOWDIRTYSTATE=false
GIT_PS1_SHOWSTASHSTATE=false
GIT_PS1_SHOWUNTRACKEDFILES=false
GIT_PS1_SHOWUPSTREAM=false
GIT_PS1_HIDE_IF_PWD_IGNORED=false
GIT_PS1_SHOWCOLORHINTS=false # we set it myself
GIT_PS1_STATESEPARATOR=''

source "$BASHRC_DIR"/prompt/_git-prompt.sh


# configure PROMPT_COMMAND which is executed each time before PS1
export PROMPT_COMMAND=__change_my_prompt

