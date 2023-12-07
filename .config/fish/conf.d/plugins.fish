if not functions -q fundle; eval (curl -sfL https://git.io/fundle-install); end

fundle plugin 'edc/bass'
fundle plugin 'tuvistavie/fish-fastdir'
fundle plugin 'jethrokuan/fzf'
fundle plugin 'meaningful-ooo/sponge'
fundle plugin 'jorgebucaran/hydro'

fundle init

zoxide init fish | source
