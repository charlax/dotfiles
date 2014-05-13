#!/bin/sh

# Quick shortcut to highlight some code for copy pasting into Keynote
# Took inspiration from https://gist.github.com/jimbojsb/1630790

highlight -O rtf "$1" | pbcopy
