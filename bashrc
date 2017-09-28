# !/bin/bash

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# If PS1 isn't set, we're not in a shell
if [ -z "$PS1" ]; then
   return
fi

# Sets the terminal to use 256 color
TERM=xterm-256color

# Prettier Bash Prompt
source ~/config/git-prompt.sh
source ~/config/colors.sh

function __set_ps1() {
  load_ps1_bright_colors
  local status=`(( $? == 0 )) && echo $PS1_G || echo $PS1_R`
  PS1="${status}\u@${PS1_C}\h${PS1_Y}:\w${PS1_B}`__git_ps1`${PS1_Y}\$ ${PS1_0}"
}

export PROMPT_COMMAND=__set_ps1

# Add own scripts located in ~/bin to the path
export PATH=$PATH:$HOME/bin

# Source my aliases
source ~/config/aliases.sh

# Changes into the corresponding cse directory
# e.g. cs 333 -> cd ~/cse333
function cs {
  cd ~/cse$1
}

# Lists out the top ten things taking up disk space in given path
function space {
  arg=$1
  if [ -z "$1" ]; then
     arg="$PWD"
  fi
  echo "what IS taking up space in $arg?"
  du -hs $arg/* | sort -hr | head
}

# Run this on a Linux lab machine with headphones!!
function vader {
  espeak -v mb-en1 "Obee-Wan never told you what happened to your father." ; 
  espeak "He told me enough! He told me you killed him!";
  espeak -v mb-en1 "No, I, am your father"
}

# For the cd command, only complete with directories
complete -d cd


#### VIM Aliases for opening language specific vim settings ####
function vi-snip {
  if [[ $# -ne 1 ]]; then
    echo "what language??"
    return
  fi
  vi ~/.vim/bundle/snipmate.vim/snippets/$1.snippets
}

function vi-colo {
  if [[ $# -ne 1 ]]; then
    echo "what colorscheme??"
    return
  fi
  vi ~/.vim/colors/$1.vim
}

function vi-syntax {
  if [[ $# -ne 1 ]]; then
    echo "what language??"
    return
  fi
  vi ~/.vim/syntax/$1.vim
}


#### 333 Specific Functions and Aliases ####
source ~/config/333.sh
