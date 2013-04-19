#!/bin/sh

git checkout master
git branch --merged | grep -v "\*" | xargs -n 1 git branch -d
