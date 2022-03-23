all: update-chameleon

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
