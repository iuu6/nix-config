{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    # ./../../../code-editor-env/navicat-premium
    ./../../../code-editor-env/vscode
    ./../../../code-editor-env/github-desktop
    # ./../../../code-editor-env/jetbrain
  ];
}
