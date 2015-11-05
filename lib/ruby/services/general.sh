# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# runs through the list of known service types and if the app requires them,
# it will install the necessary 'dev' packages
ruby_install_dependencies() {
  # maria
  if [[ "$(ruby_requires_maria)" = "true" ]]; then
    ruby_install_maria_dev_libs
  fi
  # memcache
  if [[ "$(ruby_requires_memcache)" = "true" ]]; then
    ruby_install_memcache_dev_libs
  fi
  # mongo
  if [[ "$(ruby_requires_mongo)" = "true" ]]; then
    ruby_install_mongo_dev_libs
  fi
  # mysql
  if [[ "$(ruby_requires_mongo)" = "true" ]]; then
    ruby_install_mongo_dev_libs
  fi
  # percona
  if [[ "$(ruby_requires_percona)" = "true" ]]; then
    ruby_install_percona_dev_libs
  fi
  # postgres
  if [[ "$(ruby_requires_postgres)" = "true" ]]; then
    ruby_install_postgres_dev_libs
  fi
  # redis
  if [[ "$(ruby_requires_redis)" = "true" ]]; then
    ruby_install_redis_dev_libs
  fi
  return 0
}