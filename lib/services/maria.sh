# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

requires_maria() {
  if [[ "$(cat $(code_dir)/Gemfile | grep 'mysql' )" != "" && "$(cat $(code_dir)/Boxfile | grep 'mariadb')" != "" ]]; then
    echo "true"
  else
    echo "false"
  fi
}

install_maria_dev_libs() {
  install "mariadb-galera-client"
}