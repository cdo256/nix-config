#!/bin/sh

workspace=$(swaymsg -t get_workspaces | jq '.[].name' | tr -d '"' | wofi -d)
swaymsg workspace $workspace
