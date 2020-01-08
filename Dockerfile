FROM opensuse/leap:15.1
ARG IMAGE_USERID

# Update distro
RUN zypper --quiet --non-interactive update

# Install some system requirements
RUN zypper --quiet --non-interactive install timezone vim aaa_base glibc-locale sudo nodejs

# Install ruby
RUN zypper --quiet --non-interactive install ruby2.5 ruby2.5-devel

# Setup gem & sudo
RUN echo 'install: --no-format-executable' >> /etc/gemrc; \
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Install bundler
RUN gem install bundler:1.17.2

# Install requirements for our rubygems
RUN zypper --quiet --non-interactive install gcc make libxml2-devel libxslt-devel

# Add our user
RUN useradd -m vagrant  -u $IMAGE_USERID -p vagrant

USER vagrant
WORKDIR /vagrant

# Setup bundler
RUN bundle config build.nokogiri --use-system-libraries
