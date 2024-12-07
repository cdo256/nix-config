.PHONY: switch system-build system-switch home-build home-switch

ifndef HOST
    HOST = $(shell hostname)
endif

ifdef DEBUG 
    SHOW_TRACE_FLAG = --show-trace
else
    SHOW_TRACE_FLAG = 
endif

system-build:
	nixos-rebuild build --flake ".#$(HOST)" --impure $(SHOW_TRACE_FLAG)

system-switch:
	nixos-rebuild switch --flake ".#$(HOST)" --impure $(SHOW_TRACE_FLAG)

home-build:
	nix run .#home-manager -- build --flake ".#cdo" $(SHOW_TRACE_FLAG)

home-switch:
	nix run .#home-manager -- switch --flake ".#cdo" $(SHOW_TRACE_FLAG)

switch: home-switch system-switch