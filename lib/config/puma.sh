# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

create_puma_conf() {
  print_bullet "Configuring Puma"
  mkdir -p $(etc_dir)/puma
  mkdir -p $(deploy_dir)/var/log/puma
  template \
    "puma/config.rb.mustache" \
    "$(etc_dir)/puma/config.rb" \
    "$(puma_conf_payload)"
}

puma_conf_payload() {
  _puma_quiet=$(puma_quiet)
  _puma_thread_min=$(puma_thread_min)
  _puma_thread_max=$(puma_thread_max)
  _puma_restart_command=$(puma_restart_command)
  _puma_has_restart_command=$(puma_has_restart_command)
  _puma_has_workers=$(puma_has_workers)
  _puma_workers=$(puma_workers)
  _puma_prune_bundler=$(puma_prune_bundler)
  _puma_preload_app=$(puma_preload_app)
  _puma_worker_timeout=$(puma_worker_timeout)
  _puma_has_hooks=$(puma_has_hooks)
  _puma_hooks=$(puma_hooks)
  print_bullet_sub "quiet: ${_puma_quiet}"
  print_bullet_sub "thread min: ${_puma_thread_min}"
  print_bullet_sub "thread max: ${_puma_thread_max}"
  [[ "${_puma_has_restart_command}" = "true" ]] && print_bullet_sub "restart command: ${_puma_restart_command}"
  [[ "${_puma_has_workers}" = "true" ]] && print_bullet_sub "workers: ${_puma_workers}"
  print_bullet_sub "prune bundler: ${_puma_prune_bundler}"
  print_bullet_sub "preload app: ${_puma_preload_app}"
  print_bullet_sub "worker timeout: ${_puma_worker_timeout}"
  [[ "${_puma_has_hooks}" = "true" ]] && print_bullet_sub "hooks: ${_puma_hooks}"
  cat <<-END
{
  "live_dir": "$(live_dir)",
  "environment": "$(environment)",
  "deploy_dir": "$(deploy_dir)",
  "quiet": ${_puma_quiet},
  "thread_min": "${_puma_thread_min}",
  "thread_max": "${_puma_thread_max}",
  "restart_command": "${_puma_restart_command}",
  "has_restart_command": ${_puma_has_restart_command},
  "has_workers": ${_puma_has_workers},
  "workers": "${_puma_workers}",
  "prune_bundler": ${_puma_prune_bundler},
  "preload_app": ${_puma_preload_app},
  "app_name": "$(app_name)",
  "worker_timeout": ${_puma_worker_timeout},
  "has_hooks": ${_puma_has_hooks},
  "puma_hooks": "${_puma_hooks}"
}
END
}

puma_quiet() {
  echo "$(validate "$(payload 'boxfile_puma_quiet')" "boolean" "false")"
}

puma_thread_min() {
  echo "$(validate "$(payload 'boxfile_puma_thread_min')" "integer" "0")"
}

puma_thread_max() {
  echo "$(validate "$(payload 'boxfile_puma_thread_max')" "integer" "16")"
}

puma_restart_command() {
  echo "$(validate "$(payload 'boxfile_puma_restart_command')" "string" "")"
}

puma_has_restart_command() {
  [[ -n "$(validate "$(payload 'boxfile_puma_restart_command')" "string" "")" ]] && echo "true" && return
  echo "false"
}

puma_has_workers() {
  [[ -n "$(validate "$(payload 'boxfile_puma_workers')" "integer" "1")" ]] && echo "true" && return
  echo "false"
}

puma_workers() {
  echo "$(validate "$(payload 'boxfile_puma_workers')" "integer" "1")"
}

puma_prune_bundler() {
  echo "$(validate "$(payload 'boxfile_puma_prune_bundler')" "boolean" "false")"
}

puma_preload_app() {
  echo "$(validate "$(payload 'boxfile_puma_preload_app')" "boolean" "false")"
}

puma_worker_timeout() {
  echo "$(validate "$(payload 'boxfile_puma_worker_timeout')" "integer" "60")"
}

puma_has_hooks() {
  [[ -n "$(validate "$(payload 'boxfile_puma_hooks')" "file" "")" ]] && echo "true" && return
  echo "false"
}

puma_hooks() {
  echo "$(validate "$(payload 'boxfile_puma_hooks')" "file" "")"
}
