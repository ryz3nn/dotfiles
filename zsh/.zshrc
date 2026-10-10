# ======================
# Minimal Zsh with Colors
# ======================

# Clear terminal
clear

# Optional environment file
[[ -f "$HOME/.env" ]] && source "$HOME/.env"

# ======================
# History
# ======================

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt hist_ignore_dups
setopt share_history

# ======================
# Completion
# ======================

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ======================
# Key bindings
# ======================

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line

# ======================
# PATH
# ======================

export PATH="$HOME/bin:/usr/local/bin:$PATH"

# Go
if command -v go >/dev/null 2>&1; then
    export PATH="$PATH:$(go env GOPATH)/bin"
fi

# OpenCode
export PATH="$HOME/.opencode/bin:$PATH"

# pipx
export PATH="$PATH:$HOME/.local/bin"

# nvim
#export PATH="/opt/nvim-linux-x86_64/bin:$PATH"

# scrcpy
export PATH="/opt/scrcpy-linux-x86_64-v4.1:$PATH"

# ======================
# Environment
# ======================

export EDITOR='nvim'
export VISUAL='nvim'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
export GODEBUG='cpu.all=off'

# ======================
# Colors
# ======================
autoload -U colors && colors

# Load vcs_info
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git

# Format branch display: shows (branch) in yellow
zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow}(%b|%a)%f'

# Run vcs_info before displaying each prompt
precmd() {
    vcs_info
}

# Allow prompt string substitution
setopt PROMPT_SUBST

# Customize your prompt (shows user, path, and branch)
PROMPT='%F{green}%n@%m%f %F{blue}%~%f${vcs_info_msg_0_} %# '

# ======================
# Plugins
# ======================

[[ -f "$HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
    source "$HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

[[ -f "$HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] &&
    source "$HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ======================
# fzf
# ======================

if command -v fzf >/dev/null 2>&1; then
    if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
        source /usr/share/doc/fzf/examples/key-bindings.zsh
    elif [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
        source /usr/share/fzf/key-bindings.zsh
    fi

    if [[ -f /usr/share/doc/fzf/examples/completion.zsh ]]; then
        source /usr/share/doc/fzf/examples/completion.zsh
    elif [[ -f /usr/share/fzf/completion.zsh ]]; then
        source /usr/share/fzf/completion.zsh
    fi
fi

# ======================
# Aliases
# ======================

alias reload='source ~/.zshrc'

alias ll='ls -lah --color=auto'
alias ls='ls --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias reboot='systemctl reboot'
alias shutdown='sudo shutdown now'
alias vim='nvim'

alias toggle_ibus='$HOME/dotfiles/scripts/toggle_ibus.sh'
alias autoupdate="$HOME/dotfiles/scripts/install.sh"
alias modupdate="vim $HOME/dotfiles/scripts/install.sh"

# ======================
# NixOS aliases
# ======================

alias pc='git -C ~/dotfiles add -A && sudo nixos-rebuild switch --flake /home/derek/dotfiles/nixos#amd-pc'
alias lap='git -C ~/dotfiles add -A && sudo nixos-rebuild switch --flake /home/derek/dotfiles/nixos#laptop'

alias clean='sudo nix-env --delete-generations old && sudo nix-collect-garbage --delete-older-than 2d'
alias home='nvim ~/dotfiles/nixos/modules/home.nix'
alias nixs="nix-search"

# ======================
# Arch aliases
# ======================

alias search='pacman -Ss'
alias oc='opencode'
alias bug='cd $HOME/projects/space/bug'
alias space='cd $HOME/projects/space'
alias tmux='systemd-run --scope --user tmux'
alias dot='nvim ~/dotfiles'

alias phone='scrcpy --tcpip=192.168.1.99:5555 -S -w --power-off-on-close --no-audio -m 1024 --max-fps 30'
alias pmbootstrap='python ~/postmarketos/pmbootstrap/pmbootstrap.py'

# ======================
# Debian aliases
# ======================
alias s='apt search'

# ======================
# Folder shortcut
# ======================
alias jh='cd $HOME/projects/jianghu'
alias ryz='cd $HOME/projects/ryz'


# Added by Antigravity CLI installer
export PATH="/home/derek/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# This for nix-ld
export LD_LIBRARY_PATH="$NIX_LD_LIBRARY_PATH${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
