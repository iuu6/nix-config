{ config, pkgs, lib, ... }:
let
  fontDir = user: "${user.home}/.local/share/fonts/onlyoffice";
  normalUsers = lib.attrValues (lib.filterAttrs (_: u: u.isNormalUser) config.users.users);

  # Hash computed at eval time from store paths — changes only when font packages change.
  fontHash = builtins.hashString "sha256"
    (lib.concatStringsSep "\n" (map toString config.fonts.packages));

  mkScript = user: ''
    install -d -o ${user.name} -g users -m 755 "${fontDir user}"

    hashFile="${fontDir user}/.pkg-hash"
    if [ -f "$hashFile" ] && [ "$(cat "$hashFile")" = "${fontHash}" ]; then
      echo "onlyoffice-fonts: fonts unchanged, skipping copy for ${user.name}"
    else
      echo "onlyoffice-fonts: copying fonts for ${user.name}..."

      # Remove stale entries from the previous generation
      ${pkgs.findutils}/bin/find "${fontDir user}" -maxdepth 1 -type f -delete 2>/dev/null || true

      # Copy font files. OnlyOffice does not follow symlinks (NixOS wiki).
      # Variable fonts (-VF., [...]) cause OnlyOffice to hang — skip them.
      # Use a shell case statement instead of find -name "[...]" which treats
      # brackets as a character class and would exclude nearly everything.
      for pkg in ${lib.concatStringsSep " " (map (p: lib.escapeShellArg (toString p)) config.fonts.packages)}; do
        if [ -d "$pkg/share/fonts" ]; then
          while IFS= read -r -d "" font; do
            case "$font" in
              *-VF.*|*"["*) continue ;;
            esac
            ${pkgs.coreutils}/bin/cp -n "$font" "${fontDir user}/"
          done < <(${pkgs.findutils}/bin/find "$pkg/share/fonts" \
            \( -name "*.ttf" -o -name "*.otf" -o -name "*.ttc" \) \
            ! -type l -print0)
        fi
      done
      ${pkgs.coreutils}/bin/chmod 644 "${fontDir user}"/* 2>/dev/null || true

      echo "${fontHash}" > "$hashFile"
    fi
  '';
in
{
  # OnlyOffice does not follow symlinks and does not scan /usr/share/fonts inside
  # its FHS sandbox. Copy fonts to each user's ~/.local/share/fonts/onlyoffice/.
  system.activationScripts.onlyoffice-fonts = {
    deps = [ "users" "groups" ];
    text = lib.concatMapStrings mkScript normalUsers;
  };
}
