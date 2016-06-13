# Test the nodejs_runtime selection

# source the Nos framework
. /opt/nanobox/nos/common.sh

# source the nos test helper
. util/nos.sh

# source stub.sh to stub functions and binaries
. util/stub.sh

# initialize nos
nos_init

# source the nodejs libraries
. ${engine_lib_dir}/nodejs.sh

setup() {
  rm -rf /tmp/code
  mkdir -p /tmp/code
  nos_reset_payload
}

@test "detects if nodejs is needed" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  # should return false without a package.json
  [ "$(is_nodejs_required)" = "false" ]

  # should return true with a package.json
  touch /tmp/code/package.json
  [ "$(is_nodejs_required)" = "true" ]
}

@test "detects nodejs_runtime from package.json" {
  skip
  # todo: implement functionality
}

@test "default nodejs_runtime uses package.json if available" {

  stub_and_echo "package_json_runtime" "nodejs-from-package-json"

  default=$(nodejs_default_runtime)

  restore "package_json_runtime"

  [ "$default" = "nodejs-from-package-json" ]
}

@test "default nodejs_runtime falls back to a hard-coded default" {

  stub_and_echo "package_json_runtime" "false"

  default=$(nodejs_default_runtime)

  restore "package_json_runtime"

  [ "$default" = "nodejs-4.2" ]
}

@test "nodejs_runtime is chosen from the Boxfile if present" {

    nos_init "$(cat <<-END
{
  "config": {
    "nodejs_runtime": "config-nodejs_runtime"
  }
}
END
)"

  nodejs_runtime=$(nodejs_runtime)

  [ "$nodejs_runtime" = "config-nodejs_runtime" ]
}

@test "nodejs_runtime falls back to default nodejs_runtime" {

  stub_and_echo "nodejs_default_runtime" "default-nodejs_runtime"

  default=$(nodejs_default_runtime)

  restore "package_json_runtime"

  [ "$default" = "default-nodejs_runtime" ]
}

@test "sets nodejs_runtime for later use" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  mkdir -p /tmp/code/node_modules

  stub_and_echo "nodejs_runtime" "custom-nodejs_runtime"

  nodejs_persist_runtime

  restore "nodejs_runtime"

  [ "$(cat /tmp/code/node_modules/runtime)" = "custom-nodejs_runtime" ]
}

@test "detects when nodejs_runtime hasn't changed" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  stub_and_echo "nodejs_runtime" "custom-nodejs_runtime"

  mkdir -p /tmp/code/node_modules
  echo "custom-nodejs_runtime" > /tmp/code/node_modules/runtime

  changed=$(nodejs_check_runtime)

  restore "nodejs_runtime"

  [ "$changed" = "false" ]
}

@test "detects when nodejs_runtime has changed" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  stub_and_echo "nodejs_runtime" "new-nodejs_runtime"

  mkdir -p /tmp/code/node_modules
  echo "old-nodejs_runtime" > /tmp/code/node_modules/nodejs_runtime

  changed=$(nodejs_check_runtime)

  restore "nodejs_runtime"

  [ "$changed" = "true" ]
}
