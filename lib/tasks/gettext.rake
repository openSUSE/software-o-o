#
# Added for Ruby-GetText-Package
#

POT_FILE = "locale/software.pot".freeze

def each_po_file
  @po_files ||= Dir.glob("locale/*/software.po")

  @po_files.each do |file|
    lang = file_to_lang(file)
    yield(file, lang)
  end
end

def file_to_lang(file)
  file.to_s.split("/")[-2]
end

def backup_po_files
  each_po_file do |file, _lang|
    system("cp #{file} #{file}.back")
  end
end

def restore_po_files
  each_po_file do |file, _lang|
    system("mv #{file}.back #{file}")
  end
end

def msgmerge_po_files
  each_po_file do |file, lang|
    print "Merging #{lang}"
    command = "msgmerge --previous --lang=#{lang} #{file} #{POT_FILE} -o #{file}.new"
    raise "ERROR running #{command}" unless system(command)
    system "mv #{file}.new #{file}"
  end
end

desc "Import translations into .mo files"
task :makemo do
  backup_po_files
  Rake::Task['gettext:pack'].invoke
  restore_po_files
end

# We want strict control on the command used to refresh the .po files
desc "Invokes msgmerge to update pot/po files"
task :updatepo do
  backup_po_files
  Rake::Task['gettext:find'].invoke
  restore_po_files
  msgmerge_po_files
end
