<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# Table of Contents

- [Unsorted](#unsorted)
  - [See what port a given process ID has open using lsof](#see-what-port-a-given-process-id-has-open-using-lsof)
  - [Check which process is using a given port](#check-which-process-is-using-a-given-port)
  - [Count number of lines of code (requires cloc)](#count-number-of-lines-of-code-requires-cloc)
  - [Get certificate information](#get-certificate-information)
  - [Show which line is missing in file1 but is in file2](#show-which-line-is-missing-in-file1-but-is-in-file2)
  - [Get high-level overview of your machine's performance](#get-high-level-overview-of-your-machines-performance)
  - [Setup an ssh tunnel that tunnel localhost:4479 to remote:4479](#setup-an-ssh-tunnel-that-tunnel-localhost4479-to-remote4479)
  - [List all computers in the network](#list-all-computers-in-the-network)
  - [Continue partially downloaded file](#continue-partially-downloaded-file)
  - [Continue partially downloaded file, reconnecting when idle and retrying indefinitely](#continue-partially-downloaded-file-reconnecting-when-idle-and-retrying-indefinitely)
  - [Keep only the second column of a ':' delimited file](#keep-only-the-second-column-of-a--delimited-file)
  - [Keep only the fourth column of a ' ' delimited tabular file](#keep-only-the-fourth-column-of-a---delimited-tabular-file)
  - [Remove all occurrences of quotes](#remove-all-occurrences-of-quotes)
  - [Count number of occurrence of lines](#count-number-of-occurrence-of-lines)
  - [Diff the n first lines of two files](#diff-the-n-first-lines-of-two-files)
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
- [Git](#git)
  - [Get the git authors' email for the last 60 days](#get-the-git-authors-email-for-the-last-60-days)
  - [List committers sorted by number of commits](#list-committers-sorted-by-number-of-commits)
  - [Checkout commit by date](#checkout-commit-by-date)
  - [Show which local branch is tracking which remote branch (git)](#show-which-local-branch-is-tracking-which-remote-branch-git)
- [String manipulation (sed, awk, etc.)](#string-manipulation-sed-awk-etc)
  - [Remove line matching pattern](#remove-line-matching-pattern)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Unsorted

## See what port a given process ID has open using lsof

```
lsof -p PID
```

## Check which process is using a given port

```
lsof -i :PORT_NUMBER
```

## Count number of lines of code (requires cloc)

```
cloc .
```

## Get certificate information

```
openssl x509 -in file.crt -text
```

## Show which line is missing in file1 but is in file2

```
comm -23 file1.txt file2.txt
```

## Get high-level overview of your machine's performance

```
glances  # requires pip install glances
```

## Setup an ssh tunnel that tunnel localhost:4479 to remote:4479

```
# -f: background
# -N: do not issue a command
# -L [bind_address:]port:host:hostport
ssh -f -N -L 4479:localhost:4479 remote
```

## List all computers in the network

```
arp -a
```

## Continue partially downloaded file

```
wget -c http://...
```

## Continue partially downloaded file, reconnecting when idle and retrying indefinitely

```
wget -c --tries=0 --read-timeout=20 http://
```

## Keep only the second column of a ':' delimited file

```
cat filename | cut -d':' -f2
```

## Keep only the fourth column of a ' ' delimited tabular file

```
cat filename | cut -d\  -f4
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

## Get python docs on function (defined in aliases.sh)

```
pydoc sorted
```

## Remove files from list

```
xargs rm < ../../../../.unused_cassette.log
````

## Add a TOC to all markdown files (requires doctoc)

```
doctoc .
```

## Uninstall all python packages including "toaster" in their name

```
pip freeze | grep toaster | xargs pip uninstall -y

```

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

# Git

## Get the git authors' email for the last 60 days

```
git log --since=60.days --format='%ae' | sort -u
```

## List committers sorted by number of commits

```
git shortlog -ns
```

## Checkout commit by date

```
git checkout `git rev-list -n 1 --before="2016-03-29 12:00" master`
```

## Show which local branch is tracking which remote branch (git)

```
git remote show origin
```

# String manipulation (sed, awk, etc.)

## Remove line matching pattern

```
cat file | sed '/^-\+/d'
```