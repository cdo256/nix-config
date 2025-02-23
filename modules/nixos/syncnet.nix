{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.syncnet;
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
            path = "/home/cdo/sync";
            devices = pcs ++ androidDevices;
          };
          "org" = {
            path = "/home/cdo/sync/org";
            devices = pcs ++ androidDevices;
          };
          "org-roam" = {
            path = "/home/cdo/sync/org-roam";
            devices = pcs ++ androidDevices;
          };
          "obsidian" = {
            path = "/home/cdo/sync/obsidian";
            devices = pcs ++ androidDevices;
          };
          "secure" = {
            path = "/home/cdo/sync/secure";
            devices = pcs ++ androidDevices;
          };
        }
        // builtins.listToAttrs (
          map (androidDevice: {
            name = androidDevice.name + "-root";
            value = {
              path = "/home/cdo/sync/" + androidDevice.name;
              devices = [ androidDevice ] ++ pcs;
            };
          }) androidDevices
        );
    in
    {
      networking.hosts = builtins.listToAttrs (
        map (device: {
          name = device.ipAddr;
          value = [ device.name ];
        }) (builtins.filter (device: device ? "ipAddr") config.devices.allDevices)
      );
      services.syncthing = {
        enable = true;
        user = "cdo";
        dataDir = "/home/cdo/";
        configDir = "/home/cdo/.config/syncthing";
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
          folders = builtins.mapAttrs (name: folder: {
            enable = true;
            path = folder.path;
            devices = (map (device: device.name) folder.devices);
            versioning = {
              type = "staggered";
              params.maxAge = "365";
            };
          }) folders;
        };
      };
    };
}
