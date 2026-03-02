# ======================
# Minimal Zsh with Colors
# ======================
clear
# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history

# Options
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


# Path
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export EDITOR='vim'  # or vim/nvim/code
export VISUAL='vim'

# Color codes
autoload -U colors && colors

# Set the prompt
PS1="%{$fg[cyan]%}%n@%m %{$fg[green]%}%~ %{$fg[green]%}❯ %{$reset_color%}"

# Plugin
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# Aliases command
alias reload='source ~/.zshrc'
alias ll='ls -lah --color=auto'
alias ls='ls --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias toggle_ibus='$HOME/dotfiles/scripts/toggle_ibus.sh'
alias autoupdate="$HOME/dotfiles/scripts/install.sh"
alias modupdate="vim $HOME/dotfiles/scripts/install.sh"

# NixOS aliases
alias vm='sudo nixos-rebuild switch --flake /home/derek/minimal-nixos#vm'
alias pc='sudo nixos-rebuild switch --flake /home/derek/minimal-nixos#pc'
alias lap='sudo nixos-rebuild switch --flake /home/derek/minimal-nixos#lap'
alias clean='sudo nix-env --delete-generations old && sudo nix-collect-garbage --delete-older-than 2d'
alias phone='scrcpy --turn-screen-off --stay-awake --power-off-on-close'
alias pmbootstrap='python ~/postmarketos/pmbootstrap/pmbootstrap.py'
alias crush='nix run github:numtide/nix-ai-tools#crush'
alias opencode='/nix/store/qz8ghqk7ikrl4i5lr68x41isqs7khxsh-opencode-1.2.14/bin/opencode'

