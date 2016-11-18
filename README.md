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
    # Ruby Settings
    ruby_runtime: ruby-2.2
    # Node.js Settings
    nodejs_runtime: nodejs-6.2
```

##### Quick Links
[Ruby Settings](#ruby-settings)  
[Node.js Settings](#nodejs-settings)   

---

### Ruby Settings
The following setting allows you to define your Ruby runtime environment.

---

#### runtime
Specifies which Ruby runtime and version to use. The following runtimes are available:

- ruby-1.9
- ruby-2.0
- ruby-2.1
- ruby-2.2
- ruby-2.3 *(default)*
- jruby-1.6
- jruby-1.7
- jruby-9.0

```yaml
run.config:
  engine.config:
    runtime: 'ruby-2.3'
```

---

### Node.js Settings
Many Ruby applications utilize Node.js tools for things such as dependency management or static asset compilation. This engine allows you to specify which Node.js runtime you'd like to include in your environment.

---

#### nodejs_runtime:
Specifies which Node.js runtime and version to use. The available options can be found in the [Node.js engine](https://github.com/nanobox-io/nanobox-engine-nodejs#runtime).

```yaml
run.config:
  engine.config:
    nodejs_runtime: nodejs-6.2
```

---

## Ruby on Nanobox
For more information about using Ruby on Nanobox, view the [Ruby guides](http://guides.nanobox.io/ruby/).

## Help & Support
This is an engine provided by [Nanobox](http://nanobox.io). If you need help with this engine, you can reach out to us in the [#nanobox IRC channel](http://webchat.freenode.net/?channels=nanobox). If you are running into an issue with the engine, feel free to [create a new issue on this project](https://github.com/nanobox-io/nanobox-engine-ruby/issues/new).
