{ config, pkgs, ... }:

{
  i18n.inputMethod = {
    type = "ibus";
    enable = true;
    ibus.engines = with pkgs.ibus-engines; [
      pinyin
      table-chinese
    ];
  };
}

