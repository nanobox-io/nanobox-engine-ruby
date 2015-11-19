# Ruby

## Advanced Configuration Options

This engine exposes configuration options through the [Boxfile](http://docs.nanobox.io/boxfile/), a yaml config file used to provision and configure your app's infrastructure when using Nanobox. 

#### Overview of Boxfile Configuration Options
```yaml
build:
  # Web Server Settings
  webserver: 'rackup'

  # Ruby Settings
  ruby_runtime: ruby-2.2

  # Node.js Runtime Settings
  nodejs-runtime: nodejs-4.2

  # Puma Settings
  puma_quiet: false
  puma_thread_min: 0
  puma_thread_max: 16
  puma_restart_command: ''
  puma_workers: 0
  puma_prune_bundler: false
  puma_preload_app: false
  puma_worker_timeout: 60
  puma_hooks: ''

  # Thin Settings
  thin_timeout: 30
  thin_wait: 30
  thin_max_conns: 1024
  thin_max_persistent_conns: 100
  thin_threaded: false
  thin_no_epoll: false
  thin_require: []

  # Unicorn Settings
  unicorn_worker_processes: 1
  unicorn_timeout: 60
  unicorn_preload: false
```

##### Quick Links
[Web Server Settings](#web-server-settings)  
[Ruby Settings](#ruby-settings)  
[Node.js Runtime Settings](#nodejs-runtime-settings)  
[Puma Settings](#puma-settings)  
[Thin Settings](#thin-settings)  
[Unicorn Settings](#unicorn-settings)  

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

### Node.js Runtime Settings
Many applications utilize Javascript tools in some way. This engine allows you to specify which Node.js runtime you'd like to use.

---

#### nodejs_runtime
Specifies which JS runtime and version to use. The following runtimes are available:

- nodejs-0.8
- nodejs-0.10
- nodejs-0.12
- nodejs-4.2
- iojs-2.3

```yaml
build:
  nodejs_runtime: nodejs-4.2
```

---

### Puma Settings
The following settings are used to configure Puma. These only apply when using `puma` as your `webserver`.

[puma_quiet](#puma_quiet)  
[puma_thread_min](#puma_thread_min)  
[puma_thread_max](#puma_thread_max)  
[puma_restart_command](#puma_restart_command)  
[puma_workers](#puma_workers)  
[puma_prune_bundler](#puma_prune_bundler)  
[puma_preload_app](#puma_preload_app)  
[puma_worker_timeout](#puma_worker_timeout)  
[puma_hooks](#puma_hooks)  

---

#### puma_quiet
Enables or disables request logging.
```yaml
build:
  puma_quiet: false
```

---

#### puma_thread_min
Sets the minimum number of threads to use to answer requests.
```yaml
build:
  puma_thread_min: 0
```

---

#### puma_thread_max
Sets the maximum number of threads to use to answer requests.
```yaml
build:
  puma_thread_max: 16
```

---

#### puma_restart_command
Command to use to restart puma. This should be just how to load puma itself (ie. 'ruby -Ilib bin/puma'), not the arguments to puma, as those are the same as the original process.
```yaml
build:
  puma_restart_command: ''
```

---

#### puma_workers
Defines how many worker processes should run.
```yaml
build:
  puma_workers: 0
```

---

#### puma_prune_bundler
Allows workers to reload the bundler context when the master process is issued a USR1 signal. This allows proper reloading of gems while the master is preserved across a phased-restart. **Note:** This is incompatible with [`puma_preload_app`](#puma_preload_app).
```yaml
build:
  puma_prune_bundler: false
```

---

#### puma_preload_app
Preload the application before starting the workers. **Note:** This conflicts with phased restart feature.
```yaml
build:
  puma_preload_app: false
```

---

#### puma_worker_timeout
Sets the timeout of workers.
```yaml
build:
  puma_worker_timeout: 60
```

---

#### puma_hooks
The path to a ruby file which contains the code that sets up the process when a worker boots before booting the app.
```yaml
build:
  puma_hooks: ''
```

---

### Thin Settings
The following settings are using to configure Thin. They only apply when using `thin` as your `webserver`.

[thin_timeout](#thin_timeout)  
[thin_wait](#thin_wait)  
[thin_max_conns](#thin_max_conns)  
[thin_max_persistent_conns](#thin_max_persistent_conns)  
[thin_threaded](#thin_threaded)  
[thin_no_epoll](#thin_no_epoll)  
[thin_require](#thin_require)  

---

#### thin_timeout
Sets the request or command timeout in seconds.
```yaml
build:
  thin_timeout: 30
```

---

#### thin_wait
Maximum wait time for the server to be started in seconds.
```yaml
build:
  thin_wait: 30
```

---

#### thin_max_conns
Defines the maximum number of open file descriptors.
```yaml
build:
  thin_max_conns: 1024
```

---

#### thin_max_persistent_conns
Defines the maximum number of persistent connections.
```yaml
build:
  thin_max_persistent_conns: 100
```

---

#### thin_threaded
Specifies whether or not to call the Rack application in threads.
```yaml
build:
  thin_threaded: false
```

---

#### thin_no_epoll
Disables the use of epoll.
```yaml
build:
  thin_no_epoll: false
```

---

#### thin_require
An an array of libraries to require.
```yaml
build:
  thin_require: []
```

---

### Unicorn Settings
The following settings are used to configure Unicorn. They only apply when using `unicorn` as your `webserver`.

[unicorn_worker_processes](#unicorn_worker_processes)  
[unicorn_timeout](#unicorn_timeout)  
[unicorn_preload](#unicorn_preload)  

---

#### unicorn_worker_processes
Defines the number of worker processes.
```yaml
build:
  unicorn_worker_processes: 1
```

---

#### unicorn_timeout
Specifies the time after which a worker will be "nuked".
```yaml
build:
  unicorn_timeout: 60
```

---

#### unicorn_preload
Enables or disables loading the application before forking workers.
```yaml
build:
  unicorn_preload: false
```

---

## Help & Support
This is a generic (non-framework-specific) Ruby engine provided by [Nanobox](http://nanobox.io). If you need help with this engine, you can reach out to us in the [#nanobox IRC channel](http://webchat.freenode.net/?channels=nanobox). If you are running into an issue with the engine, feel free to [create a new issue on this project](https://github.com/nanobox-io/nanobox-engine-ruby/issues/new).