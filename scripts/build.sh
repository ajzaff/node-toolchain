#!/bin/bash

set -e

echo build

for file in out/*
do
  tag=$(echo -n $file | sed 's/out\/Dockerfile-\(.*\)/\1/')
  echo "---> $tag"
  docker build -t toolchain/node:$tag -f $file .
done
