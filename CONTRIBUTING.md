# Contributing to this project

We are open for all types of contributions from anyone. Tell us about our [issues/ideas](https://github.com/openSUSE/osem/issues/new), propose code changes via [pull requests](https://help.github.com/articles/using-pull-requests) or contribute artwork and documentation.

We welcome all new developers and are also prepared to mentor you through your first contributions! All maintainers are seasoned developers and have participated in mentoring programs, such as [GSoC](https://summerofcode.withgoogle.com/) and [RGSoC](https://railsgirlssummerofcode.org/).

We *need* your input and contributions, in particular we seek the following types:

* **code**: contribute your expertise in an area by helping us expand this application with features/bugfixes/UX
* **code editing**: fix typos, clarify language, and generally improve the quality of our content
* **ideas**: participate in an issues thread or start your own to have your voice heard
* **translations**: translate this application into other languages than English

Read this guide on how to do that.

## How to contribute code

1. Fork the repository and make a pull-request with your changes
    1. Make sure that the test suite passes and that you comply to our code style
    1. Please increase code coverage with your pull request
1. One of the maintainers will review your pull-request
    1. If you are already a contributor and you get a positive review, you can merge your pull-request yourself
    1. If you are not already a contributor, one of the existing contributors will merge your pull-request

**However, please bear in mind the following things:**

### Discuss Large Changes in Advance

If you see a glaring flaw within this application, resist the urge to jump into the
code and make sweeping changes right away. We know it can be tempting, but
especially for large, structural changes it's a wiser choice to first discuss
them in the [issue list](https://github.com/openSUSE/software-o-o/issues).

A good rule of thumb, of what a *structural change* is, is to estimate how much
time would be wasted if the pull request was rejected. If it's a couple of minutes
then you can probably dive head first and eat the loss in the worst case. Otherwise,
making a quick check with the other developers could save you lots of time down the line.

Why? It may turn out that someone is already working on this or that someone already
has tried to solve this and hit a roadblock, maybe there even is a good reason
why this particular flaw exists? If nothing else, a discussion of the change will
usually familiarize the reviewer with your proposed changes and streamline the
review process when you finally create a pull request.

### Small Commits & Pull Request Scope

A commit should contain a single logical change, the scope should be as small
as possible. And a pull request should only consist of the commits that you
need for your change. If it's possible for you to split larger changes into
smaller blocks please do so.

Why? Limiting the scope of commits/pull requests makes reviewing much easier.
Because it will usually mean each commit can be evaluated independently and a
smaller amount of commits per pull request usually also means a smaller amount
of code to be reviewed.

### Proper Commit Messages

We are keen on proper commit messages because they will help us to maintain
this code in the future. We define proper commit messages like this:

* The title of your commit message summarizes **what** has been done
* The body of your commit message explains **why** you have done this

If the title is to small to explain **what** you have done, then you can of course
elaborate about it in the body. Please avoid explaining *how* you have done this,
we are developers too and we see the diff, if we do not understand something we will
ask you in the review.

Additional to **what** and **why** you should explain potential **side-effects** of
this change, if you are aware of any.

## Development Environment

To isolate your host system from OSEM development we have prepared a container
based development environment, based on [docker](https://www.docker.com/) and
[docker-compose](https://docs.docker.com/compose/). Here's a step by step guide
how to set it up.

**WARNING**: Since we mount the repository into our container, your user id and
the id of the user inside the container need to be the same. If your user
id (`id -u`) is something else than `1000` you need to configure your user id
in the variable *CONTAINER_USERID*.

1. Configure the development environment (only once).
   ```bash
   cp docker-compose.override.yml.example docker-compose.override.yml
   edit docker-compose.override.yml
   ```
1. Build the development environment (only once)
   ```bash
   docker-compose build --no-cache --pull
   ```
1. Start the development environment:
   ```bash
   docker-compose up --build
   ```

1. Check out the application. You can access is at http://localhost:3000. Whatever you change will have effect in the container environment. 

1. Changed something? Run the tests to verify your changes!
   ```bash
   docker-compose run --rm software bundle exec rake test:all
   ```

1. Issue any standard `rails`/`rake`/`bundler` command
   ```bash
   docker-compose run --rm software bundle exec rake rubocop:auto_correct
   ```

1. Or explore the development environment:
   ```bash
   docker-compose exec software /bin/bash -l
   ```

## How to contribute translations

Please refer to our [translation guide](https://github.com/openSUSE/software-o-o/blob/master/README.i18n).


## How to deploy contributions

Please note that deployments are currently *not fully automated*. So please note that commits and accepted pull-requests might not be visible on 
the production website software.opensuse.org for weeks or in exceptional cases for months until the deployment was triggered manually.

We are deploying using an [rpm package](https://build.opensuse.org/package/show/openSUSE:infrastructure:software.opensuse.org/software_opensuse_org). The rpm package bundles all the required gems.

There is a `software_opensuse_org.service` you can control via [systemd](https://www.freedesktop.org/wiki/Software/systemd/).

The `systemd` service will read the variables described above from `/etc/software_opensuse_org.conf` in the form of an `EnvironmentFile`:

```
VAR1=value1
VAR2=value2
...
```

## How to update opensuse-theme-chameleon assets

```bash
git submodule init
git submodule update
make
```

