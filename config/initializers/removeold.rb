# remove static cache files
%w{developer 112 113 114 121 122}.each { |release|
   FileUtils.rm_rf Rails.root.join("public", release)
}
