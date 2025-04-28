# ======================
# Minimal Zsh with Colors
# ======================

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

# Color codes
autoload -U colors && colors

# Set the prompt
PS1="%{$fg[cyan]%}%n@%m %{$fg[green]%}%~ %{$fg[green]%}❯ %{$reset_color%}"

# Plugin
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source ~/.config/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Aliases folder
alias dwmdir="cd $HOME/dotfiles/suckless/dwm"
alias scriptsdir="cd $HOME/dotfiles/scripts"
alias shortcut="vim $HOME/dotfiles/sxhkd/.config/sxhkd/sxhkdrc"
alias suckless="cd $HOME/dotfiles/suckless"

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
