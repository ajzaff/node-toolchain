#!/bin/bash

set -e

echo release

for file in out/*
do
  tag=$(echo -n $file | sed 's/out\/Dockerfile-\(.*\)/\1/')
  echo "---> $tag"
  docker push toolchain/node:$tag
done


npm publish --access=public
