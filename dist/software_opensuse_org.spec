# FIXME: should be /usr/share with writable directories in /var
%define basedir  /srv/www/vhosts/opensuse.org/software/current
%define run_as_user   soorun
%define run_as_group  soorun

%define ruby_version 3.4

#
Name:           software_opensuse_org
Version:        15.3.git20220301.e821b453
Release:        0
Summary:        Package for deploying software.opensuse.org
License:        GPL-2.0
Group:          Productivity/Networking/Web/Utilities
Url:            http://software.opensuse.org
Source:         software-o-o-%{version}.tar.xz
# memcache is required for session data
Requires:       memcached
Conflicts:      memcached < 1.4

Requires:       ruby%{ruby_version}
Requires:       ImageMagick
# rubygem uglifier needs some js runtime
Requires:       nodejs
BuildRequires:  xz
BuildRequires:  fdupes
BuildRequires:  systemd-rpm-macros
# needed by native extensions
BuildRequires:  ruby%{ruby_version}-devel
BuildRequires:  libxml2-devel
BuildRequires:  libxslt-devel
BuildRequires:  libsass-devel
BuildRequires:  libyaml-devel
BuildRequires:  libffi-devel
BuildRequires:  glibc-devel
BuildRequires:  gcc
BuildRequires:  gcc-c++
BuildRequires:  make
# needed by execjs
BuildRequires:  nodejs
# needed to build mo files
BuildRequires:  gettext-tools
# TZInfo::DataSourceNotFound & rake makemo
BuildRequires:  timezone
# for building zlib
BuildRequires:  valgrind-client-headers

#
PreReq:         /usr/sbin/groupadd /usr/sbin/useradd
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
# Prevent bundled gem libraries to be injected into the package provides
%define __provides_exclude_from ^/srv/www/vhosts/opensuse.org/software/current/vendor/.*$

%description
This package manages the update of the application and offers a systemd service running on port 3000.
See %{name}-apache2 package to expose it using apache2.

For more information about software.o.o, see https://github.com/openSUSE/software-o-o/ and http://software.opensuse.org

%package apache2
Summary:        Exposes software.opensuse.org via apache vhost
Requires:       apache2-prefork
Requires:       %{name}
Requires:       logrotate
BuildArch:      noarch
%description    apache2
Exposes software.opensuse.org service as an apache virtual host

%prep
%autosetup -n software-o-o-%{version} -p1

%build
make RUBY_VERSION=%{ruby_version}

%install
%make_install
%fdupes -s %{buildroot}
%find_lang software

%pre
/usr/sbin/groupadd -r %{run_as_group} &>/dev/null || :
/usr/sbin/useradd -g %{run_as_group} -s /bin/false -r -c "Software.openSUSE.org" -d %{basedir} %{run_as_user} &>/dev/null || :
%service_add_pre software_opensuse_org.service

%post
%service_add_post software_opensuse_org.service
if [ ! -e /etc/software_opensuse_org.conf ]; then
	echo "### remember to add SECRET_KEY_BASE, API_USERNAME and API_PASSWORD to /etc/software_opensuse_org.conf"
fi

%preun
%service_del_preun software_opensuse_org.service

%postun
if [ -d %{basedir}/tmp ]; then
  touch %{basedir}/tmp/restart.txt
fi
%restart_on_update memcached software_opensuse_org
%service_del_postun software_opensuse_org.service

%files -f software.lang
%defattr(-,root,root)
%dir /srv/www
%dir /srv/www/vhosts/
%dir /srv/www/vhosts/opensuse.org/
%dir /srv/www/vhosts/opensuse.org/software/
%dir /srv/www/vhosts/opensuse.org/software/current
%dir /srv/www/vhosts/opensuse.org/software/current/locale
%dir /srv/www/vhosts/opensuse.org/software/current/locale/*
%dir /srv/www/vhosts/opensuse.org/software/current/locale/*/*
%{_unitdir}/software_opensuse_org.service
%defattr(-,root,%{run_as_group})
%{basedir}/.bundle
%{basedir}/Gemfile
%{basedir}/Gemfile.lock
%{basedir}/Makefile
%{basedir}/README.i18n
%{basedir}/Rakefile
%{basedir}/config.ru
%{basedir}/app
%{basedir}/bin
%dir %{basedir}/config
%{basedir}/config/application.rb
%{basedir}/config//boot.rb
%{basedir}/config/environment.rb
%{basedir}/config/puma.rb
%{basedir}/config/routes.rb
%{basedir}/config/environments
%{basedir}/config/initializers
%{basedir}/config/locales
%{basedir}/lib
%dir %{basedir}/public
%{basedir}/public/404.html
%{basedir}/public/500.html
%{basedir}/public/favicon.ico
%{basedir}/public/robots.txt
%{basedir}/public/search_software.xml
%{basedir}/public/assets
%{basedir}/vendor
%defattr(-,%{run_as_user},%{run_as_group})
%dir %{basedir}/log/
%dir %{basedir}/tmp/
%dir %{basedir}/tmp/pids
%dir %{basedir}/public/images
%ghost %attr(0644,%{run_as_user},%{run_as_group}) %{basedir}/log/production.log
%config(noreplace) %{basedir}/config/default_searches.yml
%config(noreplace) %{basedir}/config/options.yml

%files apache2
%defattr(-,root,root)
%dir %{_sysconfdir}/apache2
%dir %{_sysconfdir}/apache2/vhosts.d
%config(noreplace) %{_sysconfdir}/apache2/vhosts.d/vhost-software_opensuse_org.conf
%dir %{_localstatedir}/log/apache2
%ghost %attr(0644,root,root) %{_localstatedir}/log/apache2/software.opensuse.org-access.log
%ghost %attr(0644,root,root) %{_localstatedir}/log/apache2/software.opensuse.org-error.log
%dir %{_sysconfdir}/logrotate.d
%{_sysconfdir}/logrotate.d/%{name}-apache2

