{ inputs, ... }:
{
  imports = [
    ./../../../desktop-env/gnome
    ./../../../desktop-env/onlyoffice
    ./../../../desktop-env/rustdesk
    (inputs.private + "/desktop-env/davinci-studio")
  ];
}
