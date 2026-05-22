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
            cp -rf $item $DOTFILES_BACKUP_DIR/
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
            rm -rf $item
        end
    end
end

function install_new_dotfiles
    cp -rf $DOTFILES_REPO_PATH/.config/* $HOME/.config/
end

function ensure_bibata_cursors
    set -l icons_dir $HOME/.local/share/icons
    set -l variants Bibata-Original-Ice Bibata-Modern-Ice
    set -l bibata_repo \
        "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7"

    mkdir -p $icons_dir

    for variant in $variants
        if test -d $icons_dir/$variant
            continue
        end

        echo "Installing $variant..."

        set -l temp_dir (mktemp -d)
        set -l fname "$variant.tar.xz"
        set -l archive "$temp_dir/$fname"
        set -l url "$bibata_repo/$fname"

        if not curl -L $url -o $archive 2>/dev/null
            echo "ERROR: Failed to download $fname"
            rm -rf $temp_dir
            return 1
        end

        if not tar -xf $archive -C $icons_dir 2>/dev/null
            echo "ERROR: Failed to extract $fname"
            rm -rf $temp_dir
            return 1
        end

        rm -rf $temp_dir
    end

    echo "✔ Bibata cursors installed"
    return 0
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
    $HOME/.local/bin/uv tool install ruff@latest
end

ensure_bibata_cursors
