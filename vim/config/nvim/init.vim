set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
luafile ~/.dotfiles/vim/init.lua

" Load Neovim-specific Lua configuration after plugins are loaded
autocmd VimEnter * ++once lua require('nvim_config')
