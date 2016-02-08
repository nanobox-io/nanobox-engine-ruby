# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

runtime() {
  echo $(nos_validate "$(nos_payload "boxfile_runtime")" "string" "ruby-2.2")
}

condensed_runtime() {
  version=$(nos_validate "$(nos_payload "boxfile_runtime")" "string" "ruby-2.2")
  echo "${version//[.-]/}"
}

install_runtime() {
  nos_install "$(runtime)"
}

install_java_runtime() {
  if [[ "$(runtime)" =~ "jruby" ]]; then
    java_install_runtime
  fi
}

install_bundler() {
  nos_install "$(condensed_runtime)-bundler"
}

bundle_install() {
  if [[ -f $(nos_code_dir)/Gemfile ]]; then
    (cd $(nos_code_dir); nos_run_subprocess "bundle install" "bundle install --path vendor/bundle")
  else
    nos_print_bullet_info "Gemfile not found, not running 'bundle install'"
  fi
}

bundle_clean() {
  if [[ -f $(nos_code_dir)/Gemfile ]]; then
    (cd $(nos_code_dir); nos_run_subprocess "bundle clean" "bundle clean")
  else
    nos_print_bullet_info "Gemfile not found, not running 'bundle clean'"
  fi
}
