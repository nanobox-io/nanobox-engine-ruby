# Test the bundle functionality

# source the Nos framework
. /opt/nanobox/nos/common.sh

# source the nos test helper
. util/nos.sh

# source stub.sh to stub functions and binaries
. util/stub.sh

# initialize nos
nos_init

# source the ruby libraries
. ${engine_lib_dir}/ruby.sh

setup() {
  rm -rf /tmp/code
  mkdir -p /tmp/code
  nos_reset_payload
}

@test "bundle install will not run without a Gemfile" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  bundle_ran="false"

  stub_and_eval "nos_run_process" "bundle_ran=\"true\""

  bundle_install

  restore "nos_run_process"
  bundle_installed="false"

  [ "$bundle_ran" = "false" ]
}

@test "bundle install will run if a Gemfile file is present" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  bundle_ran="false"

  stub_and_eval "nos_run_process" "bundle_ran=\"true\""

  mkdir -p /tmp/code
  touch /tmp/code/Gemfile

  bundle_install

  restore "nos_run_process"

  [ "$bundle_ran" = "true" ]
}

@test "bundle clean will not run without a Gemfile" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  bundle_ran="false"

  stub_and_eval "nos_run_process" "bundle_ran=\"true\""

  bundle_clean

  restore "nos_run_process"
  bundle_installed="false"

  [ "$bundle_ran" = "false" ]
}

@test "bundle clean will run if a Gemfile file is present" {

  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"

  bundle_ran="false"

  stub_and_eval "nos_run_process" "bundle_ran=\"true\""

  mkdir -p /tmp/code
  touch /tmp/code/Gemfile

  bundle_clean

  restore "nos_run_process"

  [ "$bundle_ran" = "true" ]
}
