# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

create_boxfile() {
  template \
    "boxfile.mustache" \
    "-" \
    "$(boxfile_payload)"
}

boxfile_payload() {
  _has_bower=$(has_bower)
  _webserver=$(webserver)
  _can_run=$(can_run)
  _app_rb=$(app_rb)
  if [[ "${_can_run}" = "true" ]]; then
    print_bullet_sub "Creating web service"
    if [[ "${_webserver}" = "puma" ]]; then
      print_bullet_info "Using Puma as webserver"
    elif [[ "${_webserver}" = "thin" ]]; then
      print_bullet_info "Using Thin as webserver"
    elif [[ "${_webserver}" = "unicorn" ]]; then
      print_bullet_info "Using Unicorn as webserver"
    elif [[ "${_app_rb}" = "true" ]]; then
      print_bullet_info "Running 'ruby app.rb' to start service"
    fi
  else
    print_warning "Did not find config.ru or app.rb, not configuring web service"
  fi
  if [[ "${_has_bower}" = "true" ]]; then
    print_bullet_sub "Adding lib_dirs for bower"
  fi
  print_bullet "Detecting settings"
  cat <<-END
{
  "has_bower": ${_has_bower},
  "rackup": $(is_webserver rack),
  "unicorn": $(is_webserver unicorn),
  "thin": $(is_webserver thin),
  "puma": $(is_webserver puma),
  "can_run": ${_can_run},
  "app_rb": ${_app_rb},
  "live_dir": "$(live_dir)",
  "etc_dir": "$(etc_dir)",
  "deploy_dir": "$(deploy_dir)"
}
END
}

app_name() {
  # payload app
  echo "$(payload app)"
}

live_dir() {
  # payload live_dir
  echo $(payload "live_dir")
}

deploy_dir() {
  # payload deploy_dir
  echo $(payload "deploy_dir")
}

etc_dir() {
  echo $(payload "etc_dir")
}

code_dir() {
  echo $(payload "code_dir")
}

environment() {
  if [[ -n "$(payload 'env_ENVIRONMENT')" ]]; then
    echo "$(payload 'env_ENVIRONMENT')"
  else
    if [[ "$(payload 'platform')" = 'local' ]]; then
      echo "development"
    else
      echo "production"
    fi
  fi
}

app_rb() {
  if [[ "$(is_rackup)" = "false" && -f $(code_dir)/app.rb ]]; then
    echo "true"
  else
    echo "false"
  fi
}

can_run() {
  if [[ -f $(code_dir)/config.ru || -f $(code_dir)/app.rb ]]; then
    echo "true"
  else
    echo "false"
  fi
}

is_rackup() {
  if [[ -f $(code_dir)/config.ru ]]; then 
    echo "true"
  else
    echo "false"
  fi
}

webserver() {
  _webserver=$(validate "$(payload "boxfile_webserver")" "string" "rack")
  echo ${_webserver}
}

is_webserver() {
  [[ "$(webserver)" = "$1" && "$(is_rackup)" = "true" ]] && echo "true" && return
  echo "false"
}

runtime() {
  echo $(validate "$(payload "boxfile_runtime")" "string" "ruby-2.2")
}

condensed_runtime() {
  version=$(validate "$(payload "boxfile_runtime")" "string" "ruby-2.2")
  echo "${version//[.-]/}"
}

install_runtime() {
  install "$(runtime)"
}

install_bundler() {
  install "$(condensed_runtime)-bundler"
}

js_runtime() {
  _js_runtime=$(validate "$(payload "boxfile_js_runtime")" "string" "nodejs-0.12")
  echo "${_js_runtime}"
}

install_js_runtime() {
  install "$(js_runtime)"
}

set_js_runtime() {
  [[ -d $(code_dir)/node_modules ]] && echo "$(js_runtime)" > $(code_dir)/node_modules/runtime
}

check_js_runtime() {
  [[ ! -d $(code_dir)/node_modules ]] && echo "true" && return
  [[ "$(cat $(code_dir)/node_modules/runtime)" =~ ^$(js_runtime)$ ]] && echo "true" || echo "false"
}

npm_rebuild() {
  [[ "$(check_js_runtime)" = "false" ]] && (cd $(code_dir); run_subprocess "npm rebuild" "npm rebuild")
}

inject_webserver() {
  if [[ "$(is_rackup)" = "true" && "$(cat $(code_dir)/Gemfile | grep $(webserver))" = "" ]]; then
    echo "" >> $(code_dir)/Gemfile
    echo "gem '$(webserver)'" >> $(code_dir)/Gemfile
  fi
}

configure_webserver() {
  mkdir -p $(deploy_dir)/var/run
  [[ "$(webserver)" = "puma" ]] && create_puma_conf
  [[ "$(webserver)" = "thin" ]] && create_thin_conf
  [[ "$(webserver)" = "unicorn" ]] && create_unicorn_conf
}

bundle_install() {
  if [[ -f $(code_dir)/Gemfile ]]; then
    (cd $(code_dir); run_subprocess "bundle install" "bundle install --path vendor/bundle")
  else
    print_bullet_info "Gemfile not found, not running 'bundle install'"
  fi
}

bundle_clean() {
  if [[ -f $(code_dir)/Gemfile ]]; then
    (cd $(code_dir); run_subprocess "bundle clean" "bundle clean")
  else
    print_bullet_info "Gemfile not found, not running 'bundle clean'"
  fi
}