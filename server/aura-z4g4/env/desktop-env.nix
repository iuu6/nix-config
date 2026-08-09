{ inputs, ... }:
{
  imports = [
    ./../../../desktop-env/gnome
    ./../../../desktop-env/onlyoffice
    (inputs.private + "/desktop-env/davinci-studio")
  ];
}
