{ config, pkgs, lib, ... }:

let
  machines =  {
    algernon = {
      name = "algernon";
      type = "server";
      sshPublicKey = ""; #TODO
      ipAddr = "194.163.141.236";
    };
    eugenia = {
      name = "eugenia";
      type = "server";
      ipAddr = "84.247.140.25";
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
      sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGqDnhdlknFB0KhLATaKouZW1jlqchpzuAcScrlOn4XG cdo@halley";
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
    linuxDevices = [ machines.algernon machines.eugenia machines.isaac machines.peter machines.halley ];
    nixosDevices = [ machines.isaac machines.peter machines.halley ];
    androidDevices = [ machines.s9 machines.a34 ];
    allDevices = [ machines.algernon machines.isaac machines.peter machines.halley machines.s9 machines.a34 ];
    pcs = [ machines.peter machines.isaac machines.halley ];
  };
}
