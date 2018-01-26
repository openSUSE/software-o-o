# -*- coding: utf-8 -*-

require 'gettext_i18n_rails/string_interpolate_fix'

LANGUAGES = %w{en}
Dir.glob("#{Rails.root.join('locale')}/*/software.po").each { |file|
   lang = file.gsub(/^.*locale\/([^\/]*)\/.*$/, '\\1')
   LANGUAGES << lang
}

LANGUAGE_NAMES = {'en' => 'English', 'de' => 'Deutsch', 'bg' => 'български', 'da' => 'dansk',
                  'cs' => 'čeština', 'es' => 'español', 'fi' => 'suomi', 'fr' => 'français',
                  'gl' => 'Galego', 'hu' => 'magyar', 'ja' => '日本語', 'it' => 'italiano',
                  'km' => 'ភាសាខ្មែរ', 'ko' => '한국어 [韓國語]', 'lt' => 'lietuvių kalba', 'nb' => 'Bokmål',
                  'nl' => 'Nederlands', 'pl' => 'polski', 'ro' => 'român', 'ru' => 'Русский язык',
                  'sk' => 'slovenčina', 'th' => 'ภาษาไทย', 'uk' => 'Українська', 'wa' => 'walon',
                  'pt_BR' => 'português', 'zh_TW' => '台語', 'zh_CN' => '简体中文',
                  'el' => 'ελληνικά', 'ar' => 'العربية', 'ca' => 'Català'}

# Use po files for development/test...
FastGettext.add_text_domain('software', path: 'locale', type: :po, ignore_fuzzy: true, report_warning: false) unless Rails.env.production?
# and mo files in production for performance
FastGettext.add_text_domain('software', path: 'locale') if Rails.env.production?

# Explicity adding the available locales to both FastGettext and I18n in order
# to config.i18n.enforce_available_locales to work properly
FastGettext.available_locales = I18n.available_locales = LANGUAGES #all you want to allow

# Temporary hack to fix a problem with locales including "_"
I18n.available_locales += FastGettext.available_locales.grep(/_/).map {|i| i.gsub("_", "-") }

FastGettext.default_text_domain = 'software'
FastGettext.default_locale = 'en'
