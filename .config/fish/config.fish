fish_add_path -g ~/.local/bin

set -gx EDITOR nvim
set -gx VISUAL nvim

if status is-interactive
    if command -q zoxide
        zoxide init fish | source
    end
    if test ! $TERM = "linux"
        if command -q starship
            starship init fish | source
            enable_transience
        end
    end

    abbr --add q exit
    abbr --add w z # zoxide
    abbr --add e nvim 
end
