# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Leap 15.6
leap_previous = Distribution.create!(name: 'openSUSE-Leap-15.6', url: 'https://get.opensuse.org/leap/15.6/', obs_repo_names: 'openSUSE:Leap:15.6')
leap_previous.repositories.create!(url: 'http://download.opensuse.org/distribution/leap/15.6/repo/oss/')
leap_previous.repositories.create!(url: 'http://download.opensuse.org/distribution/leap/15.6/repo/non-oss/')
leap_previous.repositories.create!(url: 'http://download.opensuse.org/update/leap/15.6/oss/', updateinfo: true)
leap_previous.repositories.create!(url: 'http://download.opensuse.org/update/leap/15.6/non-oss/', updateinfo: true)
leap_previous.repositories.create!(url: 'http://download.opensuse.org/update/leap/15.6/sle/', updateinfo: true)

# Leap 16.0
leap_current = Distribution.create!(name: 'openSUSE-Leap-16.0', url: 'https://get.opensuse.org/leap/16.0/', obs_repo_names: 'openSUSE:Leap:16.0')
leap_current.repositories.create!(url: 'http://download.opensuse.org/distribution/leap/16.0/repo/oss/x86_64')
leap_current.repositories.create!(url: 'http://download.opensuse.org/distribution/leap/16.0/repo/non-oss/x86_64')

# Tumbleweed
tumbleweed = Distribution.create!(name: 'openSUSE-Tumbleweed', url: 'https://get.opensuse.org/tumbleweed', obs_repo_names: 'openSUSE:Factory')
tumbleweed.repositories.create!(url: 'http://download.opensuse.org/tumbleweed/repo/oss')
tumbleweed.repositories.create!(url: 'http://download.opensuse.org/tumbleweed/repo/non-oss')
tumbleweed.repositories.create!(url: 'http://download.opensuse.org/update/tumbleweed/', updateinfo: true)
tumbleweed.repositories.create!(url: 'http://download.opensuse.org/update/tumbleweed-non-oss/', updateinfo: true)

