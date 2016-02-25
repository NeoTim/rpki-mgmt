# Copyright 2014 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class rpki::config(
  ) inherits ::rpki::params
{
  file { '/etc/default/puppet':
    source => "puppet:///modules/rpki/default-puppet",
    ensure => 'file',
  }
  file { '/etc/puppet/puppet.conf':
    source => "puppet:///modules/rpki/puppet.conf",
    ensure => 'file',
  }
  file { '/usr/local/bin/puppet_cleanup.sh':
    source => "puppet:///modules/rpki/puppet_cleanup.sh",
    ensure => 'file',
    mode => '0755',
  } ->
  service { 'puppet':
    ensure => "running",
    enable => 'true',
    require => Package['puppet'],
  }

  # Run puppet cleanup, make sure puppet is not hung, restart if it has.
  cron { puppet_cleanup:
    command => "/usr/local/bin/puppet_cleanup.sh >> /tmp/puppet_cleanup.log 2>&1",
    ensure => 'present',
    user => 'root',
    minute => 0,
  }

  service { 'syslog-ng':
    ensure => "running",
    enable => 'true',
    require => Package['syslog-ng'],
  }

  # --- Users ---
  #
  # morrowc
  #
  user {'morrowc':
    ensure => 'present',
  }

  # rstory
  #
  user {'rstory':
    ensure => 'present',
    shell => '/bin/bash',
  }

}
