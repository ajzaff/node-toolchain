#!/bin/bash

set -e

mkdir -p out

version_patch=$(node -e "process.stdout.write(require('./package.json').version)")
version_minor=$(echo -n ${version_patch} | grep -o [0-9].[0-9] | head -1)
version_major=$(echo -n ${version_patch} | grep -o [0-9] | head -1)

echo generate v$version_patch
echo

for tag in $(cat tags.txt)
do
  echo "---> ${version_patch}-node-${tag}"
  sed -e "s/{{__toolchain_base_image__}}/node:$tag/" \
      -e "s/{{__toolchain_version__}}/${version_patch}/" \
      -e "s/{{__toolchain_tag__}}/${version_patch}-node-${tag}/" Dockerfile \
      > "out/Dockerfile-${version_patch}-node-${tag}"

  echo "---> ${version_minor}-node-${tag}"
  sed -e "s/{{__toolchain_base_image__}}/node:$tag/" \
      -e "s/{{__toolchain_version__}}/${version_minor}/" \
      -e "s/{{__toolchain_tag__}}/${version_minor}-node-${tag}/" Dockerfile \
      > "out/Dockerfile-${version_minor}-node-${tag}"

  echo "---> ${version_major}-node-${tag}"
  sed -e "s/{{__toolchain_base_image__}}/node:$tag/" \
      -e "s/{{__toolchain_version__}}/${version_major}/" \
      -e "s/{{__toolchain_tag__}}/${version_major}-node-${tag}/" Dockerfile \
      > "out/Dockerfile-${version_major}-node-${tag}"
done
