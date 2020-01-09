" Must be first.
set nocompatible

syntax enable
set encoding=utf-8

" Make sure no shortcut mapped in insert mode is
" using leader, otherwise you might trigger shortcuts while typing.
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

" Specify a directory for plugins (for vim-plug)
call plug#begin('~/.vim/plugged')

Plug '/usr/local/opt/fzf'

" Create your own text objects
Plug 'kana/vim-textobj-user'

" text objects for comments
Plug 'glts/vim-textobj-comment'

" interpret a file by function and cache file automatically
Plug 'MarcWeber/vim-addon-mw-utils'
"
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" insert or delete brackets, parens, quotes in pair
Plug 'jiangmiao/auto-pairs', {'for': ['javascript', 'typescript', 'typescriptreact', 'typescript.tsx']}

Plug 'lifepillar/vim-solarized8'

Plug 'elzr/vim-json', { 'for': 'json' }

Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' }

Plug 'Glench/Vim-Jinja2-Syntax', { 'for': 'jinja2' }

Plug 'greyblake/vim-preview'

" Syntax for LESS (dynamic CSS)
" Plug 'groenewege/vim-less'
"
Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' }
Plug 'nvie/vim-flake8', { 'for': 'python' }

Plug 'jdonaldson/rtf-highlight'

Plug 'junegunn/fzf.vim'

Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plug 'mileszs/ack.vim'

Plug 'msanders/cocoa.vim', { 'for': 'cocoa' }

Plug 'sinisterstuf/vim-arduino', { 'for': 'arduino' }

Plug 'solarnz/thrift.vim', { 'for': 'thrift' }

Plug 'sophacles/vim-bundle-mako', { 'for': 'mako' }

Plug 'sukima/xmledit', { 'for': 'xml' }

" True Sublime Text style multiple selections for Vim
" Plug 'terryma/vim-multiple-cursors'

Plug 'tomtom/tlib_vim'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

Plug 'vim-scripts/LaTeX-Box', { 'for': 'latex' }

Plug 'vim-scripts/applescript.vim', { 'for': 'applescript' }

Plug 'w0rp/ale'

" Automatically discover and properly update ctags files on save
Plug 'ludovicchabant/vim-gutentags'

" Terraform files
Plug 'hashivim/vim-terraform'

"""""""""""""""""""""""""""""""""""""""""
" Front-end dev
"""""""""""""""""""""""""""""""""""""""""

" Note: do not use 'for'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
" Plug 'leafgarland/typescript-vim'  " does not work since typescriptreact
Plug 'HerringtonDarkholme/yats.vim'

" Match HTML tags
Plug 'Valloric/MatchTagAlways'

" Auto close HTML tags
Plug 'alvan/vim-closetag'

"""""""""""""""""""""""""""""""""""""""""
" Other
"""""""""""""""""""""""""""""""""""""""""

" .editorconfig support
Plug 'editorconfig/editorconfig-vim'

" Clojure REPL
Plug 'tpope/vim-fireplace'

if has("nvim")
    " asynchronous completion framework for neovim/Vim8
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-go', { 'do': 'make'}
else
    " asynchronous completion framework for neovim/Vim8
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

" Initialize plugin system
call plug#end()

" ============================================================
" Filetype detection
" ============================================================

if has("autocmd")
    " load file type plugins + indentation
    filetype plugin indent on

    " Custom initialization
    au BufRead,BufNewFile *.applescript setf applescript
    au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} set ft=ruby

    " Varnish
    au BufRead,BufNewFile *.vcl setf c

    " Prose
    au FileType {md,markdown,tex,txt,rst} call s:setup_for_prose()

    " In Makefiles, use real tabs, not tabs expanded to spaces
    au FileType make set noexpandtab ts=4

    " Use tabs in Applescript
    au FileType applescript set noexpandtab smartindent

    " Yaml
    au FileType yaml set softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent

    " HTML, XML, etc.
    au FileType xml set softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent
    au FileType xsd set softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent

    " SQL
    au FileType sql set softtabstop=4 tabstop=4 shiftwidth=4 expandtab autoindent

    " ZSH
    au FileType zsh set expandtab

    " Json
    au FileType json set softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent

    " Remember last location in file, except in Git commit message
    au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
          \| exe "normal! g`\"" | endif

    autocmd FileType arduino,c,cpp,java,php,python,javascript,html,css,mako,sql,json,rst,cucumber,yaml,zsh autocmd BufWritePre <buffer> :call TrimEndLines()

endif


" ============================================================
" Vim UI configuration
" ============================================================


set termguicolors
if has('gui_running') || has('gui_vimr')
    set background=dark
else
    set background=dark
endif
colorscheme solarized8

" display incomplete commands
set showcmd

" Store lots of :cmdline history
set history=1000

" Reload files changed outside vim
set autoread

" Sets the terminal title to Vim title
set title

" Whitespace
set tabstop=4 shiftwidth=4
set softtabstop=4 " makes the spaces feel like real tabs
set expandtab

" Remove trailing whitespace before save
autocmd BufWritePre * :call StripTrailingWhitespaces()

" Backspace through everything in insert mode
set backspace=indent,eol,start

" No bell
set visualbell

" Leaving buffer goes into normal mode
autocmd BufEnter * stopinsert

" Files to hide in netrw
let g:netrw_list_hide= '.*\.swp$,.*\.pyc$'

" All folds open when open a file
set foldlevelstart=20

" More natural split opening
set splitbelow
set splitright

" ============================================================
" Wrapping, textwidth, text formatting
" ============================================================

" Softwrapping
setlocal textwidth=0
setlocal wrap
set colorcolumn=79

" Showing invisible characters with the same characters that TextMate uses
set list
set listchars=tab:▸\ ,eol:¬

" :help fo-table
" q: Allow formatting of comments with "gq".
" c: Auto-wrap comments using textwidth
" n: When formatting text, recognize numbered lists.
" 1: Don't break a line after a one-letter word.
setlocal formatoptions=qcn1

function! s:setup_for_prose()
    setlocal textwidth=79
    setlocal linebreak
    setlocal spell
    " For bulleted list to get correct indentation
    setlocal autoindent
endfunction


" ============================================================
" Searching
" ============================================================

" Highlight searches by default
set hlsearch

" Find the next match as we type the search
set incsearch
set ignorecase
set smartcase

" Clearing highlighted searches
nmap <silent> ,/ :nohlsearch<CR>

" Tab completion
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,*.pyc,.svn,vendor/gems/*,*/build/*

" show list instead of just completing
set wildmenu
" command <Tab> completion, list matches, then longest common part, then all.
set wildmode=list:longest,full

" Status bar
set laststatus=2
set statusline=%y                      " filetype
set statusline+=\ %F                   " full path to file
set statusline+=%h%m%r                 " flags
set statusline+=%=                     " right-align
set statusline+=%l/%L\ (%P)\ c\ %c\ \  " cursor column, line, total lines, %

" Provide some context when editing
set scrolloff=5

" Line numbers
set number

" Fixing Vim's regex handling
nnoremap / /\v
vnoremap / /\v

" ============================================================
" Paths
" ============================================================

" where to put backup files.
set backupdir=~/.vim/temp/backup
" useful for webpack-dev-server
set backupcopy=yes
" where to put swap files.
set directory=~/.vim/temp/temp
" .netrwhist
let g:netrw_home = expand('~/.vim/temp/')

" tags
set tags=./tags;,./tags_env;

" My other functions

source $HOME/.vim/my_functions.vim
source $HOME/.vim/abbreviations.vim
" Plugin-specific configuration
source $HOME/.vim/pluginsrc.vim
" Keyboard shortcuts
source $HOME/.vim/keys.vim
