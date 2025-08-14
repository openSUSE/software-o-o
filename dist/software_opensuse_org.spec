# FIXME: should be /usr/share with writable directories in /var
%define basedir  /srv/www/vhosts/opensuse.org/software/current
%define run_as_user   soorun
%define run_as_group  soorun

%define soo_ruby_suffix ruby3.4

#
Name:           software_opensuse_org
Version:        15.3.git20220301.e821b453
Release:        0
Summary:        Package for deploying software.opensuse.org
License:        GPL-2.0
Group:          Productivity/Networking/Web/Utilities
Url:            http://software.opensuse.org
Source:         software-o-o-%{version}.tar.xz
Source1:        software_opensuse_org.service
Source2:        vhost-software_opensuse_org.conf
Source4:        apache2-software.o.o.lr
# memcache is required for session data
Requires:       memcached
Conflicts:      memcached < 1.4

Requires:       %{soo_ruby_suffix}
Requires:       ImageMagick
# rubygem uglifier needs some js runtime
Requires:       nodejs
BuildRequires:  xz
BuildRequires:  fdupes
BuildRequires:  systemd-rpm-macros
# needed by native extensions
BuildRequires:  %{soo_ruby_suffix}-devel
BuildRequires:  libxml2-devel
BuildRequires:  libxslt-devel
BuildRequires:  libsass-devel
BuildRequires:  libyaml-devel
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
BuildArch:      noarch
%description    apache2
Exposes software.opensuse.org service as an apache virtual host

%prep
%autosetup -n software-o-o-%{version} -p1

%build
gem="gem.%{soo_ruby_suffix}"
bundle="bundle.%{soo_ruby_suffix}"
$bundle config build.nokogiri --use-system-libraries
$bundle config build.sassc --disable-march-tune-native
$bundle config set --local path 'vendor/bundle'
$bundle install --jobs=4 --retry=3 --local
# generate mo files
$bundle exec rake makemo
$bundle exec rake --trace assets:precompile RAILS_ENV=production RAILS_GROUPS=assets
$bundle exec rake --trace tmp:clear RAILS_ENV=production
#
%install
mkdir -p %{buildroot}%{_unitdir}/
install -m 644 %{SOURCE1} %{buildroot}%{_unitdir}/
mkdir -p %{buildroot}%{_sysconfdir}/apache2/vhosts.d
install -m 644 %{SOURCE2} %{buildroot}%{_sysconfdir}/apache2/vhosts.d
# apache logs
mkdir -p %{buildroot}%{_localstatedir}/log/apache2
touch %{buildroot}%{_localstatedir}/log/apache2/software.opensuse.org-access.log
touch %{buildroot}%{_localstatedir}/log/apache2/software.opensuse.org-error.log
mkdir -p %{buildroot}%{_sysconfdir}/logrotate.d
install -m 644 %{SOURCE4} %{buildroot}%{_sysconfdir}/logrotate.d

# just in case, force specific ruby version
sed -i -e 's,/usr/bin/bundle,/usr/bin/bundle.%{soo_ruby_suffix},' %{buildroot}%{_unitdir}/software_opensuse_org.service
install -dD -m 0750 %{buildroot}%{basedir}
cp -a * .bundle %{buildroot}%{basedir}
find %{buildroot}%{basedir} -name '*.[cha]' -print0 | xargs -0 rm
install -d -m 0750 %{buildroot}%{basedir}/tmp
install -d -m 0750 %{buildroot}%{basedir}/tmp/pids
install -d -m 0750 %{buildroot}%{basedir}/log
install -d -m 0755 %{buildroot}%{basedir}/public/images/thumbnails
# permissions clean up
chmod -R o=   %{buildroot}%{basedir}
chmod    o+X  %{buildroot}%{basedir}
chmod -R o+rX %{buildroot}%{basedir}/public/
chmod -R o+rX public/assets/*
rm -rf tmp/*
#
find %{buildroot}%{basedir} -name .gitignore | xargs rm -f
# rbtrace
find %{buildroot}%{basedir} -name msgpack.pc | xargs rm -f
# backup files
find %{buildroot}%{basedir} -name \*~ | xargs rm -f

%find_lang %{name} --all-name
%fdupes -s %{buildroot}

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

%files -f %{name}.lang
%defattr(-,root,root)
%dir /srv/www/vhosts/
%dir /srv/www/vhosts/opensuse.org/
%dir /srv/www/vhosts/opensuse.org/software/
%{_unitdir}/software_opensuse_org.service
%defattr(-,root,%{run_as_group})
%{basedir}
%defattr(-,%{run_as_user},%{run_as_group})
%dir %{basedir}/log/
%dir %{basedir}/tmp/
%dir %{basedir}/tmp/pids
%dir %{basedir}/public/images/thumbnails
# FIXME: log files belong to /var/log
%ghost %{basedir}/log/production.log
%config(noreplace) %{basedir}/config/options.yml

%files apache2
%defattr(-,root,root)
%dir %{_sysconfdir}/apache2
%dir %{_sysconfdir}/apache2/vhosts.d
%config(noreplace) %{_sysconfdir}/apache2/vhosts.d/vhost-software_opensuse_org.conf
%dir %{_localstatedir}/log/apache2
%ghost %{_localstatedir}/log/apache2/software.opensuse.org-access.log
%ghost %{_localstatedir}/log/apache2/software.opensuse.org-error.log
%dir %{_sysconfdir}/logrotate.d
%{_sysconfdir}/logrotate.d/apache2-software.o.o.lr


%changelog

