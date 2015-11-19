# Ruby

This is a generic Ruby engine used to launch [Nanobox](http://nanobox.io) that identifies a ruby project by the presence of a Gemfile in the root of the project. The engine will create a web if it finds a config.ru file. By default it will use [rackup](http://rack.github.io/) to start the a web server. [Thin](http://code.macournoyer.com/thin/), [puma](http://puma.io/), and [unicorn](http://unicorn.bogomips.org/) are also available.

## App Detection
To detect a Ruby app, this engine checks for the presence of a Gemfile.

## Build Process
- `bundle install`
- `bundle clean`

## Important Things to Know
- The engine will only create a default web service if there is a `config.ru` or an `app.rb` in the root of the application.
- If a `config.ru` file exists, the engine will launch the app as a rack app (`webserver: rackup`), unless a different [webserver](#webserver) is specified.

## Basic Configuration Options

This engine exposes configuration options through the [Boxfile](http://docs.nanobox.io/boxfile/), a yaml config file used to provision and configure your app's infrastructure when using Nanobox. 

##### *Advanced Configuration Options*
This Readme outlines only the most basic and commonly used settings. For the full list of available configuration options, view the **[Advanced Ruby Configuration options](https://github.com/nanobox-io/nanobox-engine-ruby/blob/master/doc/advanced-ruby-config.md)**.

#### Overview of Basic Boxfile Configuration Options
```yaml
build:
  # Web Server Settings
  webserver: 'unicorn'

  # Ruby Settings
  ruby_runtime: ruby-2.2
```

##### Quick Links
[Web Server Settings](#web-server-settings)  
[Ruby Settings](#ruby-settings)   

### Web Server Settings
The following setting is used to select which web server to use in your application.

---

#### webserver
The following web servers are available:

- rackup *(default)*
- puma
- thin
- unicorn

```yaml
build:
  webserver: 'rackup'
```

Web-server-specific config options are also available. They can be found in the following sections of the Advanced Configuration doc:

[Puma Settings](https://github.com/nanobox-io/nanobox-engine-ruby/blob/master/doc/advanced-ruby-config.md#puma-settings)  
[Thin Settings](https://github.com/nanobox-io/nanobox-engine-ruby/blob/master/doc/advanced-ruby-config.md#thin-settings)  
[Unicorn Settings](https://github.com/nanobox-io/nanobox-engine-ruby/blob/master/doc/advanced-ruby-config.md#unicorn-settings)

---

### Ruby Settings
The following setting allows you to define your Ruby runtime environment.

---

#### ruby_runtime
Specifies which Ruby runtime and version to use. The following runtimes are available:

- ruby-1.9
- ruby-2.0
- ruby-2.1
- ruby-2.2 *(default)*
- jruby-1.6
- jruby-1.7
- jruby-9.0

```yaml
build:
  ruby_runtime: 'ruby-2.2'
```

---

## Help & Support
This is a generic (non-framework-specific) Ruby engine provided by [Nanobox](http://nanobox.io). If you need help with this engine, you can reach out to us in the [#nanobox IRC channel](http://webchat.freenode.net/?channels=nanobox). If you are running into an issue with the engine, feel free to [create a new issue on this project](https://github.com/nanobox-io/nanobox-engine-ruby/issues/new).