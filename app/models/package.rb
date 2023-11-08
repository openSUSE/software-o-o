# frozen_string_literal: true

# A binary package of a Linux distribution repository
class Package < ApplicationRecord
  belongs_to :repository
  has_many :patches, dependent: :destroy
  has_and_belongs_to_many :categories, -> { distinct }
  has_one :distribution, through: :repository
  has_many_attached :screenshots
  has_many_attached :icons

  validates :name, :release, :architectures, :license, presence: true
  validates :name, uniqueness: { scope: :repository }
  serialize :architectures, type: Array

  SUPPORT_PACKAGE_NAME_PARTS = ['-branding-', '-extension-', '-plugin-', '-plugins-',
                                '-trans-', '-translations-', '-traineddata-'].freeze
  SUPPORT_PACKAGE_NAME_ENDINGS = ['-32bit', '-data', '-devel', '-devel-static', '-doc', '-docs', '-docs-html', '-debug',
                                  '-compat', '-api', '-addons',
                                  '-font', '-fonts', '-extra', '-extras', 'extension', '-extensions', '-example', '-examples',
                                  '-headers', '-imports', '-icons', '-javadoc',
                                  '-lang', '-lib', '-libs', '-locale', '-module', '-modules',
                                  '-plugin', '-plugins', '-schema', '-schemas', '-source', '-src', '-support', '-systemd',
                                  '-test', '-testresults', '-tests', '-testsuite', '-theme', '-themes', '-translations',
                                  '-wallpaper', '-wallpapers'].freeze
  SUPPORT_PACKAGE_NAME_BEGINNINGS = ['system-', 'php8-', 'php7-', 'aws-sdk-', 'ocaml-', 'aspell-',
                                     'patterns-', 'cross-', 'myspell-', 'libqt5-', 'maven-',
                                     'typelib-', 'qt6-', 'ruby2.5-', 'ghc-', 'perl-', 'python3-', 'texlive-'].freeze

  def title
    name unless read_attribute(:title)
  end

  def main_package?
    SUPPORT_PACKAGE_NAME_PARTS.each do |part|
      return false if name.include?(part)
    end

    SUPPORT_PACKAGE_NAME_BEGINNINGS.each do |beginning|
      return false if name.starts_with?(beginning)
    end

    SUPPORT_PACKAGE_NAME_ENDINGS.each do |ending|
      return false if name.ends_with?(ending)
    end

    true
  end
end
