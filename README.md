# software.opensuse.org

[![Build Status](https://travis-ci.com/openSUSE/software-o-o.svg?branch=master)](https://travis-ci.com/openSUSE/software-o-o)[![Gitter chat](https://badges.gitter.im/openSUSE/software-o-o.png)](https://gitter.im/openSUSE/software-o-o)

Ruby on Rails application powering
[https://software.opensuse.org](https://software.opensuse.org)

We hope you'll get involved! Read our [Contributors' Guide](https://github.com/openSUSE/software-o-o/blob/master/CONTRIBUTING.md) for details.

## Installing dependencies in a (open)SUSE system

We recommend the usage of Ruby 2.4 or higher for the development.

If you are an openSUSE Tumbleweed user, it comes with the latest Ruby releases as default so you can configure your environment doing:

```console
zypper ref
zypper in ruby ruby-devel 'rubygem(bundler)' nodejs gcc make libxml2-devel libxslt-devel
```

On openSUSE Leap 42.3 you will need to install the Ruby 2.4 environment doing:

```console
zypper ref
zypper in ruby2.4 ruby2.4-devel ruby2.4-rubygem-bundler nodejs6 gcc make libxml2-devel libxslt-devel
```

You can find more information about Ruby development and packaging on openSUSE distributions [here](https://en.opensuse.org/Ruby).

## Running the application locally

Just for running it in development mode. If you are playing to deploy it in a
server, please apply good Ruby on Rails practices (like generating your own
keys for `secrets.yml`).

```bash
git clone https://github.com/openSUSE/software-o-o.git
cd software-o-o

bundle package
bundle exec rails s
```

Enjoy your software.opensuse.org clone at http://127.0.0.1:3000/

You can also run the _unit tests_ locally using the command:

```bash
bundle exec rails test
```
and also the _System Tests_ that will simulate user interaction using a headless browser:

```bash
bundle exec rails test:system
```
**IMPORTANT**: For the _System Tests_, the project is configured to use _Firefox Headless Mode_ feature, available on:

- **Linux:** Firefox 55 or higher;
- **Windows/Mac:** Firefox 56 or higher.

See more [here.](https://developer.mozilla.org/en-US/Firefox/Headless_mode)

### Instrumentation on development
By default in non-production environments, the prometheus instrumentation is disabled. You can enable it by passing `INSTRUMENTATION=true` environment variable when starting the application:

```
INSTRUMENTATION=true bundle exec rails s
```

When doing this, you need to start the prometheus_exporter process separately (otherwise you will observe a lot of warnings in the log as the instrumentation code will try to connect to the collector process). You can do so with this command:

```
bundle exec prometheus_exporter
```

After this the prometheus metrics will be exported under `http://localhost:9394/metrics`.

### Updating opensuse-theme-chameleon assets

```bash
git submodule init
git submodule update
make
```

After running the above commands, run `RAILS_ENV=production rails assets:precompile` and you should see the new assets.

## Running the application in production

The application will take the following environment variables:

* `SECRET_KEY_BASE`: See [Encrypted Session Storage](http://edgeguides.rubyonrails.org/security.html#encrypted-session-storage) in Rails documentation.
* `API_USERNAME` and `API_PASSWORD`: Credentials to the Open Build Service API end-point
  * These can be replaced with `OPENSUSE_COOKIE` if you have admin access to the Open Build Service instance.
* `RAILS_ENV`

Puma will honor other variables too:

* `WEB_CONCURRENCY`
* `RAILS_MAX_THREADS`
* `PORT`
* `RACK_ENV`
* `SOFTWARE_O_O_RBTRACE`

In production, prometheus instrumentation is enabled and `prometheus_exporter` process must be started.

### Debugging

* If `SOFTWARE_O_O_RBTRACE` is set, you can use [rbtrace](https://github.com/tmm1/rbtrace) to debug the application.

### Memcache

`memcache` should be running. It seems to be hardcoded in `environments/production.rb` to `localhost:11211`.
This probably needs to be fixed, as the `dalli` gem, automatically uses `MEMCACHE_SERVERS` env variable or
`127.0.0.1:11211` as default.

### PaaS

If you plan to run the application on PaaS, make sure you set all the above variables correctly.

* There is an included `manifest.yml` tested with [SUSE Cloud Application Platform](https://www.suse.com/de-de/products/cloud-application-platform/), and it should not be hard to get it running on other [Cloud Foundry](https://www.cloudfoundry.org/) distributions or hosted PaaS like [Heroku](http://heroku.com/).

## Official instance

The official instance is deployed using an [rpm package](https://build.opensuse.org/package/show/openSUSE:infrastructure:software.opensuse.org/software_opensuse_org). The rpm package bundles all the required gems.

There is a `software_opensuse_org.service` you can control via [systemd](https://www.freedesktop.org/wiki/Software/systemd/).

The `systemd` service will read the variables described above from `/etc/software_opensuse_org.conf` in the form of an `EnvironmentFile`:

```
VAR1=value1
VAR2=value2
...
```

## Development environment using Vagrant

There is also a [Vagrant](https://www.vagrantup.com/) setup to create our development
environment. All the tools needed for this are available for Linux, MacOS and
Windows.

1.  Install [Vagrant](https://www.vagrantup.com/downloads.html) and [docker](https://docs.docker.com/engine/getstarted/step_one/). Both tools support Linux, MacOS and Windows.

1.  Clone this code repository:

    ```
    git clone --recurse-submodules git@github.com:openSUSE/software-o-o.git
    ```

1.  Build your Vagrant box:

    ```
    vagrant up
    ```

1.  Attach to your new development box:

    ```
    docker attach software_web
    ```

1. Install gems:

    ```
    bundle install
    ```

1.  Start the app:

    ```
    rails server
    ```

1.  Enjoy your software.opensuse.org clone at http://127.0.0.1:3000/

If you exit the shell inside the vagrant box your development environment
is stopped. Want to continue? Run `vagrant up` and `docker attach software_web`
again. Happy hacking!

## Configuring openSUSE releases

The file `config/releases.yml` is used by the `/distributions` end-point to render the right template (`leap-$version`).

The variables `@testing_version`, `@stable_version` and `@legacy_version` will be set accordingly.
`@version` will be set to the right version of the page you are displaying.

```yaml
---
- from: '2018-05-25 10:00:00'
  stable_version: '15'
  legacy_version: '42.3'
- from: '2018-01-31 00:00:00'
  stable_version: '42.3'
  testing_version: '15'
  testing_state: 'Beta'
  legacy_version: '42.2'
- from: '2017-07-26 00:00:00'
  stable_version: '42.3'
  legacy_version: '42.2'
- from: '2017-07-08 00:00:00'
  stable_version: '42.2'
  testing_version: '42.3'
  testing_state: 'RC'
  legacy_version: '42.1'
- from: '2016-11-16 00:00:00'
  stable_version: '42.2'
  legacy_version: '42.1'
```

