desc "update the Changelog file from svn log entries, check in the changelog, branch"
task :update_changelog, :roles => [:db, :web, :app] do
  require 'rexml/document'
  require 'net/smtp'

  server_rev(self)
  #check if changelog has local changes
  puts "Checking changelog status..."
  changelog_status = `svn status -u Changelog`.split("\n")
  if changelog_status.length > 1
    puts "-"*72
    puts changelog_status[0]
    puts "-"*72
    raise "Changelog is dirty, please check in and/or resolve conflicts"
  end

  changelog = changelog_entry( self )

  puts "Appending changelog..."
  File.open('Changelog', 'a') do |f|
    f.print "#{changelog}\n"
  end

  puts "Checking in changelog..."
  `svn ci -m "automated changelog update" Changelog`

  puts "Branching to branch: #{cl_branch_url}"
  `svn copy #{repository} #{cl_branch_url} -m 'automated deploy branch'`
  
  subject = "[deploy] #{application} update from rev #{server_rev(self)} to rev #{head_rev(self)}"
  from = cl_mail_from
  to = cl_mail_to

  body = <<-END
From: #{from}
To: #{to.to_a.join(", ")}
Subject: #{subject}
Content-Type: text/plain

[Automated Mail]

User #{svnuser} deployed #{application}.
A branch of revision #{head_rev(self)} has been created at #{cl_branch_url}

Changelog:

#{changelog}
------------------------------------------------------------------------
END

  puts "Mailing changelog..."
  Net::SMTP.start('relay.suse.de', 25) do |smtp|
    smtp.send_message body, from, to
  end
end

desc "show the changelog entry that would be generated on an deploy"
task :show_changelog, :roles => :web do
  puts changelog_entry( self )
end

desc "deploy current revision into staging area"
task :deploy_stage, :roles => [:web, :app, :db] do
  set :deploy_to, stage_deploy_to
  
  # FIXME: hack: undefine after_update_code handler (changelog sending) for stage
  class << self
    def update_changelog; end
  end

  transaction do
    update_code
    symlink
  end
end

desc "set up application structure on staging servers"
task :setup_stage, :roles => [:web, :app, :db] do
  set :deploy_to, stage_deploy_to
  setup
end

### helper methods

def changelog_entry( actor )
  return $opensuse_changelog_entry unless $opensuse_changelog_entry.nil?
  
  puts "Retrieving log..."
  log_xml_str = `svn log -r#{server_rev(actor)+1}:HEAD --xml`

  log_xml_doc = REXML::Document.new( log_xml_str )

  changelog = String.new
  changelog << "-"*72+"\n"
  changelog << "#{Time.now} - #{svnuser}\n\n"
  changelog << "- update from svn revision #{server_rev(actor)} to #{head_rev(actor)}\n"

  log_xml_doc.root.elements.each('logentry') do |logentry|
    msg = logentry.elements['msg'].text
    next if msg =~ /^automated changelog update/
    
    author = logentry.elements['author'].text
    rev = logentry.attributes['revision']
    
    #msg << "[rev #{rev} #{author}]"
    msg << "\n" unless msg[-1,1] == "\n"
    
    unless msg =~ /^-/
      msg.sub!( /^/, "- " )
    end
    msg.gsub!( /^([^- ])/m, '  \1' )

    changelog << msg
  end
  changelog << "\n"
  $opensuse_changelog_entry = changelog
end

def server_rev( actor )
  return $opensuse_server_rev unless $opensuse_server_rev.nil?
  return $opensuse_server_rev = actor.source.current_revision(actor)
end

def head_rev( actor )
  return $opensuse_head_rev unless $opensuse_head_rev.nil?
  return $opensuse_head_rev = `svn info -rHEAD|grep Revision|awk '{print $2}'`.chomp.to_i
end
