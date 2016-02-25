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

class rpki(
  $baseDir   = $::rpki::params::baseDir,
  $logServer = $::rpki::params::logServer,
  
  # ssh
  $sshRestrictSource = $::rpki::params::sshRestrictSource,
  $sshPort = $::rpki::params::sshPort,
  $sshUnrestrictedPort = $::rpki::params::sshUnrestrictedPort,

  # log server
  $roleLogServer = $::rpki::params::roleLogServer,
  $logPort = $::rpki::params::logPort,

  # publication server
  $rolePublicationServer = $::rpki::params::rolePublicationServer,
  $rsyncPort = $::rpki::params::rsyncPort,
  $publicationBase = $::rpki::params::publicationBase,
  $publicationName = $::rpki::params::publicationName,

  # puppet server
  $rolePuppetServer = $::rpki::params::rolePuppetServer,
  $puppetPort = $::rpki::params::puppetPort,

  # rpki CA
  $roleRPKI_CA = $::rpki::params::roleRPKI_CA,
  $rpkiCAport = $::rpki::params::rpkiCAport,

  # rpki RP
  $roleRPKI_RP = $::rpki::params::roleRPKI_RP,
  $rpkiRPport = $::rpki::params::rpkiRPport,
  
  ) inherits ::rpki::params {

  # This will run apt-update before any package is installed, which
  # is needed when a new repo is added.
  #
  # Unfortunately, it seems to be run every time puppet runs, so
  # that needs to be figured out at come point
  #
  # currently disabled, since we're not adding the rpki.net repo (yet)
  #
  #exec { 'apt-update':
  #  command => '/usr/bin/apt-get update',
  #  #refreshonly => true,
  #}
  #
  # do apt update before any package get installed
  #Exec["apt-update"] -> Package <| |>

  anchor { 'rpki::begin': }
  anchor { 'rpki::end': }
  Anchor['rpki::begin'] ->
    Class['rpki::install'] ->
    Class['rpki::config'] ->
    Class['rpki::service'] ->
  Anchor['rpki::end']

  include rpki::install
  include rpki::config
  include rpki::service
}
