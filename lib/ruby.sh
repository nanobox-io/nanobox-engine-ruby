# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# Copy the code into the live directory which will be used to run the app
publish_release() {
  nos_print_bullet "Moving build into live code directory..."
  rsync -a $(nos_code_dir)/ $(nos_app_dir)
}

# Determine the ruby runtime to install. This will first check
# within the Boxfile, then will rely on default_runtime to
# provide a sensible default
runtime() {
  echo $(nos_validate \
    "$(nos_payload "boxfile_runtime")" \
    "string" "$(default_runtime)")
}

# Provide a default ruby version.
default_runtime() {
  gem_runtime=$(gemfile_runtime)

  if [[ "$gem_runtime" = "false" ]]; then
    echo "ruby-2.2"
  else
    echo $gem_runtime
  fi
}

# todo: extract the contents of Gemfile
gemfile_runtime() {
  echo "false"
}

# Install the ruby runtime.
install_runtime() {
  nos_install "$(runtime)" "$(condensed_runtime)-bundler"
}

# The bundler package will look something like ruby22-bundler so
# we need to fetch the condensed runtime to use for the package
condensed_runtime() {
  version=$(runtime)
  echo "${version//[.-]/}"
}

# Install dependencies from Gemfile
bundle_install() {
  if [[ -f $(nos_code_dir)/Gemfile ]]; then

    cd $(nos_code_dir)
    nos_run_subprocess "running bundle install" \
      "bundle install --path vendor/bundle"
    cd -
  fi
}

# Clean the bundle to remove any unecessary gems
bundle_clean() {
  if [[ -f $(nos_code_dir)/Gemfile ]]; then

    cd $(nos_code_dir)
    nos_run_subprocess "cleaning bundle" "bundle clean"
    cd -
  fi
}

# installs dev packages for dependencies of this app
install_dependencies() {
  deps=("$(query_dependencies)")
  nos_install $deps
}

# compiles a list of dependencies that will need to be installed
query_dependencies() {
  deps=()

  # mysql
  if [[ `cat $(nos_code_dir)/Gemfile | grep 'mysql'` ]]; then
    deps+=(mysql-client)
  fi
  # memcache
  if [[ `cat $(nos_code_dir)/Gemfile | grep 'memcache'` ]]; then
    deps+=(libmemcached)
  fi
  # postgres
  if [[ `cat $(nos_code_dir)/Gemfile | grep 'pg'` ]]; then
    deps+=(postgresql94-client)
  fi

  echo "${deps[@]}"
}
