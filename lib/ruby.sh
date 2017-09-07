# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# Copy the code into the live directory which will be used to run the app
publish_release() {
  nos_print_bullet "Moving build into live app directory..."
  rsync -a $(nos_code_dir)/ $(nos_app_dir)
}

# Determine the ruby runtime to install. This will first check
# within the Boxfile, then will rely on default_runtime to
# provide a sensible default
runtime() {
  echo $(nos_validate \
    "$(nos_payload "config_runtime")" \
    "string" "$(default_runtime)")
}

# Provide a default ruby version.
default_runtime() {
  gem_runtime=$(gemfile_runtime)

  if [[ "$gem_runtime" = "false" ]]; then
    echo "ruby-2.3"
  else
    echo $gem_runtime
  fi
}

# postgres client version
postgres_version() {
  version=$(nos_validate \
    "$(nos_payload "postgres_client_version")" \
    "string" "$(default_postgres_version)")
    
  # we only need the condensed version
  echo "${version//[.-]/}"
}

# detect the version from the boxfile, or fall back to a sensible default
default_postgres_version() {
  # try to detect the version if specified in the boxfile
  detected=$(detect_postgres_version)
  
  if [[ "$detected" = "" ]]; then
    # the default, fallback
    echo "9.6"
  else
    echo $detected
  fi
}

# try to determine the version automatically
detect_postgres_version() {
  cat $(nos_code_dir)/boxfile.yml \
    | grep "nanobox/postgresql" \
      | awk -F ":" '{print $3}'
}

# todo: extract the contents of Gemfile
gemfile_runtime() {
  echo "false"
}

# Install the ruby runtime along with any dependencies.
install_runtime_packages() {
  pkgs=("$(runtime)" "$(condensed_runtime)-bundler")

  # add any client dependencies
  pkgs+=("$(query_dependencies)")

  nos_install ${pkgs[@]}
}

# Uninstall build dependencies
uninstall_build_packages() {
  # currently ruby doesn't install any build-only deps... I think
  pkgs=()

  # if pkgs isn't empty, let's uninstall what we don't need
  if [[ ${#pkgs[@]} -gt 0 ]]; then
    nos_uninstall ${pkgs[@]}
  fi
}

# The bundler package will look something like ruby22-bundler so
# we need to fetch the condensed runtime to use for the package
condensed_runtime() {
  version=$(runtime)
  echo "${version//[.-]/}"
}

# set the bundle config to ensure gems are installed into vendor
set_bundle_config() {
  mkdir -p "$(nos_code_dir)/.bundle"
  nos_template_file "bundle/config" "$(nos_code_dir)/.bundle/config"
}

# Install dependencies from Gemfile
bundle_install() {
  if [[ -f $(nos_code_dir)/Gemfile ]]; then

    cd $(nos_code_dir)
    nos_run_process "Running bundle install" \
      "bundle install"
    cd - >/dev/null
  fi
}

# Clean the bundle to remove any unecessary gems
bundle_clean() {
  if [[ -f $(nos_code_dir)/Gemfile ]]; then

    cd $(nos_code_dir)
    nos_run_process "Cleaning bundle" "bundle clean"
    cd - >/dev/null
  fi
}

# compiles a list of dependencies that will need to be installed
query_dependencies() {
  deps=()

  # mysql
  if [[ `grep 'mysql' $(nos_code_dir)/Gemfile $(nos_code_dir)/Gemfile.lock` ]]; then
    deps+=(mysql-client)
  fi
  # memcache
  if [[ `grep 'memcache' $(nos_code_dir)/Gemfile $(nos_code_dir)/Gemfile.lock` ]]; then
    deps+=(libmemcached)
  fi
  # postgres
  if [[ `grep 'pg' $(nos_code_dir)/Gemfile $(nos_code_dir)/Gemfile.lock` ]]; then
    deps+=(postgresql$(postgres_version)-client)
  fi
  # redis
  if [[ `grep 'redi' $(nos_code_dir)/Gemfile $(nos_code_dir)/Gemfile.lock` ]]; then
    deps+=(redis)
  fi
  # libxml-ruby
  if [[ `grep 'libxml-ruby' $(nos_code_dir)/Gemfile $(nos_code_dir)/Gemfile.lock` ]]; then
    deps+=(libxml2)
  fi
  # libcurl
  if [[ `grep 'typhoeus' $(nos_code_dir)/Gemfile $(nos_code_dir)/Gemfile.lock` ]]; then
    deps+=(curl)
  fi
  # cld3
  if [[ `grep 'cld3' $(nos_code_dir)/Gemfile $(nos_code_dir)/Gemfile.lock` ]]; then
    deps+=(pkgconf protobuf zlib)
  fi
  # rmagick
  if [[ `grep 'rmagick' $(nos_code_dir)/Gemfile $(nos_code_dir)/Gemfile.lock` ]]; then
    deps+=(ImageMagick6)
    `for i in Magick++-config Magick-config MagickCore-config MagickWand-config Wand-config animate compare composite conjure convert display identify import mogrify montage stream; do ln -sf /data/bin/${i}6 /data/bin/${i}; done`
  fi
  # nokogiri
  if [[ `grep 'nokogiri' $(nos_code_dir)/Gemfile $(nos_code_dir)/Gemfile.lock` ]]; then
    deps+=(pkgconf libxml2 libxslt zlib)
  fi

  echo "${deps[@]}"
}
