#
# Added for Ruby-GetText-Package
#

desc "Create mo-files for L10n"
task :makemo do
require 'gettext/utils'
system("cd $MY_LCN_CHECKOUT && svn up")
files = Dir.glob(ENV["MY_LCN_CHECKOUT"] + "/*/po/software-opensuse-org*.po")
files.each { |file| 
  lang=File.basename(file, ".po").split('.')[1]
  ilang=lang
  #puts "msgfmt -o locale/%s/LC_MESSAGES/software.mo '%s'" % [lang, file]
  res=''
  IO.popen( "LC_ALL=C msgfmt --statistics -o messages.mo '%s' 2>&1" % file ) { |f| res=f.gets }
  if res =~ /^\w* translated messages.$/
    #puts res
    FileUtils.mkdir_p "locale/" + ilang + "/LC_MESSAGES"
    puts "take %s into %s" % [lang, ilang]
    FileUtils.mv "messages.mo", "locale/%s/LC_MESSAGES/software.mo" % ilang
  else
    FileUtils.rm "messages.mo"
  end
}
end

desc "Update pot/po files to match new version."
task :updatepo do
require 'gettext/utils'
files = Dir.glob("{app,lib}/**/*.{rb,rhtml}")
GetText.rgettext(files, "tmp.pot")
system("cd $MY_LCN_CHECKOUT && svn up")
system("msgmerge -o $MY_LCN_CHECKOUT/50-pot/software-opensuse-org.pot $MY_LCN_CHECKOUT/50-pot/software-opensuse-org.pot tmp.pot")
FileUtils.rm_f "tmp.pot"
system("cd $MY_LCN_CHECKOUT && sh ./50-tools/lcn-merge.sh -p software-opensuse-org.pot -s -n")
end
