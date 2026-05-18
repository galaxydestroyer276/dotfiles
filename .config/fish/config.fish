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

    abbr --add g git
    abbr --add ga git add
    abbr --add gaa git add --all
    abbr --add gb git branch
    abbr --add --set-cursor gcm git commit -m \"%\"
    abbr --add --set-cursor gcam git commit -a -m \"%\"
    abbr --add gco git checkout
    abbr --add gd git diff
    abbr --add gds git diff --staged
    abbr --add gl git log
    abbr --add gpl git pull
    abbr --add gr git reset
    abbr --add gr! git reset --hard
    abbr --add grh git reset HEAD
    abbr --add grh! git reset HEAD --hard
    abbr --add gs git status
    abbr --add gss git status -s
    abbr --add gsb git status -sb
    abbr --add gt git tag
end
