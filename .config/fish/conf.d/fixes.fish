function __fish_complete_bash
    set cmd (commandline -cp)
    bash -c "source $HOME/.config/fish/conf.d/load_bash_completions.sh; get_completions '$cmd'"
end

# Set the tool to use bash completions
complete -xc dnf -a '(__fish_complete_bash)'
