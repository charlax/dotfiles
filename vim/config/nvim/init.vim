set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Load Neovim-specific Lua configuration after plugins are loaded
autocmd VimEnter * ++once lua require('nvim_config')
