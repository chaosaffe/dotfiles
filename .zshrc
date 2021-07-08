
export TERM="xterm-256color"

#To save every command before it is executed (this is different from bash's history -a solution):
setopt inc_append_history

#To retrieve the history file everytime history is called upon.
setopt share_history

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
COMPLETION_WAITING_DOTS="true"
plugins=(zsh-autosuggestions zsh-syntax-highlighting git kubetail)
source $ZSH/oh-my-zsh.sh

# Custom profile

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


## Exports
export DEFAULT_USER=chaosaffe
export GOPATH=$HOME/Documents/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/home/chaosaffe/.local/bin
export PATH=$PATH:$(which aws_completer)
export PATH="$PATH:${KREW_ROOT:-$HOME/.krew}/bin"
export HISTFILE=~/.zsh_history
export HISTSIZE=999999999
export SAVEHIST=$HISTSIZE
export TF_CLI_ARGS_plan="-parallelism=160"
export TF_CLI_ARGS_apply="-parallelism=160"

## Aliases
alias d=docker
alias k=kubectl
alias g=hub
alias git=hub
alias ll=ls -lah
alias h=helm
alias goland="goland-silence"
alias gl="goland"
alias ggh="cd $GOPATH/src/github.com"
alias gtm="cd $GOPATH/src/github.com/Telmediq"
alias gco="cd $GOPATH/src/github.com/pscloudops"
alias gme="cd $GOPATH/src/github.com/chaosaffe/"
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias assume="source okta-assumerole"
alias tf="terraform"
alias cat="batcat"
alias ao="aws-okta"
alias ass="source okta-assumerole"
alias captain="export KUBECONFIG=/home/chaosaffe/.kube/configs/"

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
complete -o nospace -C /usr/local/bin/terraform terraform
complete -o nospace -C $(which aws_completer) aws


# Assume environment if set

if [ -n "$ASSUME_ENVIRONMENT" ]; then
  /usr/local/bin/okta-assumerole $ASSUME_ENVIRONMENT
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
