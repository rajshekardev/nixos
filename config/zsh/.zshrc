alias clean-nix="sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +3 && nix-collect-garbage -d"
export PATH="/home/rshekar/.local/bin:$PATH"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

pfetch
