# Test the dependency detection and installation

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

init() {
  nos_init "$(cat <<-END
{
  "code_dir": "/tmp/code"
}
END
)"
}

@test "detects mysql dependency" {
  init

  cat > /tmp/code/Gemfile <<-END
source 'https://rubygems.org'

gem 'mysql'
END

  deps="$(query_dependencies)"

  [ "$deps" = "mysql-client" ]
}

@test "detects memcache dependency" {
  init

  cat > /tmp/code/Gemfile <<-END
source 'https://rubygems.org'

gem 'memcache'
END

  deps="$(query_dependencies)"

  [ "$deps" = "libmemcached" ]
}

@test "detects postgres dependency" {
  init

  cat > /tmp/code/Gemfile <<-END
source 'https://rubygems.org'

gem 'pg'
END

  deps="$(query_dependencies)"

  [ "$deps" = "postgresql96-client" ]
}

@test "detects multiple dependencies" {
  init

  cat > /tmp/code/Gemfile <<-END
source 'https://rubygems.org'

gem 'pg'
gem 'mysql'
gem 'memcache'
END

  deps="$(query_dependencies)"

  [ "$deps" = "mysql-client libmemcached postgresql96-client" ]
}
