{
  config,
  pkgs,
  ...
}:

let
  version = "0.1.0";
  manifest = pkgs.writeTextFile "manifest.json" (
    builtins.toJSON {
      manifest_version = 3;
      name = "Stylix Chrome Theme";
      version = version;
      description = "Auto-generated theme from Stylix color scheme";
      theme = {
        colors = {
          frame = config.lib.stylix.colors.base01;
          toolbar = config.lib.stylix.colors.base00;
          tab_text = config.lib.stylix.colors.base05;
          tab_background_text = config.lib.stylix.colors.base03;
          bookmark_text = config.lib.stylix.colors.base05;
          omnibox_background = config.lib.stylix.colors.base01;
          omnibox_text = config.lib.stylix.colors.base05;
          ntp_background = config.lib.stylix.colors.base00;
          ntp_text = config.lib.stylix.colors.base05;
        };
      };
    }
  );

  stylix-chromium-theme = pkgs.stdenv.mkDerivation {
    pname = "stylix-chromium-theme";
    version = version;

    src = null;
    dontUnpack = true;

    build-inputs = [
      pkgs.ungoogled-chromium
    ];

    buildPhase = ''
      mkdir -p chromium-theme
      cp ${manifest} chromium-theme/manifest.json
      ${pkgs.ungoogled-chromium}/bin/chromium --pack=chromium-theme
    '';

    installPhase = ''
      mkdir -p $out/share/chromium-themes
      cp chromium-theme.crx $out/share/chromium-themes/stylix-chromium-theme.crx
    '';
  };

in
{
  programs.chromium.extensions = [
    {
      id = "TODO";
      crxPath = "${stylix-chromium-theme}/share/chromium-themes/stylix-chromium-theme.crx";
      version = version;
    }
  ];
}

