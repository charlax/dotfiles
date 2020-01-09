<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# Table of Contents

- [Cheatsheet for regex](#cheatsheet-for-regex)
  - [Replace regex](#replace-regex)
  - [Delete everything in parentheses](#delete-everything-in-parentheses)
  - [Grab email only, replacing the whole line](#grab-email-only-replacing-the-whole-line)
  - [Delete everything after a character](#delete-everything-after-a-character)
  - [Replace newline character "^M" and "^@"](#replace-newline-character-%5Em-and-%5E)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Cheatsheet for regex

Inspired by [vimtips](http://rayninfo.co.uk/vimtips.html).

## Replace regex

Replace all date in format `YYYYMMDD` to `MM/DD/YYYY`:

```
%s/\(20\d\{2}\)\(\d\{2}\)\(\d\{2}\)/\2\/\3\/\1/g
```

## Delete everything in parentheses

```
:%s/(.*)//g
```

## Grab email only, replacing the whole line

E.g. on the following file:

```
Charlax <toaster@toasting.org>
```

Execute:

```
:%s/.*<//g
:%s/>//g
```

## Delete everything after a character

E.g.:

```
* Toaster: 1
* Toaster: 2
```

To delete everything after `:`:

```
:%s/:.*//
```

## Replace newline character "^M" and "^@"

```
:%s/<Ctrl-V><Ctrl-M>/\r/g
```

## Add a unique id to Markdown titles

This is a good example of a complex regex which uses `\=` to trigger vim
command execution.

```
%s%^\(#\+.*\)$%\=submatch(1).' (id::'.substitute(system('LC_ALL=C tr -cd "[:alnum:]" < /dev/urandom | fold -w15 | head -n1'), '\n','','g').')'%g
```

It will transform:

```
# Test
```

Into:

```
# Test (id::nYgp7segfLWXeWM)
```
