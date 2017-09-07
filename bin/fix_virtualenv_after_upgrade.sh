#!/bin/bash

set -e
set -x

find $1 -type l -delete
virtualenv $1
