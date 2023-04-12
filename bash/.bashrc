# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Add ~/.local/bin and ~/bin to $PATH
# if they are not already present.
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# If tmux is installed and $PS1 is set (we are in an interactive shell) 
# and $TERM does not contain screen nor tmux and $TMUX is not set then run tmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

unset rc

eval "$(starship init bash)"

export VISUAL=nvim
alias vim=nvim
alias vi=nvim

alias silentchill="mpv https://inv.vern.cc/watch?v=F3t0Turp84g"
alias silentrain="mpv https://inv.vern.cc/watch?v=0hEAiV9MatA"


# Top-level folders
alias dev="cd ~/Developer"
alias personal="cd ~/Developer/Personal"
alias school="cd ~/Developer/School"

# Class specific folders
alias gti320="cd ~/Developer/School/GTI320/"
alias gti611="cd ~/Developer/School/GTI611/"
alias log710="cd ~/Developer/School/LOG710/"

# Usage: gfix file1 file2
# Useful for modifying previous pushed commits quickly without polluting history.
alias gfix='git add $1 && git commit --amend --no-edit && git push -f'
