all: build build_mo build_assets

install: prepare_dirs system_files app_files log_files

RUBY_VERSION=3.4

build:
	bundle.ruby$(RUBY_VERSION) config build.nokogiri --use-system-libraries
	bundle.ruby$(RUBY_VERSION) config build.ffi --enable-system-libffi
	bundle.ruby$(RUBY_VERSION) config build.sassc --disable-march-tune-native
	bundle.ruby$(RUBY_VERSION) config set --local path 'vendor/bundle'
	bundle.ruby$(RUBY_VERSION) install --jobs=4 --retry=3 --local
	sed -i -e 's,/usr/bin/bundle,/usr/bin/bundle.ruby$(RUBY_VERSION),' dist/software_opensuse_org.service

build_mo: build
	bundle.ruby$(RUBY_VERSION) exec rake makemo

build_assets: build
	bundle.ruby$(RUBY_VERSION) exec rake --trace assets:precompile RAILS_ENV=production RAILS_GROUPS=assets
	bundle.ruby$(RUBY_VERSION) exec rake --trace tmp:clear RAILS_ENV=production

prepare_dirs:
	install -d -m 755 $(DESTDIR)/srv/www/vhosts/opensuse.org/software/current
	install -d -m 0750 $(DESTDIR)/srv/www/vhosts/opensuse.org/software/current/tmp/pids
	install -d -m 0750 $(DESTDIR)/srv/www/vhosts/opensuse.org/software/current/log
	install -d -m 755 $(DESTDIR)/usr/lib/systemd/system
	install -d -m 755 $(DESTDIR)/etc/apache2/vhosts.d
	install -d -m 755 $(DESTDIR)/etc/logrotate.d
	install -d -m 755 $(DESTDIR)/var/log/apache2

system_files: prepare_dirs
	install -m 644 dist/software_opensuse_org.service $(DESTDIR)/usr/lib/systemd/system/
	install -m 644 dist/vhost-software_opensuse_org.conf $(DESTDIR)/etc/apache2/vhosts.d/
	install -m 644 dist/apache2-software.o.o.lr $(DESTDIR)/etc//logrotate.d/software_opensuse_org-apache2

app_files: prepare_dirs cleanup
	cp -a * .bundle $(DESTDIR)/srv/www/vhosts/opensuse.org/software/current/

log_files: prepare_dirs
	touch $(DESTDIR)/var/log/apache2/software.opensuse.org-access.log
	touch $(DESTDIR)/var/log/apache2/software.opensuse.org-error.log

cleanup: permission_cleanup
	rm -rf tmp test log dist opensuse-theme-chameleon
	rm -f config/deploy.rb CONTRIBUTING.md Dockerfile LICENSE README.md TODO docker-compose.override.yml.example docker-compose.yml Gemfile.next Gemfile.next.lock
	find . -name '*.[cha]' -print0 | xargs -0 rm
	# remove .gitignore
	find . -name .gitignore | xargs rm -f
	# remove .pc files
	find . -name msgpack.pc | xargs rm -f
	# remove backup files
	find . -name \*~ | xargs rm -f
	# remove .keep files
	find . -name .keep | xargs rm -f
	# remove .po files
	find . -name software.po* | xargs rm -f
	find . -name software.edit.po* | xargs rm -f

permission_cleanup:
	 chmod -R o=   .
	 chmod    o+X  .
	 chmod -R o+rX public
	 chmod -R o+rX public/assets/*

update-chameleon:
	rm -rf app/assets/stylesheets/chameleon
	mkdir -p app/assets/stylesheets/chameleon
	rm -rf app/assets/javascript/chameleon
	mkdir -p app/assets/javascripts/chameleon
	rm -rf app/assets/images/chameleon
	mkdir -p app/assets/images/chameleon
	rm -rf app/assets/fonts/chameleon
	mkdir -p app/assets/fonts/chameleon
	cp -r opensuse-theme-chameleon/dist/js/* app/assets/javascripts/chameleon/
	cp -r opensuse-theme-chameleon/dist/css/* app/assets/stylesheets/chameleon/
	cp -r opensuse-theme-chameleon/dist/fonts/* app/assets/fonts/chameleon/
	cp -r opensuse-theme-chameleon/dist/images/* app/assets/images/chameleon/

        # Fix font paths to be picked up by Rails
	sed -i 's,url("../fonts/,font_url("chameleon/,g' app/assets/stylesheets/chameleon/chameleon.css
	mv app/assets/stylesheets/chameleon/chameleon.css app/assets/stylesheets/chameleon/chameleon.css.scss

