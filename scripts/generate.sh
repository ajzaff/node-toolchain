#!/bin/bash

set -e

generate() {
  local version=$1
  local nodetag=$2
  local tag=$3
  echo "---> $tag"
  sed -e "s/{{__toolchain_base_image__}}/node:$nodetag/" \
      -e "s/{{__toolchain_version__}}/$version/" \
      -e "s/{{__toolchain_tag__}}/$tag/" Dockerfile \
      > "out/Dockerfile-$tag"
}


version_patch=$(node -e "process.stdout.write(require('./package.json').version)")
version_minor=$(echo -n ${version_patch} | grep -o [0-9].[0-9] | head -1)
version_major=$(echo -n ${version_patch} | grep -o [0-9] | head -1)

mkdir -p out

echo generate v$version_patch
echo

generate $version_patch alpine latest

for tag in $(cat tags.txt)
do
  generate $version_patch $tag $version_patch-node-$tag
  generate $version_minor $tag $version_minor-node-$tag
  generate $version_major $tag $version_major-node-$tag
done
