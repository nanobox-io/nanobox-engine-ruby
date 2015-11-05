# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

ruby_create_thin_conf() {
  nos_print_bullet "Configuring Thin"
  mkdir -p $(nos_etc_dir)/thin
  mkdir -p $(nos_deploy_dir)/var/log/thin
  nos_template \
    "thin/config.yml.mustache" \
    "$(nos_etc_dir)/thin/config.yml" \
    "$(ruby_thin_conf_payload)"
}

ruby_thin_conf_payload() {
  _thin_timeout=$(ruby_thin_timeout)
  _thin_wait=$(ruby_thin_wait)
  _thin_max_conns=$(ruby_thin_max_conns)
  _thin_require=$(ruby_thin_require)
  _thin_max_persistent_conns=$(ruby_thin_max_persistent_conns)
  _thin_threaded=$(ruby_thin_threaded)
  _thin_no_epoll=$(ruby_thin_no_epoll)
  nos_print_bullet_sub "Timeout: ${_thin_timeout}"
  nos_print_bullet_sub "Wait: ${_thin_wait}"
  nos_print_bullet_sub "Max conns: ${_thin_max_conns}"
  nos_print_bullet_sub "Require: ${_thin_require}"
  nos_print_bullet_sub "Max persistent_conns: ${_thin_max_persistent_conns}"
  nos_print_bullet_sub "Threaded: ${_thin_threaded}"
  nos_print_bullet_sub "No epoll: ${_thin_no_epoll}"
  cat <<-END
{
  "deploy_dir": "$(nos_deploy_dir)",
  "timeout": "${_thin_timeout}",
  "wait": "${_thin_wait}",
  "max_conns": "${_thin_max_conns}",
  "require": "${_thin_require}",
  "environment": "$(ruby_environment)",
  "max_persistent_conns": "${_thin_max_persistent_conns}",
  "threaded": ${_thin_threaded},
  "no_epoll": ${_thin_no_epoll},
  "live_dir": "$(nos_live_dir)",
  "app_name": "$(ruby_app_name)"
}
END
}

ruby_thin_timeout() {
  echo "$(nos_validate "$(nos_payload 'boxfile_thin_timeout')" "integer" "30")"
}

ruby_thin_wait() {
  echo "$(nos_validate "$(nos_payload 'boxfile_thin_wait')" "integer" "30")"
}

ruby_thin_max_conns() {
  echo "$(nos_validate "$(nos_payload 'boxfile_thin_max_conns')" "integer" "1024")"
}

thin_require() {
  if [[ "$PL_boxfile_thin_require_type" = array ]]; then
    declare -a requires
    for ((i=0; i < PL_boxfile_thin_require_length ; i++)); do
      type=PL_boxfile_thin_require_${i}_type
      value=PL_boxfile_thin_require_${i}_value
      [[ "${type}" = 'string' ]] && requires+=(${!value})
    done
    echo "[$(join "," ${requires[@]})]"
  else
    echo "[]"
  fi
}

ruby_thin_max_persistent_conns() {
  echo "$(nos_validate "$(nos_payload 'boxfile_thin_max_persistent_conns')" "integer" "100")"
}

ruby_thin_threaded() {
  echo "$(nos_validate "$(nos_payload 'boxfile_thin_threaded')" "boolean" "false")"
}

ruby_thin_no_epoll() {
  echo "$(nos_validate "$(nos_payload 'boxfile_thin_no_epoll')" "boolean" "false")"
}