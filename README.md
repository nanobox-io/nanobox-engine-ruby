# Ruby

This is a Ruby engine used to launch Ruby apps on [Nanobox](http://nanobox.io). It installs all binaries to run a Ruby app.

# Usage
To use the Ruby engine, specify `ruby` as your engine in your [boxfile.yml](http://docs.nanobox.io/app-config/boxfile/).

```yaml
run.config:
  engine: ruby
```

## Build Process
When then engine builds and prepares the code, it runs the following:

- `bundle install`
- `bundle clean`

## Configuration Options
This engine exposes configuration options through the [boxfile.yml](http://docs.nanobox.io/app-config/boxfile/), a yaml config file used to provision and configure your app's infrastructure when using Nanobox.

#### Overview of Basic Boxfile Configuration Options
```yaml
run.config:
  engine: ruby
  engine.config:
    runtime: ruby-2.2
    postgresql_client_version: "9.6"
```

---

#### runtime
Specifies which Ruby runtime and version to use. The following runtimes are available:

- ruby-1.9
- ruby-2.0
- ruby-2.1
- ruby-2.2
- ruby-2.3 *(default)*
- ruby-2.4
- jruby-1.6
- jruby-1.7
- jruby-9.0

```yaml
run.config:
  engine.config:
    runtime: 'ruby-2.3'
```

---

#### postgresql_client_version
If you're the 'pg' gem is detected, specify which version of the postgres client to use.

NOTE: The engine will try to detect the correct version first.

- 9.3
- 9.4
- 9.5
- 9.6
- 10

```yaml
run.config:
  engine.config:
    postgresql_client_version: "9.6"
```

---

## Ruby on Nanobox
For more information about using Ruby on Nanobox, view the [Ruby guides](http://guides.nanobox.io/ruby/).

## Help & Support
This is an engine provided by [Nanobox](http://nanobox.io). If you are running into an issue with the engine, feel free to [create a new issue on this project](https://github.com/nanobox-io/nanobox-engine-ruby/issues/new).
