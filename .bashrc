# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export GPG_TTY=$(tty)

# ═══════════════════════════════════════════════════════════════
# ▲ NERV TERMINAL ALIASES - EVANGELION THEME
# ═══════════════════════════════════════════════════════════════

nerv_header() {
    echo -e "\033[1;31m╔═══════════════════════════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;31m║\033[0m \033[1;32m▲ NERV FILE SYSTEM ANALYSIS\033[0m                                   \033[1;31m║\033[0m"
    echo -e "\033[1;31m╠═══════════════════════════════════════════════════════════════╣\033[0m"
}

nerv_footer() {
    echo -e "\033[1;31m╚═══════════════════════════════════════════════════════════════╝\033[0m"
}

# LS com tema Evangelion (usando ls padrão com cores)
alias ls='nerv_header && command ls --color=always --group-directories-first -F && nerv_footer'
alias ll='nerv_header && command ls -lAhF --color=always --group-directories-first && nerv_footer'
alias la='nerv_header && command ls -AF --color=always --group-directories-first && nerv_footer'
alias lt='nerv_header && tree -L 2 -C 2>/dev/null || (echo -e "\033[1;33m⚠ Tree not installed. Install with: sudo apt install tree\033[0m" && command ls -R) && nerv_footer'

cd() {
    if [ -n "$1" ]; then
        echo -e "\033[1;31m◢◣\033[0m \033[1;33mSYNCHRONIZING TO: \033[1;36m$1\033[0m"
    fi
    
    if builtin cd "$@" 2>/dev/null; then
        echo -e "\033[1;33m⬢ COORDINATES: \033[1;36m$(pwd)\033[0m"
    else
        echo -e "\033[1;31m✘✘✘ SYNCHRONIZATION FAILED\033[0m"
        echo -e "\033[1;31m[PATTERN BLUE]\033[0m Target not found: \033[1;33m$1\033[0m"
        return 1
    fi
}

# ═══════════════════════════════════════════════════════════════
# ▲ NERV SUDO WRAPPER
# ═══════════════════════════════════════════════════════════════

sudo() {
    echo -e "\033[1;33m⬢ REQUESTING MAGI AUTHORIZATION...\033[0m"
    command sudo "$@"
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        echo -e "\033[1;32m[✓] OPERATION COMPLETE - PATTERN NOMINAL\033[0m"
    else
        echo -e "\033[1;31m✘✘✘ OPERATION REJECTED\033[0m"
        echo -e "\033[1;31m[ABORT CODE] Exit status: $exit_code\033[0m"
    fi
    
    return $exit_code
}

# Command not found handler
command_not_found_handle() {
    echo -e "\033[1;31m╔═══════════════════════════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;31m║\033[0m \033[1;31m✘✘✘ UNIDENTIFIED COMMAND\033[0m                                    \033[1;31m  ║\033[0m"
    echo -e "\033[1;31m║\033[0m \033[1;33m[PATTERN ORANGE]\033[0m Command '\033[1;36m$1\033[0m' not in MAGI database                   \033[1;31m ║\033[0m"
    echo -e "\033[1;31m╚═══════════════════════════════════════════════════════════════╝\033[0m"
    return 127
}
# CAT com cabeçalho
alias cat='nerv_cat'
nerv_cat() {
    echo -e "\033[1;31m▶▶▶ DATA STREAM ANALYSIS ▶▶▶\033[0m"
    command cat "$@"
}

# CLEAR com mensagem NERV
alias clear='command clear && echo -e "\033[1;31m╔═══════════════════════════════════════════════════════════════╗\033[0m" && echo -e "\033[1;31m║\033[0m \033[1;32m⬢ NERV MAGI SYSTEM - DISPLAY RESET\033[0m                      \033[1;31m      ║\033[0m" && echo -e "\033[1;31m║\033[0m \033[1;33m◢◤ ALL SYSTEMS NOMINAL ◥◣\033[0m                                     \033[1;31m║\033[0m" && echo -e "\033[1;31m╚═══════════════════════════════════════════════════════════════╝\033[0m"'

# GREP com highlight
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# GIT com tema
alias gst='echo -e "\033[1;33m⬡ REPOSITORY STATUS CHECK ⬡\033[0m" && git status'
alias glog='echo -e "\033[1;33m⬡ TIMELINE ANALYSIS ⬡\033[0m" && git log --oneline --graph --decorate --all --color=always'
alias gadd='echo -e "\033[1;32m[+STAGE] Adding to staging area...\033[0m" && git add'
alias gcom='git_commit'
git_commit() {
    echo -e "\033[1;32m[✓SYNC] Recording changes to timeline...\033[0m"
    git commit -m "$@"
}

# Informações do sistema
alias sysinfo='echo -e "\033[1;31m╔═══════════════════════════════════════════════════════════════╗\033[0m" && echo -e "\033[1;31m║\033[0m \033[1;32m▲ NERV EVA UNIT DIAGNOSTICS\033[0m                                \033[1;31m║\033[0m" && echo -e "\033[1;31m╠═══════════════════════════════════════════════════════════════╣\033[0m" && fastfetch && echo -e "\033[1;31m╚═══════════════════════════════════════════════════════════════╝\033[0m"'

# Processos ativos
alias psa='echo -e "\033[1;31m◢◣ ACTIVE PROCESS SCAN ◢◣\033[0m" && ps aux --sort=-%mem | head -20'

# Uso de disco
alias diskusage='echo -e "\033[1;31m▶ STORAGE CAPACITY REPORT ▶\033[0m" && df -h'

# Uso de memória
alias meminfo='echo -e "\033[1;31m⬢ MEMORY CORE STATUS ⬢\033[0m" && free -h'

# Porta listening
alias ports='echo -e "\033[1;31m◢◣ NETWORK INTERFACE STATUS ◢◣\033[0m" && sudo netstat -tulpn 2>/dev/null || ss -tulpn'

alias project='echo -e "\033[1;33m⬢ DEPLOYING TO PROJECT LOCATION...\033[0m" && cd ~/Documents/sonnen/personal/proj_imobiliaria/client'

alias aptup='echo -e "\033[1;31m◢◣ INITIATING SYSTEM UPGRADE SEQUENCE ◢◣\033[0m" && sudo apt update && sudo apt upgrade -y && ~/.local/bin/update-candy-icons.sh'

alias nervhelp='echo -e "\033[1;31m╔═══════════════════════════════════════════════════════════════╗\033[0m" && echo -e "\033[1;31m║\033[0m \033[1;32m▲ NERV TERMINAL INTERFACE COMMANDS\033[0m                           \033[1;31m ║\033[0m" && echo -e "\033[1;31m╠═══════════════════════════════════════════════════════════════╣\033[0m" && echo -e "\033[1;31m║\033[0m \033[1;33mls/ll/la/lt\033[0m   - File system analysis                      \033[1;31m    ║\033[0m" && echo -e "\033[1;31m║\033[0m \033[1;33mgst/glog\033[0m      - Repository status and timeline            \033[1;31m    ║\033[0m" && echo -e "\033[1;31m║\033[0m \033[1;33msysinfo\033[0m       - EVA unit diagnostics                      \033[1;31m    ║\033[0m" && echo -e "\033[1;31m║\033[0m \033[1;33mdiskusage\033[0m     - Storage capacity report                   \033[1;31m    ║\033[0m" && echo -e "\033[1;31m║\033[0m \033[1;33mmeminfo\033[0m       - Memory core status                        \033[1;31m    ║\033[0m" && echo -e "\033[1;31m║\033[0m \033[1;33mports\033[0m         - Network interface status                  \033[1;31m    ║\033[0m" && echo -e "\033[1;31m║\033[0m \033[1;33mpsa\033[0m           - Active process scan                       \033[1;31m    ║\033[0m" && echo -e "\033[1;31m║\033[0m \033[1;33mproject\033[0m       - Deploy to project location                \033[1;31m    ║\033[0m" && echo -e "\033[1;31m║\033[0m \033[1;33maptup\033[0m         - System upgrade sequence                   \033[1;31m    ║\033[0m" && echo -e "\033[1;31m╚═══════════════════════════════════════════════════════════════╝\033[0m"'


# ───────────────────────────────────────────────
# Fastfat
if command -v fastfetch &> /dev/null; then
    case "$TERM" in
        xterm-kitty)
            fastfetch --logo-type kitty-direct
            ;;
        xterm-256color|cosmic-terminal*)
            fastfetch --logo-type small
            ;;
        *)
            fastfetch
            ;;
    esac
fi

# Mensagem de boas-vindas ao abrir o terminal
echo -e "\033[1;31m╔═══════════════════════════════════════════════════════════════╗\033[0m"
echo -e "\033[1;31m║\033[0m \033[1;32m⬢ NERV MAGI SYSTEM - INTERFACE ONLINE\033[0m                 \033[1;31m        ║\033[0m"
echo -e "\033[1;31m║\033[0m \033[1;33m◢◤ $(date '+%Y-%m-%d %H:%M:%S') ◥◣\033[0m                                \033[1;31m     ║\033[0m"
echo -e "\033[1;31m║\033[0m \033[1;32mPATTERN: BLUE - ALL SYSTEMS NOMINAL\033[0m                       \033[1;31m    ║\033[0m"
echo -e "\033[1;31m║\033[0m Access '\033[1;33mnervhelp\033[0m' for command database                      \033[1;31m  ║\033[0m"
echo -e "\033[1;31m╚═══════════════════════════════════════════════════════════════╝\033[0m"

eval "$(starship init bash)"

