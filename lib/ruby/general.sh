# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

ruby_create_boxfile() {
  nos_template \
    "boxfile.mustache" \
    "-" \
    "$(ruby_boxfile_payload)"
}

ruby_boxfile_payload() {
  _has_bower=$(nodejs_has_bower)
  _webserver=$(ruby_webserver)
  _can_run=$(ruby_can_run)
  _app_rb=$(ruby_app_rb)
  if [[ "${_can_run}" = "true" ]]; then
    nos_print_bullet_sub "Creating web service"
    if [[ "${_webserver}" = "puma" ]]; then
      nos_print_bullet_info "Using Puma as webserver"
    elif [[ "${_webserver}" = "thin" ]]; then
      nos_print_bullet_info "Using Thin as webserver"
    elif [[ "${_webserver}" = "unicorn" ]]; then
      nos_print_bullet_info "Using Unicorn as webserver"
    elif [[ "${_app_rb}" = "true" ]]; then
      nos_print_bullet_info "Running 'ruby app.rb' to start service"
    fi
  else
    nos_print_warning "Did not find config.ru or app.rb, not configuring web service"
  fi
  if [[ "${_has_bower}" = "true" ]]; then
    nos_print_bullet_sub "Adding lib_dirs for bower"
  fi
  nos_print_bullet "Detecting settings"
  cat <<-END
{
  "has_bower": ${_has_bower},
  "rackup": $(ruby_is_webserver rack),
  "unicorn": $(ruby_is_webserver unicorn),
  "thin": $(ruby_is_webserver thin),
  "puma": $(ruby_is_webserver puma),
  "can_run": ${_can_run},
  "app_rb": ${_app_rb},
  "live_dir": "$(nos_live_dir)",
  "etc_dir": "$(nos_etc_dir)",
  "deploy_dir": "$(nos_deploy_dir)"
}
END
}

ruby_app_name() {
  # payload app
  echo "$(nos_payload app)"
}

ruby_environment() {
  if [[ -n "$(nos_payload 'env_ENVIRONMENT')" ]]; then
    echo "$(nos_payload 'env_ENVIRONMENT')"
  else
    if [[ "$(nos_payload 'platform')" = 'local' ]]; then
      echo "development"
    else
      echo "production"
    fi
  fi
}

ruby_app_rb() {
  if [[ "$(ruby_is_rackup)" = "false" && -f $(nos_code_dir)/app.rb ]]; then
    echo "true"
  else
    echo "false"
  fi
}

ruby_can_run() {
  if [[ -f $(nos_code_dir)/config.ru || -f $(nos_code_dir)/app.rb ]]; then
    echo "true"
  else
    echo "false"
  fi
}

ruby_is_rackup() {
  if [[ -f $(nos_code_dir)/config.ru ]]; then 
    echo "true"
  else
    echo "false"
  fi
}

ruby_webserver() {
  _webserver=$(nos_validate "$(nos_payload "boxfile_webserver")" "string" "rack")
  echo ${_webserver}
}

ruby_is_webserver() {
  [[ "$(ruby_webserver)" = "$1" && "$(ruby_is_rackup)" = "true" ]] && echo "true" && return
  echo "false"
}

ruby_runtime() {
  echo $(nos_validate "$(nos_payload "boxfile_ruby_runtime")" "string" "ruby-2.2")
}

ruby_condensed_runtime() {
  version=$(nos_validate "$(nos_payload "boxfile_ruby_runtime")" "string" "ruby-2.2")
  echo "${version//[.-]/}"
}

ruby_install_runtime() {
  nos_install "$(ruby_runtime)"
}

ruby_install_bundler() {
  nos_install "$(ruby_condensed_runtime)-bundler"
}

ruby_inject_webserver() {
  if [[ "$(ruby_is_rackup)" = "true" && "$(cat $(nos_code_dir)/Gemfile | grep $(ruby_webserver))" = "" ]]; then
    echo "" >> $(nos_code_dir)/Gemfile
    echo "gem '$(ruby_webserver)'" >> $(nos_code_dir)/Gemfile
  fi
}

ruby_configure_webserver() {
  mkdir -p $(nos_deploy_dir)/var/run
  [[ "$(ruby_webserver)" = "puma" ]] && ruby_create_puma_conf
  [[ "$(ruby_webserver)" = "thin" ]] && ruby_create_thin_conf
  [[ "$(ruby_webserver)" = "unicorn" ]] && ruby_create_unicorn_conf
}

ruby_bundle_install() {
  if [[ -f $(nos_code_dir)/Gemfile ]]; then
    (cd $(nos_code_dir); nos_run_subprocess "bundle install" "bundle install --path vendor/bundle")
  else
    nos_print_bullet_info "Gemfile not found, not running 'bundle install'"
  fi
}

ruby_bundle_clean() {
  if [[ -f $(nos_code_dir)/Gemfile ]]; then
    (cd $(nos_code_dir); nos_run_subprocess "bundle clean" "bundle clean")
  else
    nos_print_bullet_info "Gemfile not found, not running 'bundle clean'"
  fi
}