# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

create_boxfile() {
  template \
    "boxfile.mustache" \
    "-" \
    "$(boxfile_payload)"
}

boxfile_payload() {
    cat <<-END
{
  "has_bower": $(has_bower),
  "rackup": $(is_webserver rack),
  "unicorn": $(is_webserver unicorn),
  "thin": $(is_webserver thin),
  "puma": $(is_webserver puma),
  "is_rackup": $(is_rackup),
  "can_run": $(can_run),
  "app_rb": $(app_rb),
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
  [[ "$(is_rackup)" = "false" && -f $(code_dir)/app.rb ]] && echo "true" || echo "false"
}

can_run() {
  [[ -f $(code_dir)/config.ru || -f $(code_dir)/app.rb ]] && echo "true" || echo "false"
}

is_rackup() {
  [[ -f $(code_dir)/config.ru ]] && echo "true" || echo "false"
}

webserver() {
  echo $(validate "$(payload "boxfile_webserver")" "string" "rack")
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
  echo $(validate "$(payload "boxfile_js_runtime")" "string" "nodejs-0.12")
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
  if [[ "$(is_rackup)" = "true" && "$(cat $(code_dir)/Gemfile | grep '$(webserver)')" = "" ]]; then
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
  (cd $(code_dir); run_subprocess "bundle install" "bundle install --path vendor/bundle")
}

bundle_clean() {
  (cd $(code_dir); run_subprocess "bundle clean" "bundle clean")
}