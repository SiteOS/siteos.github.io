#!/bin/sh -x

BASE=$(readlink -f $(dirname "$0")/..)

rm -r _side/*
pushd $BASE
	~/bin/bundle exec jekyll serve $*
popd