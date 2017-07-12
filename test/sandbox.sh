#!/bin/bash
#
# Launches the test environment within a docker container
# and drops into a console

test_dir="$(dirname $(readlink -f $BASH_SOURCE))"
engine_dir="$(dirname ${test_dir})"

# source the env helper
. $test_dir/util/env.sh

docker run \
  -it \
  -u=gonano \
  --name=ruby_sandbox \
  --privileged=true \
  --workdir=/test \
  -e "PATH=$(path)" \
  --volume=${test_dir}/:/test \
  --volume=${engine_dir}/:/engine \
  --volume=/tmp/pkgsrc:/data/var/db/pkgin/cache \
  nanobox/build \
  /bin/bash

docker rm ruby_sandbox