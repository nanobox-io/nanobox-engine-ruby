# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

ruby_create_unicorn_conf() {
  nos_print_bullet "Configuring Unicorn"
  mkdir -p $(nos_etc_dir)/unicorn
  mkdir -p $(nos_deploy_dir)/var/log/unicorn
  nos_template \
    "unicorn/config.rb.mustache" \
    "$(nos_etc_dir)/unicorn/config.rb" \
    "$(ruby_unicorn_conf_payload)"
}

ruby_unicorn_conf_payload() {
  _unicorn_worker_processes=$(ruby_unicorn_worker_processes)
  _unicorn_timeout=$(ruby_unicorn_timeout)
  _unicorn_preload=$(ruby_unicorn_preload)
  nos_print_bullet_sub "Worker processes: ${_unicorn_worker_processes}"
  nos_print_bullet_sub "Timeout: ${_unicorn_timeout}"
  nos_print_bullet_sub "Preload: ${_unicorn_preload}"
  cat <<-END
{
  "worker_processes": "${_unicorn_worker_processes}",
  "live_dir": "$(nos_live_dir)",
  "timeout": "${_unicorn_timeout}",
  "deploy_dir": "$(nos_deploy_dir)",
  "preload": ${_unicorn_preload}
}
END
}

ruby_unicorn_worker_processes() {
  _unicorn_worker_processes=$(nos_validate "$(nos_payload 'boxfile_unicorn_worker_processes')" "integer" "1")
  echo "${_unicorn_worker_processes}"
}

ruby_unicorn_timeout() {
  _unicorn_timeout=$(nos_validate "$(nos_payload 'boxfile_unicorn_timeout')" "integer" "60")
  echo "${_unicorn_timeout}"
}

ruby_unicorn_preload() {
  _unicorn_preload=$(nos_validate "$(nos_payload 'boxfile_unicorn_preload')" "boolean" "false")
  echo "${_unicorn_preload}"
}