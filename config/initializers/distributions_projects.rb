# frozen_string_literal: true

# maps a distro_id to an Array of project names that could be the baseproject
DISTRIBUTION_PROJECTS_OVERRIDE = {
  # Leap 15.3
  '20043' => ['SUSE:SLE-15:GA', 'SUSE:SLE-15:Update', 'SUSE:SLE-15-SP1:GA',
              'SUSE:SLE-15-SP1:Update', 'SUSE:SLE-15-SP2:GA', 'SUSE:SLE-15-SP2:Update',
              'SUSE:SLE-15-SP3:GA', 'SUSE:SLE-15-SP3:Update', 'openSUSE:Leap:15.3', 'openSUSE:Backports:SLE-15-SP3']
}.freeze
