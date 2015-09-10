
create_unicorn_conf() {
  mkdir -p $(etc_dir)/unicorn
  mkdir -p $(deploy_dir)/var/log/unicorn
  mkdir -p $(deploy_dir)/var/run
  template \
    "unicorn/config.rb.mustache" \
    "$(etc_dir)/unicorn/config.rb" \
    "$(unicorn_conf_payload)"
}

unicorn_conf_payload() {
  cat <<-END
{
  "worker_processes": "$(unicorn_worker_processes)",
  "live_dir": "$(live_dir)",
  "timeout": "$(unicorn_timeout)",
  "deploy_dir": "$(deploy_dir)",
  "preload": $(unicorn_preload)
}
END
}

unicorn_worker_processes() {
  echo "$(validate "$(payload 'boxfile_unicorn_worker_processes')" "integer" "1")"
}

unicorn_timeout() {
  echo "$(validate "$(payload 'boxfile_unicorn_worker_processes')" "integer" "60")"
}

unicorn_preload() {
  echo "$(validate "$(payload 'boxfile_unicorn_preload')" "boolean" "false")"
}