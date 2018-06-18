# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# == Class: stackdriver::config::redhat
#
# Configures Stackdriver Agent for RedHat derivatives
#
# === Parameters
#
# Use Hiera for overriding any parameter defaults
#
# ---
#
# [*sysconfig*]
# - Default - /etc/sysconfig/stackdriver
# - Stackdriver configuration file
#
class stackdriver::config::redhat(

  $sysconfig = '/etc/sysconfig/stackdriver',

) inherits stackdriver {

  validate_string ( $sysconfig )

  file { $sysconfig:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',  # secure API key
    content => template("stackdriver/${::kernel}/${sysconfig}.erb"),
    notify  => Service[$svc],
  }

  # Ensure the scripts directory exists.
  file { '/opt/stackdriver/collectd/etc/scripts/':
    ensure => 'directory',
    path   => '/opt/stackdriver/collectd/etc/scripts/',
    owner  => 'root',
    group  => 'root',
    mode   => '0644'
  }

  # Drop in the shell script which will be invoked by the collect 'exec' plugin.
  # Referenced from hiera.
  file { '/opt/stackdriver/collectd/etc/scripts/exec_custom.py':
    ensure => 'present',
    content => template('stackdriver/Linux/opt/stackdriver/collectd/etc/scripts/exec_custom.py.erb'),
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}

