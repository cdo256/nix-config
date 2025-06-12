{
  flake,
  lib,
  ...
}:

let
  machines = {
    rhiannon = {
      name = "rhiannon";
      type = "server";
      ipAddr = "139.162.147.31";
    };
    makeda = {
      name = "makeda";
      type = "server";
      ipAddr = "172.104.147.15";
      sshKeyFile = flake + "/files/makeda.pub";
    };
    peter = {
      name = "peter";
      syncthingId = "B7GQEP-LCS4VN6-N3LORSY-24NTMW3-AJ6DVUE-T2CFXIH-7EITS46-ZFBXWAD";
      type = "desktop";
      #sshPublicKey = ""; #TODO
    };
    isaac = {
      name = "peter";
      syncthingId = "5B7GQEP-LCS4VN6-N3LORSY-24NTMW3-AJ6DVUE-T2CFXIH-7EITS46-ZFBXWAD";
      type = "laptop";
      #sshPublicKey = ""; #TODO
    };
    halley = {
      name = "halley";
      syncthingId = "5Y5D72K-I4AOOJS-MAXNQUR-ISK7SGZ-QWQ6VN6-FGK37VW-QJFWOHY-UAKJUQZ";
      type = "laptop";
      sshKeyFile = flake + "/files/halley.pub";
    };
    vm1 = {
      name = "vm1";
      type = "vm";
    };
    a34 = {
      name = "a34";
      syncthingId = "RYS4YUR-ZYVE46Q-NBUAAKM-I7TX46Z-JSM367B-RGCIYTY-TC6TVV6-GYWSPAF";
      type = "phone";
    };
    s9 = {
      name = "s9";
      syncthingId = "X4EZQ7E-ZD5KA3Q-XVU77YT-KDJIBZ4-FMMMSW7-5V6IMMI-VQEHC5O-4ZBEMA5";
      type = "tablet";
    };
  };
in
{
  options.devices = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    description = "A set of machine configurations.";
  };
  config.devices = machines // {
    linuxDevices = [
      machines.rhiannon
      machines.makeda
      machines.isaac
      machines.peter
      machines.halley
    ];
    nixosDevices = [
      machines.makeda
      machines.isaac
      machines.peter
      machines.halley
    ];
    androidDevices = [
      machines.s9
      machines.a34
    ];
    allDevices = [
      machines.rhiannon
      machines.makeda
      machines.isaac
      machines.peter
      machines.halley
      machines.s9
      machines.a34
    ];
    pcs = [
      machines.peter
      machines.isaac
      machines.halley
    ];
    commonKeys = [
      machines.halley.sshKeyFile
      machines.makeda.sshKeyFile
    ];
  };
}
