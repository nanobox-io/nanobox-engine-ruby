# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

requires_postgres() {
  if [[ "$(cat $(code_dir)/Gemfile | grep 'pg' )" != "" && "$(cat $(code_dir)/Boxfile | grep 'postgresql')" != "" ]]; then
    echo "true"
  else
    echo "false"
  fi
}

install_postgres_dev_libs() {
  install "postgresql94-client"
}