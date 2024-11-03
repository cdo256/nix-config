.PHONY: switch

ifeq ($(DEBUG), 1)
    SHOW_TRACE_FLAG = --show-trace
else
    SHOW_TRACE_FLAG =
endif
	
switch:
	nixos-rebuild switch --flake /etc/nixos#halley --impure $(SHOW_TRACE_FLAG)

