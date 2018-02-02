# software.opensuse.org

[![Build Status](https://travis-ci.org/openSUSE/software-o-o.svg?branch=master)](https://travis-ci.org/openSUSE/software-o-o)

Ruby on Rails application powering
[https://software.opensuse.org](https://software.opensuse.org)

## Installing dependencies in a (open)SUSE system

```console
zypper ref
zypper in ruby ruby-devel rubygem-bundler gcc make libxml2-devel libxslt-devel
```

## Running the application locally

Just for running it in development mode. If you are playing to deploy it in a
server, please apply good Ruby on Rails practices (like generating your own
keys for `secrets.yml`).

```bash
git clone https://github.com/openSUSE/software-o-o.git
cd software-o-o
git submodule init
git submodule update

bundle package
bundle exec rails s
```

Enjoy your software.opensuse.org clone at http://127.0.0.1:3000/

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

1. Install [Vagrant](https://www.vagrantup.com/downloads.html) and [docker](https://docs.docker.com/engine/getstarted/step_one/). Both tools support Linux, MacOS and Windows.

2. Clone this code repository:

    ```
    git clone --recurse-submodules git@github.com:openSUSE/software-o-o.git
    ```

3. Build your Vagrant box:

    ```
    vagrant up
    ```

4. Attach to your new development box

    ```
    docker attach software_web
    ```

5. Setup the database
    ```
    rake db:setup db:seed
    ```

6. Start the app
    ```
    rails server
    ```

8. Enjoy your software.opensuse.org clone at http://127.0.0.1:3000/

If you exit the shell inside the vagrant box your development environment
is stopped. Want to continue? Run `vagrant up` and `docker attach software_web`
again. Happy hacking!
