# -*- coding: utf-8 -*-

require 'gettext_i18n_rails/string_interpolate_fix'

LANGUAGES = %w{en}
Dir.glob("#{Rails.root.join('locale')}/*/software.po").each { |file|
   lang = file.gsub(/^.*locale\/([^\/]*)\/.*$/, '\\1')
   LANGUAGES << lang
}

LANGUAGE_NAMES = {
  'ar' => 'العربية',
  'bg' => 'Български',
  'ca' => 'Català',
  'cs' => 'Čeština',
  'da' => 'Dansk',
  'de' => 'Deutsch',
  'el' => 'Ελληνικά',
  'en' => 'English',
  'es' => 'Español',
  'et' => 'eesti keel',
  'fa' => 'فارسی',
  'fi' => 'Suomi',
  'fr' => 'Français',
  'gl' => 'Galego',
  'hi' => 'हिन्दी',
  'hu' => 'Magyar',
  'id' => 'Bahasa Indonesia',
  'it' => 'Italiano',
  'ja' => '日本語',
  'kab' => 'ⵜⴰⵇⴱⴰⵢⵍⵉⵜ',
  'km' => 'ភាសាខ្មែរ',
  'ko' => '한국어',
  'lt' => 'Lietuvių',
  'nb' => 'Bokmål',
  'nl' => 'Nederlands',
  'nn' => 'Nynorsk',
  'pl' => 'Polski',
  'pt_PT' => 'Português',
  'pt_BR' => 'Português (Brazil)',
  'ro' => 'Română',
  'ru' => 'Русский',
  'si' => 'සිංහල',
  'sk' => 'Slovenčina',
  'sv' => 'Svenska',
  'th' => 'ภาษาไทย',
  'tzm' => 'Tamaziɣt n aṭlaṣ',
  'uk' => 'Українська',
  'wa' => 'Walon',
  'zh_TW' => '繁體中文',
  'zh_CN' => '简体中文',
}

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
