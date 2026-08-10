host := `hostname`

default:
    @just --list

# Rebuild and switch to new configuration
switch host=host:
    sudo env SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket) nixos-rebuild switch --flake .#{{host}} --no-update-lock-file

# Build and activate without adding boot entry (revert on reboot)
test host=host:
    sudo env SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket) nixos-rebuild test --flake .#{{host}} --no-update-lock-file

# Build and add boot entry, but don't activate now
boot host=host:
    sudo env SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket) nixos-rebuild boot --flake .#{{host}} --no-update-lock-file

# Build without activating
build host=host:
    SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket) nixos-rebuild build --flake .#{{host}}

# Dry-run: show what would be built
dry host=host:
    SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket) nixos-rebuild dry-build --flake .#{{host}}

# Update all flake inputs
update:
    SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket) nix flake update

# Update a single input, e.g. `just update-input nixpkgs`
update-input input:
    SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket) nix flake update {{input}}

# Format all nix files
fmt:
    nix fmt

# Validate the flake
check:
    SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket) nix flake check

# Show flake outputs
show:
    SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket) nix flake show

# Garbage-collect old generations and store paths
gc:
    sudo nix-collect-garbage -d
    nix-collect-garbage -d

# List system generations
generations:
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Diff current system vs a freshly built one
diff host=host:
    SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket) nixos-rebuild build --flake .#{{host}}
    nvd diff /run/current-system ./result

# Open a nix repl with this flake loaded
repl:
    nix repl --expr 'builtins.getFlake (toString ./.)'
