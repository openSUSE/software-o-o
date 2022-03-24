FROM registry.opensuse.org/opensuse/leap:15.3
ARG CONTAINER_USERID

# Install our requirements
RUN zypper -n ar -f \
    https://download.opensuse.org/repositories/devel:/languages:/ruby/openSUSE_Leap_15.3/devel:languages:ruby.repo; \
    zypper -n --gpg-auto-import-keys refresh; \
    zypper -n install --no-recommends timezone glibc-locale sudo \
                                      vim git-core \
                                      gcc gcc-c++ make \
                                      MozillaFirefox \
                                      nodejs16 ruby3.1-devel \
                                      libxml2-devel libxslt-devel

# Setup ruby in PATH & sudo
RUN echo 'install: --no-format-executable' >> /etc/gemrc; \
    echo 'software ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers; \
    ln -s /usr/bin/gem.ruby3.1 /usr/local/bin/gem; \
    ln -s /usr/bin/ruby.ruby3.1 /usr/local/bin/ruby; \
    ln -s /usr/bin/bundle.ruby3.1 /usr/local/bin/bundle; \
    ln -s /usr/bin/bundler.ruby3.1 /usr/local/bin/bundler; \
    ln -s /usr/bin/irb.ruby3.1 /usr/local/bin/irb; \
    ln -s /usr/bin/rake.ruby3.1 /usr/local/bin/rake

# Add our user
RUN useradd -m software  -u $CONTAINER_USERID -p software

# We copy the Gemfiles into this intermediate build stage so it's checksum
# changes and all the subsequent stages (a.k.a. the bundle install call below)
# have to be rebuild. Otherwise, after the first build of this image,
# docker would use it's cache for this and the following stages.
ADD Gemfile /software/Gemfile
ADD Gemfile.lock /software/Gemfile.lock
RUN chown -R software /software

USER software
WORKDIR /software

# Setup bundler
# We always want to build for our platform instead of using precompiled gems
ENV BUNDLE_FORCE_RUBY_PLATFORM=true
RUN bundle config build.nokogiri --use-system-libraries

# Refresh our bundle
RUN bundle install --jobs=3 --retry=3

# Run our command
CMD ["rails", "server", "-b", "0.0.0.0"]

