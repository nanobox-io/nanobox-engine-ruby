# Ruby

This is a generic Ruby engine used to launch [Nanobox](http://nanobox.io). This will identify a ruby project by the presence of a Gemfile in the root of the project. This will create a web if it finds a config.ru file. By default it will use [rackup](http://rack.github.io/) to start the a web server. It can also be configured to use [thin](http://code.macournoyer.com/thin/), [puma](http://puma.io/), or [unicorn](http://unicorn.bogomips.org/).

## Basic Configuration Options

This engine exposes configuration option through the [Boxfile](http://docs.nanobox.io/boxfile/), a yaml config file used to provision and configure your app's infrastructure when using Nanobox. 

#### Overview of Basic Boxfile Configuration Options
```yaml
build:
  # Web Server Settings
  webserver: 'unicorn'

  # Ruby Settings
  ruby_version: 2.2

  # Unicorn Settings
  unicorn_preload: true
```

runtime: ruby-2.2
js-runtime: ""
webserver: rackup

puma_quiet: false
puma_thread_min: 0
puma_thread_max: 16
puma_restart_command: ""
puma_workers: 0
puma_prune_bundler: false
puma_preload_app: false
puma_worker_timeout: 60
puma_hooks: ""

thin_timeout: 30
thin_wait: 30
thin_max_conns: 1024
thin_max_persistent_conns: 100
thin_threaded: false
thin_no_epoll: false
thin_require: []

unicorn_worker_processes: 1
unicorn_timeout: 60
unicorn_preload: false
