# frozen_string_literal: true

# maps a distro_id to an Array of project names that could be the baseproject
DISTRIBUTION_PROJECTS_OVERRIDE = {
  # Leap 15.4
  '23178' => ['SUSE:SLE-15:GA', 'SUSE:SLE-15:Update',
              'SUSE:SLE-15-SP1:GA', 'SUSE:SLE-15-SP1:Update',
              'SUSE:SLE-15-SP2:GA', 'SUSE:SLE-15-SP2:Update',
              'SUSE:SLE-15-SP3:GA', 'SUSE:SLE-15-SP3:Update',
              'SUSE:SLE-15-SP4:GA', 'SUSE:SLE-15-SP4:Update',
              'openSUSE:Backports:SLE-15-SP4', 'openSUSE:Leap:15.4'],
  # Leap 15.5
  '23175' => ['SUSE:SLE-15:GA', 'SUSE:SLE-15:Update',
              'SUSE:SLE-15-SP1:GA', 'SUSE:SLE-15-SP1:Update',
              'SUSE:SLE-15-SP2:GA', 'SUSE:SLE-15-SP2:Update',
              'SUSE:SLE-15-SP3:GA', 'SUSE:SLE-15-SP3:Update',
              'SUSE:SLE-15-SP4:GA', 'SUSE:SLE-15-SP4:Update',
              'SUSE:SLE-15-SP5:GA', 'SUSE:SLE-15-SP5:Update',
              'openSUSE:Backports:SLE-15-SP5', 'openSUSE:Leap:15.5'],
  '29817' => ['SUSE:SLE-15:GA', 'SUSE:SLE-15:Update',
              'SUSE:SLE-15-SP1:GA', 'SUSE:SLE-15-SP1:Update',
              'SUSE:SLE-15-SP2:GA', 'SUSE:SLE-15-SP2:Update',
              'SUSE:SLE-15-SP3:GA', 'SUSE:SLE-15-SP3:Update',
              'SUSE:SLE-15-SP4:GA', 'SUSE:SLE-15-SP4:Update',
              'SUSE:SLE-15-SP5:GA', 'SUSE:SLE-15-SP5:Update',
              'openSUSE:Backports:SLE-15-SP5', 'openSUSE:Leap:15.5'],
  # Leap 15.6
  '29814' => ['SUSE:SLE-15:GA', 'SUSE:SLE-15:Update',
              'SUSE:SLE-15-SP1:GA', 'SUSE:SLE-15-SP1:Update',
              'SUSE:SLE-15-SP2:GA', 'SUSE:SLE-15-SP2:Update',
              'SUSE:SLE-15-SP3:GA', 'SUSE:SLE-15-SP3:Update',
              'SUSE:SLE-15-SP4:GA', 'SUSE:SLE-15-SP4:Update',
              'SUSE:SLE-15-SP5:GA', 'SUSE:SLE-15-SP5:Update',
              'SUSE:SLE-15-SP6:GA', 'SUSE:SLE-15-SP6:Update',
              'openSUSE:Backports:SLE-15-SP6', 'openSUSE:Leap:15.6'],
  # Leap 16.0
  '29811' => ['SUSE:SLE-16:GA', 'SUSE:SLE-16:Update',
              'openSUSE:Backports:SLE-16.0', 'openSUSE:Leap:16.0']
}.freeze
