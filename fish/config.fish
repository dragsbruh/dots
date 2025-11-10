if status is-interactive
    set -U fish_greeting

    alias "ls=exa"
    alias "ll=ls -la"
    alias "tree=exa --tree"

    function reload
        source ~/.config/fish/config.fish
    end

    function update_discord
        curl -sSL https://raw.githubusercontent.com/n3oney/discord-update-skip/stable/set-config.sh | bash
    end
end

source '/home/dragsbruh/.opam/opam-init/init.fish'
set -Ux PATH /home/dragsbruh/go/bin/ $PATH
