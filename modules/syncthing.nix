{ config, pkgs, devices, ... }:

let
  folders = {
    "sync" = {
      path = "/home/cdo/sync/root";
      devices = devices.pcs ++ devices.androidDevices;
    };
    "org" = {
      path = "/home/cdo/sync/org";
      devices = devices.pcs ++ devices.androidDevices;
    };
    "org-roam" = {
      path = "/home/cdo/sync/org-roam";
      devices = devices.pcs ++ devices.androidDevices;
    };
    "secure" = {
      path = "/home/cdo/sync/secure";
      devices = devices.pcs ++ devices.androidDevices;
    };
  } // builtins.listToAttrs (map (androidDevice:
    {
      name = androidDevice.name + "-root";
      value = {
        path = "/home/cdo/sync/" + androidDevice.name;
        devices = [ androidDevice ] ++ devices.pcs;
      };
    }) devices.androidDevices);
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
      devices = builtins.listToAttrs (map (device:
        {
          name = device.name;
          value = { id = device.syncthingId; };
        }
      ) (builtins.filter (device: device ? "syncthingId") devices.allDevices));
      folders = builtins.mapAttrs (name: folder:
      {
        path = folder.path;
        devices = (map (device: device.name) devices.allDevices);
        versioning = {
          type = "staggered";
          params.maxAge = 365;
        };
      }) folders;
    };
  };
}