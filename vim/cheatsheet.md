<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# Table of Contents

- [Cheatsheet](#cheatsheet)
  - [Delete all lines matching patterns](#delete-all-lines-matching-patterns)
  - [Insert tab character when `expandtab` is on](#insert-tab-character-when-expandtab-is-on)
  - [Delete empty lines](#delete-empty-lines)
  - [Insert a blank line after each line](#insert-a-blank-line-after-each-line)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Cheatsheet
==========

## Delete all lines matching patterns

```
:g/profile/d
```

## Insert tab character when `expandtab` is on

```
<ctrl+v><tab>
```

## Delete empty lines

```
:g/^$/d
```

## Insert a blank line after each line

```
:g/^/norm o
```

* `:g/^` acts on every line that matches the `^` regex.
* `norm o` execute the command `o` in normal mode


## Change spellcheck lang

```
:setlocal spell spelllang=fr
```
