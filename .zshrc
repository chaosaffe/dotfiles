# TODO: Use Powerlevel 10k

export TERM="xterm-256color"
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="agnoster"
ZSH_THEME="powerlevel9k/powerlevel9k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(zsh-autosuggestions zsh-syntax-highlighting git kubetail)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Custom profile

## Exports
export DEFAULT_USER=chaosaffe
export GOPATH=$HOME/Documents/go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/home/chaosaffe/.local/bin
export PATH=$PATH:$(which aws_completer)

## Aliases
alias d=docker
alias k=kubectl
alias g=hub
alias git=hub
alias ll=ls -la
alias h=helm
alias gh="cd $GOPATH/src/github.com/"
alias gl="cd $GOPATH/src/gitlab.com/"
alias me="cd $GOPATH/src/github.com/chaosaffe/"
alias ceph="kubectl -n rook-ceph exec -it \$(kubectl -n rook-ceph get pod -l "app=rook-ceph-tools" -o jsonpath='{.items[0].metadata.name}') -- ceph $@"
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias assume="source okta-assumerole"
alias tf="terraform"
alias cat="batcat"
alias ao="aws-okta"
alias ass="assume"

## Functions
dec() { gpg -d $@ | tar -xvz; }
enc() { tar -cz $@ | gpg -r jason@chaosaffe.io -o $@.tgz.gpg -e; }
unpack() {
  export MOUNT_POINT=/media/$DEFAULT_USER/tmpfs
  sudo mkdir -p $MOUNT_POINT && \
  sudo mount -t tmpfs -o size=512m swap $MOUNT_POINT && \
  gpg -d $@ | tar -xvzC $MOUNT_POINT && \
  nautilus $MOUNT_POINT -n --no-default-window --no-desktop && \
  sleep 5m && \
  sudo umount -f /media/$DEFAULT_USER/tmpfs && \
  sudo rm -Rf /media/$DEFAULT_USER/tmpfs
}

## Source external files
source <(kubectl completion zsh)
source <(aws-okta completion zsh)

# Configure GPG Agent for YubiKey
GPG_TTY=$(tty)
export GPG_TTY
if [ -z "$GPG_AGENT_INFO" ]; then
    eval "$(gpg-agent --daemon --options ~/.gnupg/gpg-agent.conf)"
fi

# Configure SSH to use GPG
SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export SSH_AUTH_SOCK

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
complete -o nospace -C $(which aws_completer) aws
