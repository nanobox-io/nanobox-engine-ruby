# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

ruby_requires_percona() {
  if [[ "$(cat $(nos_code_dir)/Gemfile | grep 'mysql' )" != "" && "$(cat $(nos_code_dir)/Boxfile | grep 'percona')" != "" ]]; then
    echo "true"
  else
    echo "false"
  fi
}

ruby_install_percona_dev_libs() {
  nos_install "percona-xtradb-client"
}