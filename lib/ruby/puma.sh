# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

ruby_create_puma_conf() {
  nos_print_bullet "Configuring Puma"
  mkdir -p $(nos_etc_dir)/puma
  mkdir -p $(nos_deploy_dir)/var/log/puma
  nos_template \
    "puma/config.rb.mustache" \
    "$(nos_etc_dir)/puma/config.rb" \
    "$(ruby_puma_conf_payload)"
}

ruby_puma_conf_payload() {
  _puma_quiet=$(ruby_puma_quiet)
  _puma_thread_min=$(ruby_puma_thread_min)
  _puma_thread_max=$(ruby_puma_thread_max)
  _puma_restart_command=$(ruby_puma_restart_command)
  _puma_has_restart_command=$(ruby_puma_has_restart_command)
  _puma_has_workers=$(ruby_puma_has_workers)
  _puma_workers=$(ruby_puma_workers)
  _puma_prune_bundler=$(ruby_puma_prune_bundler)
  _puma_preload_app=$(ruby_puma_preload_app)
  _puma_worker_timeout=$(ruby_puma_worker_timeout)
  _puma_has_hooks=$(ruby_puma_has_hooks)
  _puma_hooks=$(ruby_puma_hooks)
  nos_print_bullet_sub "quiet: ${_puma_quiet}"
  nos_print_bullet_sub "thread min: ${_puma_thread_min}"
  nos_print_bullet_sub "thread max: ${_puma_thread_max}"
  [[ "${_puma_has_restart_command}" = "true" ]] && nos_print_bullet_sub "restart command: ${_puma_restart_command}"
  [[ "${_puma_has_workers}" = "true" ]] && nos_print_bullet_sub "workers: ${_puma_workers}"
  nos_print_bullet_sub "prune bundler: ${_puma_prune_bundler}"
  nos_print_bullet_sub "preload app: ${_puma_preload_app}"
  nos_print_bullet_sub "worker timeout: ${_puma_worker_timeout}"
  [[ "${_puma_has_hooks}" = "true" ]] && nos_print_bullet_sub "hooks: ${_puma_hooks}"
  cat <<-END
{
  "live_dir": "$(nos_live_dir)",
  "environment": "$(ruby_environment)",
  "deploy_dir": "$(nos_deploy_dir)",
  "quiet": ${_puma_quiet},
  "thread_min": "${_puma_thread_min}",
  "thread_max": "${_puma_thread_max}",
  "restart_command": "${_puma_restart_command}",
  "has_restart_command": ${_puma_has_restart_command},
  "has_workers": ${_puma_has_workers},
  "workers": "${_puma_workers}",
  "prune_bundler": ${_puma_prune_bundler},
  "preload_app": ${_puma_preload_app},
  "app_name": "$(ruby_app_name)",
  "worker_timeout": ${_puma_worker_timeout},
  "has_hooks": ${_puma_has_hooks},
  "puma_hooks": "${_puma_hooks}"
}
END
}

ruby_puma_quiet() {
  echo "$(nos_validate "$(nos_payload 'boxfile_puma_quiet')" "boolean" "false")"
}

ruby_puma_thread_min() {
  echo "$(nos_validate "$(nos_payload 'boxfile_puma_thread_min')" "integer" "0")"
}

ruby_puma_thread_max() {
  echo "$(nos_validate "$(nos_payload 'boxfile_puma_thread_max')" "integer" "16")"
}

ruby_puma_restart_command() {
  echo "$(nos_validate "$(nos_payload 'boxfile_puma_restart_command')" "string" "")"
}

ruby_puma_has_restart_command() {
  [[ -n "$(nos_validate "$(nos_payload 'boxfile_puma_restart_command')" "string" "")" ]] && echo "true" && return
  echo "false"
}

ruby_puma_has_workers() {
  [[ -n "$(nos_validate "$(nos_payload 'boxfile_puma_workers')" "integer" "1")" ]] && echo "true" && return
  echo "false"
}

ruby_puma_workers() {
  echo "$(nos_validate "$(nos_payload 'boxfile_puma_workers')" "integer" "1")"
}

ruby_puma_prune_bundler() {
  echo "$(nos_validate "$(nos_payload 'boxfile_puma_prune_bundler')" "boolean" "false")"
}

ruby_puma_preload_app() {
  echo "$(nos_validate "$(nos_payload 'boxfile_puma_preload_app')" "boolean" "false")"
}

ruby_puma_worker_timeout() {
  echo "$(nos_validate "$(nos_payload 'boxfile_puma_worker_timeout')" "integer" "60")"
}

ruby_puma_has_hooks() {
  [[ -n "$(nos_validate "$(nos_payload 'boxfile_puma_hooks')" "file" "")" ]] && echo "true" && return
  echo "false"
}

ruby_puma_hooks() {
  echo "$(nos_validate "$(nos_payload 'boxfile_puma_hooks')" "file" "")"
}
