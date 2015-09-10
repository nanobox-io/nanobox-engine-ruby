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