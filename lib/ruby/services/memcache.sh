# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

ruby_requires_memcache() {
  if [[ "$(cat $(nos_code_dir)/Gemfile | grep 'memcache' )" != "" && "$(cat $(nos_code_dir)/Boxfile | grep 'memcached')" != "" ]]; then
    echo "true"
  else
    echo "false"
  fi
}

ruby_install_memcache_dev_libs() {
  nos_install "libmemcached"
}