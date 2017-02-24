FROM opensuse:42.1
ARG IMAGE_USERID

# Update distro
RUN zypper -q --non-interactive update 

# Install some system requirements
RUN zypper -q --non-interactive install timezone vim aaa_base glibc-locale sudo nodejs

# Install ruby
RUN zypper -q --non-interactive install ruby2.1 ruby2.1-devel ruby2.1-rubygem-mysql2

# Setup gem & sudo
RUN echo 'install: --no-format-executable' >> /etc/gemrc; \
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Install bundler
RUN gem install bundler

# Install requirements for our rubygems 
RUN zypper -q --non-interactive install sqlite3-devel gcc make libxml2-devel libxslt-devel

# Add our user
RUN useradd -m vagrant  -u $IMAGE_USERID -p vagrant

USER vagrant
WORKDIR /vagrant
# Setup bundler
RUN bundle config build.nokogiri --use-system-libraries

CMD ["bundle", "exec", "rails", "server"] 
