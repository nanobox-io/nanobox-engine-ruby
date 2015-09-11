create_boxfile() {
  template \
    "boxfile.mustache" \
    "-" \
    "$(boxfile_payload)"
}

boxfile_payload() {
    cat <<-END
{
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

ruby_version() {
  echo $(validate "$(payload "boxfile_ruby_version")" "string" "2.2")
}

condensed_ruby_version() {
  version=$(validate "$(payload "boxfile_ruby_version")" "string" "2.2")
  echo ${version//./}
}

install_ruby() {
  install "ruby-$(ruby_version)"
}

install_bundler() {
  install "ruby$(condensed_ruby_version)-bundler"
}

inject_webserver() {
  if [[ "$(is_rackup)" = "true" ]]; then
    echo "" >> $(code_dir)/Gemfile
    echo "gem '$(webserver)'" >> $(code_dir)/Gemfile
  fi
}

configure_webserver() {
  [[ "$(webserver)" = "puma" ]] && create_puma_conf
  [[ "$(webserver)" = "thin" ]] && create_thin_conf
  [[ "$(webserver)" = "unicorn" ]] && create_unicorn_conf
}

bundle_install() {
  (cd $(code_dir); run_process "bundle install" "bundle install --path vendor/bundle")
}

bundle_clean() {
  (cd $(code_dir); run_process "bundle clean" "bundle clean")
}