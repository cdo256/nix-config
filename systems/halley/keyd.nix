{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "overload(control, esc)";
          f6 = "n";
          f7 = "b";
        };
      };
    };
  };
}
