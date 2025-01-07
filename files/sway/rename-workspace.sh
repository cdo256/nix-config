#!/bin/sh

name=$(wofi -d </dev/null)
swaymsg rename workspace to $name
