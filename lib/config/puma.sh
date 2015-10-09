# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

create_puma_conf() {
  mkdir -p $(etc_dir)/puma
  mkdir -p $(deploy_dir)/var/log/puma
  template \
    "puma/config.rb.mustache" \
    "$(etc_dir)/puma/config.rb" \
    "$(puma_conf_payload)"
}

puma_conf_payload() {
  cat <<-END
{
  "live_dir": "$(live_dir)",
  "environment": "$(environment)",
  "deploy_dir": "$(deploy_dir)",
  "quiet": $(puma_quiet),
  "thread_min": "$(puma_thread_min)",
  "thread_max": "$(puma_thread_max)",
  "restart_command": "$(puma_restart_command)",
  "has_restart_command": $(puma_has_restart_command),
  "has_workers": $(puma_has_workers),
  "workers": "$(puma_workers)",
  "prune_bundler": $(puma_prune_bundler),
  "preload_app": $(puma_preload_app),
  "app_name": "$(app_name)",
  "worker_timeout": $(puma_worker_timeout),
  "has_hooks": $(puma_has_hooks),
  "puma_hooks": "$(puma_hooks)"
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
