# bat theme
export BAT_THEME="ansi"

# trash directory
export TRASH_DIR="/data/.trash"

# Add user's private bin directory to PATH if it exists and is not already in PATH
if [[ -d "$HOME/bin" ]] && [[ ! ":$PATH:" == *":$HOME/bin:"* ]]; then
    export PATH="$HOME/bin:$PATH"
fi

export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
