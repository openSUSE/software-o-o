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

cp database.yml.example database.yml
cp options.yml.example options.yml
cp secrets.yml.example secrets.yml
rake db:migrate

rails server
```

Enjoy your software.opensuse.org clone at http://localhost:3000/
