[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
# [[ -n $PS1 && -f ~/.bash_prompt ]] && source ~/.bash_prompt && ps1_dark_theme
[[ "$(command -v zoxide)" ]] && eval "$(zoxide init bash)"

export EDITOR=nvim

source $HOME/.aliases
. "$HOME/.cargo/env"
