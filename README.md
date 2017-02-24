# software.opensuse.org

Ruby on Rails application powering
[https://software.opensuse.org](https://software.opensuse.org)

## Installing dependencies in a (open)SUSE system

Add the
[openSUSE:infrastructure:software.opensuse.org](https://build.opensuse.org/project/show/openSUSE:infrastructure:software.opensuse.org)
repository to your system
```
zypper ref
zypper in software_opensuse_org-deps
```

In other systems, use the regular Ruby on Rails mechanisms to install
dependencies (i.e. Bundler)

## Running the application locally
Just for running it in development mode. If you are playing to deploy it in a
server, please apply good Ruby on Rails practices (like generating your own
keys for `secrets.yml`).

```bash
git clone https://github.com/openSUSE/software-o-o.git
cd software-o-o
git submodule init
git submodule update

cp config/database.yml.example config/database.yml
cp config/options.yml.example config/options.yml
cp config/secrets.yml.example config/secrets.yml
rake db:migrate

rails server
```

Enjoy your software.opensuse.org clone at http://127.0.0.1:3000/

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

5. Configure the app
    ```
    cp config/database.yml.example config/database.yml
    cp config/options.yml.example config/options.yml
    cp config/secrets.yml.example config/secrets.yml
    ```

6. Setup the database
    ```
    rake db:setup db:seed
    ```

7. Start the app
    ```
    rails server
    ```

8. Enjoy your software.opensuse.org clone at http://127.0.0.1:3000/

If you exit the shell inside the vagrant box your development environment
is stopped. Want to continue? Run `vagrant up` and `docker attach software_web`
again. Happy hacking!
