host := `hostname`

default:
    @just --list

# Rebuild and switch to new configuration
switch host=host:
    sudo nixos-rebuild switch --flake .#{{host}}

# Build and activate without adding boot entry (revert on reboot)
test host=host:
    sudo nixos-rebuild test --flake .#{{host}}

# Build and add boot entry, but don't activate now
boot host=host:
    sudo nixos-rebuild boot --flake .#{{host}}

# Build without activating
build host=host:
    nixos-rebuild build --flake .#{{host}}

# Dry-run: show what would be built
dry host=host:
    nixos-rebuild dry-build --flake .#{{host}}

# Update all flake inputs
update:
    nix flake update

# Update a single input, e.g. `just update-input nixpkgs`
update-input input:
    nix flake update {{input}}

# Format all nix files
fmt:
    nix fmt

# Validate the flake
check:
    nix flake check

# Show flake outputs
show:
    nix flake show

# Garbage-collect old generations and store paths
gc:
    sudo nix-collect-garbage -d
    nix-collect-garbage -d

# List system generations
generations:
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Diff current system vs a freshly built one
diff host=host:
    nixos-rebuild build --flake .#{{host}}
    nvd diff /run/current-system ./result

# Open a nix repl with this flake loaded
repl:
    nix repl --expr 'builtins.getFlake (toString ./.)'
