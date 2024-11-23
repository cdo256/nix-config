.PHONY: switch

DEBUG = y

ifndef HOST
    HOST = $(shell hostname)
endif

ifdef DEBUG 
    SHOW_TRACE_FLAG = --show-trace
else
    SHOW_TRACE_FLAG = 
endif
	
switch:
	nixos-rebuild switch --flake .#$(HOST) --impure $(SHOW_TRACE_FLAG)
