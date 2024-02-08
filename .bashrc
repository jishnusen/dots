[[ $- != *i* ]] && return

[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
[[ "$(command -v zoxide)" ]] && eval "$(zoxide init bash)"

export EDITOR=nvim

. "$HOME/.bash_prompt"
. "$HOME/.aliases"
. "$HOME/.cargo/env"

PATH=$HOME/.local/bin:$PATH
export PATH

LS_COLORS+=':ow=01;33'
export LS_COLORS
