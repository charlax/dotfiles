# fish_vi_key_bindings

starship init fish | source

# Pritunl
if test -d /Applications/Pritunl.app/Contents/Resources
    fish_add_path --append /Applications/Pritunl.app/Contents/Resources
end

# Load aliases
source ~/.dotfiles/config/fish/aliases.fish
