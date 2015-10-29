# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

create_unicorn_conf() {
  print_bullet "Configuring Unicorn"
  mkdir -p $(etc_dir)/unicorn
  mkdir -p $(deploy_dir)/var/log/unicorn
  template \
    "unicorn/config.rb.mustache" \
    "$(etc_dir)/unicorn/config.rb" \
    "$(unicorn_conf_payload)"
}

unicorn_conf_payload() {
  _unicorn_worker_processes=$(unicorn_worker_processes)
  _unicorn_timeout=$(unicorn_timeout)
  _unicorn_preload=$(unicorn_preload)
  print_bullet_sub "Worker processes: ${_unicorn_worker_processes}"
  print_bullet_sub "Timeout: ${_unicorn_timeout}"
  print_bullet_sub "Preload: ${_unicorn_preload}"
  cat <<-END
{
  "worker_processes": "${_unicorn_worker_processes}",
  "live_dir": "$(live_dir)",
  "timeout": "${_unicorn_timeout}",
  "deploy_dir": "$(deploy_dir)",
  "preload": ${_unicorn_preload}
}
END
}

unicorn_worker_processes() {
  _unicorn_worker_processes=$(validate "$(payload 'boxfile_unicorn_worker_processes')" "integer" "1")
  echo "${_unicorn_worker_processes}"
}

unicorn_timeout() {
  _unicorn_timeout=$(validate "$(payload 'boxfile_unicorn_timeout')" "integer" "60")
  echo "${_unicorn_timeout}"
}

unicorn_preload() {
  _unicorn_preload=$(validate "$(payload 'boxfile_unicorn_preload')" "boolean" "false")
  echo "${_unicorn_preload}"
}