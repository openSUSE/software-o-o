module MainHelper

  def default_baseproject
    cookies[:search_baseproject] || 'openSUSE:11.2'
  end

  def baseproject_list_for_select
    [
      ['openSUSE Factory','openSUSE:Factory'],
      ['openSUSE 11.2','openSUSE:11.2'],
      ['openSUSE 11.1','openSUSE:11.1'],
      ['openSUSE 11.0','openSUSE:11.0'],
      ['SLES/SLED 11','SUSE:SLE-11'],
      ['SLES/SLED 10','SUSE:SLE-10'],
      ['SLES 9','SUSE:SLES-9'],
      ['Fedora 12','Fedora:12'],
      ['Fedora 11','Fedora:11'],
      ['Fedora 10','Fedora:10'],
      ['RHEL 5','RedHat:RHEL-5'],
      ['RHEL 4','RedHat:RHEL-4'],
      ['CentOS 5','CentOS:CentOS-5'],
      ['Mandriva 2010','Mandriva:2010'],
      ['Mandriva 2009.1','Mandriva:2009.1'],
      ['Mandriva 2009','Mandriva:2009'],
      ['Debian 5.0 (Lenny)','Debian:5.0'],
      ['Debian 4.0 (Etch)','Debian:Etch'],
      ['Ubuntu 9.10','Ubuntu:9.10'],
      ['Ubuntu 9.04','Ubuntu:9.04'],
      ['Ubuntu 8.10','Ubuntu:8.10'],
      ['Ubuntu 8.04','Ubuntu:8.04'],
      ['Ubuntu 6.06','Ubuntu:6.06'],
      ['ALL','ALL']
    ]
  end
end
