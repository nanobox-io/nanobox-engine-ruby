# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

requires_memcache() {
  if [[ "$(cat $(code_dir)/Gemfile | grep 'memcache' )" != "" && "$(cat $(code_dir)/Boxfile | grep 'memcached')" != "" ]]; then
    echo "true"
  else
    echo "false"
  fi
}

install_memcache_dev_libs() {
  install "libmemcached"
}