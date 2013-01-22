#
# Added for Ruby-GetText-Package
#

desc "Import clean (non-fuzzy) .mo files from lcn checkout"
task :makemo do
  raise "ERROR: $MY_LCN_CHECKOUT should point to your checkout of https://svn.opensuse.org/svn/opensuse-i18n/trunk/lcn" if ENV["MY_LCN_CHECKOUT"].nil?
  system("cd $MY_LCN_CHECKOUT && svn up")
  files = Dir.glob(ENV["MY_LCN_CHECKOUT"] + "/*/po/software-opensuse-org*.po")
  files.each { |file|
    lang=File.basename(file, ".po").split('.')[1]
    ilang=lang
    #puts "msgfmt -o locale/%s/LC_MESSAGES/software.mo '%s'" % [lang, file]
    res=''
    IO.popen( "LC_ALL=C msgfmt --statistics -o messages.mo '%s' 2>&1" % file ) { |f| res=f.gets }
    #puts "#{lang}: #{res}"
    # copy only if it contains non-fuzzy translations
    res = begin Integer(/^(\w*) translated messages/.match(res)[1]) rescue 0 end
    if res > 100
      puts res.inspect
      FileUtils.mkdir_p "locale/" + ilang + "/LC_MESSAGES"
      puts "take %s into %s" % [lang, ilang]
      FileUtils.mv "messages.mo", "locale/%s/LC_MESSAGES/software.mo" % ilang
    else
      FileUtils.rm "messages.mo"
    end
  }
end


desc "Update pot/po files in lcn checkout to match new version."
task :updatepo do
  raise "ERROR: $MY_LCN_CHECKOUT should point to your checkout of https://svn.opensuse.org/svn/opensuse-i18n/trunk/lcn" if ENV["MY_LCN_CHECKOUT"].nil?
  Rake::Task['gettext:find'].invoke
  system("cd $MY_LCN_CHECKOUT && svn up")
  system("msgmerge -o $MY_LCN_CHECKOUT/50-pot/software-opensuse-org.pot $MY_LCN_CHECKOUT/50-pot/software-opensuse-org.pot locale/software.pot")
  system("cd $MY_LCN_CHECKOUT && sh ./50-tools/lcn-merge.sh -p software-opensuse-org.pot -s -n")
end
