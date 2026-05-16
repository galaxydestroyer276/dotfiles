#!/usr/bin/env fish

# --- Variables ---
set _time $(date +%m_%d__%H_%M_%S%3N__%Y)

set DOTFILES_REPO_PATH $HOME/dotfiles
set CONFIG_BACKUP_DIR $HOME/.config_backup/$_time
set DOTFILES_BACKUP_DIR $HOME/.dotfiles_backup/$_time

set __dotfiles_backup_config_list \
    alacritty/ btop/ fish/ tmux/ starship.toml

# --- Functions ---
function get_dotfiles_item_list
    for i in $__dotfiles_backup_config_list
        echo $HOME/.config/$i
    end
end

function backup_old_dotfiles
    mkdir -p $DOTFILES_BACKUP_DIR
    for item in $(get_dotfiles_item_list)
        if test -d $item -a -e $item
            cp -vrf $item $DOTFILES_BACKUP_DIR/
        end
    end
end

function backup_old_config
    mkdir -p $CONFIG_BACKUP_DIR
    for item in $HOME/.config
        if test -d $item -a -e $item
            cp -rf $item $CONFIG_BACKUP_DIR/
        end
    end
end

function cleanup_old_dotfiles
    for item in $(get_dotfiles_item_list)
        if test -d $item -a -e $item
            rm -vrf $item
        end
    end
end

function install_new_dotfiles
    cp -rf $DOTFILES_REPO_PATH/.config/* $HOME/.config/
end

# --- Main Execution Flow ---
backup_old_dotfiles
backup_old_config
cleanup_old_dotfiles
install_new_dotfiles

if test ! -e $HOME/.local/bin/uv
    curl -LsSf https://astral.sh/uv/install.sh | sh
end

if test ! -e $HOME/.local/bin/ruff
    uv tool install ruff@latest
end
