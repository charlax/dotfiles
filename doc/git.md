<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [git](#git)
  - [Solving git conflicts](#solving-git-conflicts)
    - [Conflict markers (while rebasing)](#conflict-markers-while-rebasing)
  - [Troubleshooting](#troubleshooting)
    - ["There are too many unreachable loose objects"](#there-are-too-many-unreachable-loose-objects)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# git

## Solving git conflicts

Open the file in Vim, then `:Gvdiffsplit!`

- Left is target (rebase: their changes)
- Middle is working copy
- Right is merge branch (rebase: our changes)

1. Move to the chunk (with `]c` next chunk, `[c` previous) you want to keep and use the `dp` shortcut ("diff put")
2. Once if the file is done, `:Gwrite`

http://vimcasts.org/episodes/fugitive-vim-resolving-merge-conflicts-with-vimdiff/

### Conflict markers (while rebasing)

```text
# <<<<<<< HEAD
# their changes (target branch)
# ||||||| parent of commit_id <commit_message>
# our common ancestor
# =======
# my changes (my working branch)
# >>>>>>> commit_id (commit_message)
```

```bash
# show changes they made to a file
git diff REBASE_HEAD...origin/main $filename
```

## Troubleshooting

### "There are too many unreachable loose objects"

```text
remote: error: The last gc run reported the following. Please correct the root cause
remote: and remove gc.log.
remote: Automatic cleanup will not be performed until the file is removed.
remote:
remote: warning: There are too many unreachable loose objects; run 'git prune' to remove them.
```

Try:

```bash
# verify connectivity
git fsck

# dangerous
git gc --prune=now
```
