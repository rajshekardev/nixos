alias clean-nix="sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +3 && nix-collect-garbage -d"
export PATH="/home/rshekar/.local/bin:$PATH"

pfetch
