{ config, pkgs, devices, ... }:

let
  folders = {
    "sync" = {
      path = "/home/cdo/sync/root";
      devices = devices.linuxDevices;
    };
    "org" = {
      path = "/home/cdo/sync/org";      
      devices = devices.linuxDevices;
    };
    "org-roam" = {
      path = "/home/cdo/sync/org-roam";
      devices = devices.linuxDevices;
    };
    "secure" = {
      path = "/home/cdo/sync/secure";
      devices = [ "peter" "isaac" "a34" "halley" "s9" ];
      versioning = {
        type = "staggered";
        params.maxAge = 365;
      };
    };
  } // {
    map (androidDevice:
      (androidDevice + "-root") = {
        path = "/home/cdo/sync/" + androidDevice;
        devices = androidDevice + devices.linuxDevices;
      }) devices.androidDevices;
  };
}
in
{
  "f" = folders;
}