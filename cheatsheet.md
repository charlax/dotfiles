<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# Table of Contents

- [Unsorted](#unsorted)
  - [See what port a given process ID has open using lsof](#see-what-port-a-given-process-id-has-open-using-lsof)
  - [Check which process is using a given port](#check-which-process-is-using-a-given-port)
  - [Count number of lines of code (requires cloc)](#count-number-of-lines-of-code-requires-cloc)
  - [Get certificate information](#get-certificate-information)
  - [Get high-level overview of your machine's performance](#get-high-level-overview-of-your-machines-performance)
  - [List all computers in the network](#list-all-computers-in-the-network)
  - [Continue partially downloaded file](#continue-partially-downloaded-file)
  - [Continue partially downloaded file, reconnecting when idle and retrying indefinitely](#continue-partially-downloaded-file-reconnecting-when-idle-and-retrying-indefinitely)
  - [Get python docs on function (defined in aliases.sh)](#get-python-docs-on-function-defined-in-aliasessh)
  - [Remove files from list](#remove-files-from-list)
  - [Add a TOC to all markdown files (requires doctoc)](#add-a-toc-to-all-markdown-files-requires-doctoc)
  - [Uninstall all python packages including "toaster" in their name](#uninstall-all-python-packages-including-toaster-in-their-name)
  - [Echo to a file that needs sudo access](#echo-to-a-file-that-needs-sudo-access)
  - [Find a pid using pgrep. '-f' tells pgrep to match against everything, not just process name](#find-a-pid-using-pgrep--f-tells-pgrep-to-match-against-everything-not-just-process-name)
  - [Kill process matching pattern](#kill-process-matching-pattern)
  - [Define default argument in bash script](#define-default-argument-in-bash-script)
  - [Iterate over a list of things in a text file](#iterate-over-a-list-of-things-in-a-text-file)
  - [Run command once per line of input](#run-command-once-per-line-of-input)
  - [Create gif from video](#create-gif-from-video)
  - [Download files numbered 1 to 20](#download-files-numbered-1-to-20)
- [Images](#images)
  - [Resize while keeping aspect ratio](#resize-while-keeping-aspect-ratio)
- [Git](#git)
  - [Get the git authors' email for the last 60 days](#get-the-git-authors-email-for-the-last-60-days)
  - [List committers sorted by number of commits](#list-committers-sorted-by-number-of-commits)
  - [Checkout commit by date](#checkout-commit-by-date)
  - [Show which local branch is tracking which remote branch (git)](#show-which-local-branch-is-tracking-which-remote-branch-git)
  - [Show commits by author](#show-commits-by-author)
  - [Show only staged changes](#show-only-staged-changes)
- [String manipulation (sed, awk, etc.)](#string-manipulation-sed-awk-etc)
  - [Remove line matching pattern](#remove-line-matching-pattern)
  - [Keep only the fourth column of a ' ' delimited tabular file](#keep-only-the-fourth-column-of-a---delimited-tabular-file)
  - [Remove all occurrences of quotes](#remove-all-occurrences-of-quotes)
  - [Count number of occurrence of lines](#count-number-of-occurrence-of-lines)
  - [Diff the n first lines of two files](#diff-the-n-first-lines-of-two-files)
  - [Hide first line of output](#hide-first-line-of-output)
- [SSH](#ssh)
  - [Setup an SSH tunnel that tunnel localhost:4479 to remote:4479](#setup-an-ssh-tunnel-that-tunnel-localhost4479-to-remote4479)
  - [Setup an SSH tunnel that tunnels localhost:PORT to remote:PORT through another hop](#setup-an-ssh-tunnel-that-tunnels-localhostport-to-remoteport-through-another-hop)
- [Stats](#stats)
  - [Show list of most invited emails in calendar](#show-list-of-most-invited-emails-in-calendar)
- [System](#system)
  - [Show most used commands](#show-most-used-commands)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# DEPRECATED

This page is deprecated, now using `cheat` and the `cheatsheets/` folder in the
dotfiles repo.

# Unsorted

## Get certificate information

```
openssl x509 -in file.crt -text
```

## List all computers in the network

```
arp -a
```

## Remove files from list

```
xargs rm < ../../../../.unused_cassette.log
````

## Echo to a file that needs sudo access

```
sudo sh -c 'echo "Text I want to write" >> /path/to/file'
```

## Find a pid using pgrep. '-f' tells pgrep to match against everything, not just process name

```
pgrep -f python
```

## Kill process matching pattern

```
pkill -f python
```

## Define default argument in bash script

```
ARG1=${1:-foo}
```

## Iterate over a list of things in a text file

```
for toaster in $(cat toasters.txt) ; do
     echo ${toaster}
done
```

## Run command once per line of input

```
cat file.txt | xargs -n1 echo
```

## Create gif from video

```
gifify screencast.mkv -o screencast.gif --resize 800:-1
```

## Download files numbered 1 to 20

```
wget http://cloud.com/1/{1..20}.py
```

# String manipulation (sed, awk, etc.)

## Remove line matching pattern

```
cat file | sed '/^-\+/d'
```

## Keep only the fourth column of a ' ' delimited tabular file

```
cat filename | cut -d\  -f4
```

## Show only third column, with awk

```bash
cat filename | awk '{ print $3 }'
```

## Remove all occurrences of quotes

```
cat filename | sed "s/[\'\"]//g"
```

## Count number of occurrence of lines

```
cat filename | sort | uniq -c
```

## Diff the n first lines of two files

```
diff <(head -n 1 file1) <(head -n 1 file2)
```

## Hide first line of output

```
cat $FILENAME | sed -n '1!p'
```

# Stats

## Show list of most invited emails in calendar

```
grep -o '[[:alnum:]+\.\_\-]*@[[:alnum:]+\.\_\-]*' file.ics | sort | uniq -c | sort -n | tail -n 100
```

`grep -o` makes grep only show the matching pattern.

# System

## Show most used commands

See `whattoalias` in `functions.zsh`.
