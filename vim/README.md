Installation
============

    $ curl -s https://raw.githubusercontent.com/charlax/dotvim/master/install.py | python

You should read the script before executing it.

Prerequisites
=============

Install MacVim on Mac Os X
--------------------------

You need [Homebrew](http://mxcl.github.com/homebrew/). Dependencies will be installed automatically.

Plugins
=======

I am using [vim-plug](https://github.com/junegunn/vim-plug).

* Add a plugin by adding a `Plug` line in `vimrc`, then add its description
  below.
* Update plugins with `:PlugUpdate`.
* Upgrade vim-plug from time to time with `:PlugUpgrade`.
* Remove a plugin by removing the line, running `:PlugClean` and removing the
  description from the `README.md`. Look for other mentions of the plugin in
  the repo by using `ag`.

List of plugins
---------------

Check the `vimrc` for an up-to-date list and description.

* [ALE](https://github.com/w0rp/ale): Asynchronous Lint Engine
* [auto-pairs](https://github.com/jiangmiao/auto-pairs): insert or delete
  brackets, parens, quotes in pair
* [deoplete](https://github.com/Shougo/deoplete.nvim): asynchronous completion
  framework
* [deoplete-go](https://github.com/zchee/deoplete-go): asynchronous Go
  completion for Neovim
* [Cocoa](http://www.vim.org/scripts/script.php?script_id=2674): a collection
  of scripts designed to make it easier to develop Cocoa/Objective-C
  applications.
* [Flake8](https://github.com/nvie/vim-flake8): runs the currently open file
  through Flake8, a static syntax and style checker for Python source code.
* [FZF](https://github.com/junegunn/fzf.vim): fuzzy file finder
* [json](https://github.com/elzr/vim-json): JSON highlighting script.
* [JSX](https://github.com/mxw/vim-jsx): React JSX syntax highlighting and
  indenting
* [Mako](https://github.com/sophacles/vim-bundle-mako): a collection of scripts
  for the mako templating engine.
* [nerdtree](https://github.com/scrooloose/nerdtree): a tree explorer plugin.
* [Python-Pep8-Indent](https://github.com/hynek/vim-python-pep8-indent) a nicer
  Python indentation style.
* [repeat](https://github.com/tpope/vim-repeat): enable repeating supported
  plugin maps with "."
* [rtf-highlight](https://github.com/jdonaldson/rtf-highlight.git): syntax
  highlighting to RTF
* [Solarized8](https://github.com/lifepillar/vim-solarized8): optimized
  solarized color schemes
* [Stylus](https://github.com/wavded/vim-stylus): syntax highlighting for
  stylus.
* [Tagbar](https://github.com/majutsushi/tagbar): displays tags in a window,
  ordered by class etc.
* [thrift.vim](https://github.com/solarnz/thrift.vim.git): syntax highlighting
  for thrift definition files.
* [ultisnips](https://github.com/SirVer/ultisnips): snippet engine
* [vim-arduino](https://github.com/sinisterstuf/vim-arduino.git): compile and
  deploy Arduino sketches.
* [vim-go](https://github.com/fatih/vim-go.git): go development plugin
* [vim-jinja2-syntax](https://github.com/Glench/Vim-Jinja2-Syntax): an
  up-to-date jinja2 syntax file
* [vim-less](https://github.com/groenewege/vim-less): syntax for LESS (dynamic
  CSS).
* [vim-multiple-cursors](https://github.com/terryma/vim-multiple-cursors.git):
  True Sublime Text style multiple selections for Vim
* [vim-snippets](https://github.com/honza/vim-snippets): snippets file for
  various programming languages.
* [vim-wordmotion](https://github.com/chaoren/vim-wordmotion): more useful word
  motions for Vim
* [xmledit](https://github.com/sukima/xmledit/): help edit XML files.
* [vim-textobj-comment](https://github.com/glts/vim-textobj-comment): text
  objects for comments
* [vim-textobj-user](https://github.com/kana/vim-textobj-user): create your own
  text objects (required by `vim-textobj-comment`).

How to try Vim
==============

If you want to try Vim, just follow these steps:

1. Read [Seven habits of effective text
   editing](http://www.moolenaar.net/habits.html) by Bram Moolenaar (Vim's main
   author)
2. Resist the urge to use a plugin or anyone else’s `vimrc`.
   [Really](http://mislav.uniqpath.com/2011/12/vim-revisited/).
3. Use `vimtutor` to learn the basics.
4. Along the way, add plugins and improve your `.vimrc` little by little,
   making sure you understand and comment all your options.

Feel free to read my article: [Why I use
Vim](http://blog.d3in.org/post/14220797290/why-i-keep-on-using-vim-instead-of-going-back-to)

Here's some other good articles:

* [A Good Vimrc](http://dougblack.io/words/a-good-vimrc.html)

Reference card
==============

Vim shortcuts
-------------

* `<C-w>`: deletes one word backward (in insert mode)
* `<C-u>`: deletes one line (in insert mode)
* `fa` goes to the next `a` character on the same line (in command mode)
* `"kyy` copies the current line into register `k`
* `"kp` paste the content of the register `k`

Custom keyboard shortcuts
-------------------------

* `<leader>pw`: show the Python documentation for the word under the cursor.
* `<F7>` runs `flake8` on the current file.
* `qgic` rewraps the comment block (thanks to `vim-textobj-comment`)

Acknowledgments
===============

Thanks to:

* Drew Neil's [Vimcasts](http://vimcasts.org/)
* [Tim Pope](http://tbaggery.com/)
* [Janus](https://github.com/carlhuda/janus)
