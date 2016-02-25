#
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
# ---------------------------------------------------------------
#
# This layout uses the Role/Profile model from
#    http://www.craigdunn.org/2012/05/239/
#
# A node should have one role (e.g. webserver), and that role
# can include multiple profiles (e.g. apache, mysql, etc).
#
# "Roles are intended to be aggregator Puppet classes. Apply a
#  single role at the classification level. If more than one
#  role is being applied to a single node, perhaps it should be
#  a profile instead, or perhaps that combination of profiles
#  should be turned into a role."
#
# "Profiles are intended to be aggregator Puppet classes that
#  put together utility modules to construct site-meaningful
#  configurations. They deal with high-level abstractions and
#  glue them together. Multiple profiles may be deployed to a
#  single machine. Profiles are often the building blocks of
#  Roles."
# ---------------------------------------------------------------

# ---------------------------------------------------------------
# Globals
# ---------------------------------------------------------------

$rsync_module_description = 'RPKI Testbed Googlez'

# syslog servers that all clients will use 
$syslog_servers = [
                   'log-1.example.com',
                  ]

$puppet_server = 'puppet.example.com'

# where do publication servers get their data?
# TODO: handle multiple sources, distribute amongst pub servers
$ca_server = 'ca.example.com'

# publication servers
$publication_servers = [
                        'publish-1.example.com',
                        ]

# ip range for ssh access on port 22
$ssh_client_range = '0.0.0.0/0'

# ---------------------------------------------------------------
# Nodes
# ---------------------------------------------------------------

# ------------------------------------
# syslog servers
node 'log-1.example.com'
{
  include rpki::role::log_server
}

# ------------------------------------
# publication nodes
node 'publish-1.example.com'
{
  include rpki::role::pub_server
}

# ------------------------------------
node 'ca.example.com'
{
  include rpki::role::rpki_master
}

# ------------------------------------
node 'puppet.example.com'
{
  include rpki::role::puppet_master
}

# ------------------------------------
node "default" {
  include stdlib
  class { "common_config": }

  class { "rpki::puppet_config":
     puppetServer => $puppet_server,
  }
}

# ---------------------------------------------------------------------
# Classes
# ---------------------------------------------------------------------

class common_config {
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
