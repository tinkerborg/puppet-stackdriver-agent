# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# == Class: stackdriver::plugin::puppet_agent::config
#
# Configures Puppet Agent Plugin for Stackdriver Agent
#
class stackdriver::plugin::puppet_agent::config(

) inherits stackdriver::plugin::puppet_agent {

  file { $config:
    ensure  => file,
    content => template("stackdriver/${::kernel}/${config}.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0440', # secure
    notify  => Service[$::stackdriver::svc],
  }

  # The script uses python-yaml to parse
  # the puppet last run output.
  package { 'python-yaml':
    ensure => 'installed'
  }

  # Ensure permissions are correct (user: nobody runs this script
  # and the permissions need to allow for this.
  file { '/opt/puppetlabs/puppet/cache':
    ensure => 'directory',
    #owner  => 'root',
    #group  => 'root',
    mode   => '0751'
  }

  # Ensure the scripts directory exists.
  #file { '/opt/stackdriver/collectd/etc/scripts/':
  #  ensure => 'directory',
  #  path   => '/opt/stackdriver/collectd/etc/scripts/',
  #  owner  => 'root',
  #  group  => 'root',
  #  mode   => '0644'
  #} 

  # Drop in the shell script which will be invoked by the collect 'exec' plugin.
  # Referenced from hiera.
  file { '/opt/stackdriver/collectd/etc/scripts/exec_puppet_metrics.sh':
    ensure => 'present',
    content => template('stackdriver/puppet_agent/exec_puppet_metrics.sh.erb'),
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    #notify => Service['stackdriver-agent']
  }
  
}
