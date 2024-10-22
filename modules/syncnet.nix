{ config, pkgs, lib, ... }:

let
  cfg = config.services.syncnet;
in
{
  options = {
    services.syncnet = {
      enable = lib.mkEnableOption "Enable Syncnet";
      devices = lib.mkOption {
        type = lib.types.anything; # TODO: Refine
        default = {};
      };
    };
  };
  config =
    let
      folders = {
        "sync" = {
          path = "/home/cdo/sync/root";
          cfg.devices = cfg.devices.pcs ++ cfg.devices.androidDevices;
        };
        "org" = {
          path = "/home/cdo/sync/org";
          cfg.devices = cfg.devices.pcs ++ cfg.devices.androidDevices;
        };
        "org-roam" = {
          path = "/home/cdo/sync/org-roam";
          cfg.devices = cfg.devices.pcs ++ cfg.devices.androidDevices;
        };
        "secure" = {
          path = "/home/cdo/sync/secure";
          cfg.devices = cfg.devices.pcs ++ cfg.devices.androidDevices;
        };
      } // builtins.listToAttrs (map (androidDevice:
        {
          name = androidDevice.name + "-root";
          value = {
            path = "/home/cdo/sync/" + androidDevice.name;
            cfg.devices = [ androidDevice ] ++ cfg.devices.pcs;
          };
        }) cfg.devices.androidDevices);
    in
    {
      services.syncthing = {
        enable = true;
        user = "cdo";
        dataDir = "/home/cdo/";
        configDir = "/home/cdo/.config/syncthing";
        overrideDevices = true;
        overrideFolders = true;
        settings = {
          cfg.devices = builtins.listToAttrs (map (device:
            {
              name = device.name;
              value = { id = device.syncthingId; };
            }
          ) (builtins.filter (device: device ? "syncthingId") cfg.devices.allDevices));
          folders = builtins.mapAttrs (name: folder:
          {
            path = folder.path;
            cfg.devices = (map (device: device.name) cfg.devices.allDevices);
            versioning = {
              type = "staggered";
              params.maxAge = 365;
            };
          }) folders;
        };
      };
    };
}
