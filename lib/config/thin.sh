# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

create_thin_conf() {
  mkdir -p $(etc_dir)/thin
  mkdir -p $(deploy_dir)/var/log/thin
  mkdir -p $(deploy_dir)/var/run
  template \
    "thin/config.yml.mustache" \
    "$(etc_dir)/thin/config.yml" \
    "$(thin_conf_payload)"
}

thin_conf_payload() {
  cat <<-END
{
  "deploy_dir": "$(deploy_dir)",
  "timeout": "$(thin_timeout)",
  "wait": "$(thin_wait)",
  "max_conns": "$(thin_max_conns)",
  "require": "$(thin_require)",
  "environment": "$(environment)",
  "max_persistent_conns": "$(thin_max_persistent_conns)",
  "threaded": $(thin_threaded),
  "no_epoll": $(thin_no_epoll),
  "live_dir": "$(live_dir)",
  "app_name": "$(app_name)"
}
END
}

thin_timeout() {
  echo "$(validate "$(payload 'boxfile_thin_timeout')" "integer" "30")"
}

thin_wait() {
  echo "$(validate "$(payload 'boxfile_thin_wait')" "integer" "30")"
}

thin_max_conns() {
  echo "$(validate "$(payload 'boxfile_thin_max_conns')" "integer" "1024")"
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

thin_max_persistent_conns() {
  echo "$(validate "$(payload 'boxfile_thin_max_persistent_conns')" "integer" "100")"
}


thin_threaded() {
  echo "$(validate "$(payload 'boxfile_thin_threaded')" "boolean" "false")"
}

thin_no_epoll() {
  echo "$(validate "$(payload 'boxfile_thin_no_epoll')" "boolean" "false")"
}