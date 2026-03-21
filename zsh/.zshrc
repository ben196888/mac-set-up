# Oh My Zsh core
export ZSH="$HOME/.oh-my-zsh"
plugins=(git gh)
source $ZSH/oh-my-zsh.sh

# Starship prompt
eval "$(starship init zsh)"

# GPG: set TTY only if gpg is installed
if command -v gpg >/dev/null 2>&1; then
  export GPG_TTY=$(tty)
fi

# Optional: enable Warp shell block title if running in Warp
if [[ "$TERM_PROGRAM" == "WarpTerminal" ]]; then
  export WARP_ENABLE_SHELL_BLOCK_TITLE=true
fi

# .NET SDK (add to PATH if installed via Homebrew or manually)
/usr/local/share/dotnet/dotnet --info >/dev/null 2>&1 && {
  export DOTNET_ROOT="/usr/local/share/dotnet"
  export PATH="$DOTNET_ROOT:$PATH"
}

# Optional: enable Go environment variables if Go is installed
if command -v go >/dev/null 2>&1; then
  export GOPATH="$HOME/go"
  export PATH="$PATH:$GOPATH/bin"
fi

# Optional: add Deno to PATH if installed
if [ -d "$HOME/.deno/bin" ]; then
  export PATH="$HOME/.deno/bin:$PATH"
fi

# Optional: add MacTeX to PATH if installed
if [ -d "/Library/TeX/texbin" ]; then
  export PATH="/Library/TeX/texbin:$PATH"
fi

# Pyenv
if command -v pyenv >/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

# Poetry completions (safe and clean)
if command -v poetry >/dev/null 2>&1; then
  fpath+=("${ZDOTDIR:-$HOME}/.local/share/pypoetry/completions/zsh")
fi

# Rust (if installed)
if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi

# Set VS Code as default editor if installed
if command -v code >/dev/null 2>&1; then
  export EDITOR="code --wait"
fi

# Add user-local bin to PATH if it exists
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# Numpad key bindings
bindkey -s "^[Op" "0"
bindkey -s "^[On" "."
bindkey -s "^[OM" "^M"
bindkey -s "^[Oq" "1"
bindkey -s "^[Or" "2"
bindkey -s "^[Os" "3"
bindkey -s "^[Ot" "4"
bindkey -s "^[Ou" "5"
bindkey -s "^[Ov" "6"
bindkey -s "^[Ow" "7"
bindkey -s "^[Ox" "8"
bindkey -s "^[Oy" "9"
bindkey -s "^[Ok" "+"
bindkey -s "^[Om" "-"
bindkey -s "^[Oj" "*"
bindkey -s "^[Oo" "/"

# Alias grep to ripgrep if installed
if command -v rg >/dev/null 2>&1; then
  alias grep='rg'
fi

# Alt + Arrow movement
bindkey "^[^[[C" forward-word
bindkey "^[^[[D" backward-word

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
if [ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi
