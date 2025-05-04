{
  flake,
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.syncnet;
  homeDirectory = "/home/${config.args.owner}";
  inherit (lib) filter;
  inherit (lib.attrsets) mapAttrs' mapAttrsToList;
  inherit (lib.strings) concatLines;
  isNull = x: x == null;
in
{
  options = {
    services.syncnet = {
      enable = lib.mkEnableOption "Enable Syncnet";
      devices = lib.mkOption {
        type = lib.types.anything; # TODO: Refine
        default = { };
      };
    };
  };
  config =
    let
      folders =
        with config.devices;
        {
          "sync" = {
            path = "sync";
            devices = pcs ++ androidDevices;
          };
          "org" = {
            path = "sync/org";
            devices = pcs ++ androidDevices;
          };
          "org-roam" = {
            path = "sync/org-roam";
            devices = pcs ++ androidDevices;
          };
          "obsidian" = {
            path = "sync/obsidian";
            devices = pcs ++ androidDevices;
          };
          "secure" = {
            path = "sync/secure";
            devices = pcs ++ androidDevices;
          };
        }
        // builtins.listToAttrs (
          map (androidDevice: {
            name = androidDevice.name + "-root";
            value = {
              path = "sync/" + androidDevice.name;
              devices = [ androidDevice ] ++ pcs;
              ignores = [
                "sync"
                "org"
                "org-roam"
                "obsidian"
                "secure"
              ];
              type = "receiveonly";
            };
          }) androidDevices
        );
    in
    {
      # TODO: Filter by devce.
      home-manager.users.${config.args.owner}.home.file = mapAttrs' (
        name:
        {
          path,
          ignores ? [ ],
          ...
        }:
        {
          name = "${path}/.stignore";
          value = {
            source = builtins.toFile "stignore" (
              concatLines (
                ignores
                ++ filter (x: x != null) (
                  mapAttrsToList (
                    _: other:
                    let
                      sub = flake.lib.getRelativePath path other.path;
                    in
                    if sub == null || sub == "" then null else sub
                  ) folders
                )
              )
            );
          };
        }
      ) folders;
      networking.hosts = builtins.listToAttrs (
        map (device: {
          name = device.ipAddr;
          value = [ device.name ];
        }) (builtins.filter (device: device ? "ipAddr") config.devices.allDevices)
      );
      services.syncthing = {
        enable = true;
        user = config.args.owner;
        dataDir = homeDirectory;
        configDir = "${homeDirectory}/.config/syncthing";
        overrideDevices = true;
        overrideFolders = true;
        settings = {
          devices = builtins.listToAttrs (
            map (device: {
              name = device.name;
              value = {
                id = device.syncthingId;
                introducer = false;
              };
            }) (builtins.filter (device: device ? "syncthingId") config.devices.allDevices)
          );
          folders = builtins.mapAttrs (
            name:
            {
              path,
              devices,
              type ? "sendreceive",
              ...
            }:
            {
              enable = true;
              path = homeDirectory + ("/" + path);
              devices = map (device: device.name) devices;
              inherit type;
              versioning = {
                type = "staggered";
                params.maxAge = "365";
              };
            }
          ) folders;
        };
      };
    };
}
