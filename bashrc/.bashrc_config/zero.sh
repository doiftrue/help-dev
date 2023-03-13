# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

BASHRC_DIR=~/.bashrc_config

source $BASHRC_DIR/_functions-custom.sh
source $BASHRC_DIR/_commands-history.sh
source $BASHRC_DIR/_settings.sh
source $BASHRC_DIR/prompt/_zero.sh

if [ -f $BASHRC_DIR/_aliases.sh ]; then
    source $BASHRC_DIR/_aliases.sh
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi


