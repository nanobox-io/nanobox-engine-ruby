# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# runs through the list of known service types and if the app requires them,
# it will install the necessary 'dev' packages
install_dependencies() {
  # maria
  if [[ "$(requires_maria)" = "true" ]]; then
  	install_maria_dev_libs
  fi
  # memcache
  if [[ "$(requires_memcache)" = "true" ]]; then
  	install_memcache_dev_libs
  fi
  # mongo
  if [[ "$(requires_mongo)" = "true" ]]; then
  	install_mongo_dev_libs
  fi
  # mysql
  if [[ "$(requires_mongo)" = "true" ]]; then
  	install_mongo_dev_libs
  fi
  # percona
  if [[ "$(requires_percona)" = "true" ]]; then
  	install_percona_dev_libs
  fi
  # postgres
  if [[ "$(requires_postgres)" = "true" ]]; then
  	install_postgres_dev_libs
  fi
  # redis
  if [[ "$(requires_redis)" = "true" ]]; then
  	install_redis_dev_libs
  fi
  return 0
}