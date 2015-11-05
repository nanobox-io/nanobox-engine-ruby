# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

ruby_requires_postgres() {
  if [[ "$(cat $(nos_code_dir)/Gemfile | grep 'pg' )" != "" && "$(cat $(nos_code_dir)/Boxfile | grep 'postgresql')" != "" ]]; then
    echo "true"
  else
    echo "false"
  fi
}

ruby_install_postgres_dev_libs() {
  nos_install "postgresql94-client"
}