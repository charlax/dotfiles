Plugins
=======

I am using [vim-plug](https://github.com/junegunn/vim-plug).

* Add a plugin by adding a `Plug` line in `vimrc`.
* Update plugins with `:PlugUpdate`.
* Upgrade vim-plug from time to time with `:PlugUpgrade`.
* Remove a plugin by removing the line, running `:PlugClean`. Look for other
  mentions of the plugin in the repo by using `ag`.

List of plugins
---------------

Check the `vimrc` for an up-to-date list and description.

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
