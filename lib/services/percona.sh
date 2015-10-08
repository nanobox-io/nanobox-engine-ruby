# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

requires_percona() {
  if [[ "$(cat $(code_dir)/Gemfile | grep 'mysql' )" != "" && "$(cat $(code_dir)/Boxfile | grep 'percona')" != "" ]]; then
    echo "true"
  else
    echo "false"
  fi
}

install_percona_dev_libs() {
  install "percona-xtradb-client"
}