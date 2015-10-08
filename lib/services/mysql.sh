# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

requires_mysql() {
  if [[ "$(cat $(code_dir)/Gemfile | grep 'mysql' )" != "" && "$(cat $(code_dir)/Boxfile | grep 'mysql')" != "" ]]; then
    echo "true"
  else
    echo "false"
  fi
}

install_mysql_dev_libs() {
  install "mysql-client"
}