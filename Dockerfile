FROM registry.opensuse.org/opensuse/infrastructure/software.opensuse.org/containers/software/base:latest
ARG CONTAINER_USERID

# Configure our user
RUN usermod -u $CONTAINER_USERID software

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

