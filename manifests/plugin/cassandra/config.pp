# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# == Class: stackdriver::plugin::cassandra::config
#
# Configures Cassandra Plugin for Stackdriver Agent
#
class stackdriver::plugin::cassandra::config inherits stackdriver::plugin::cassandra {

  file { $config:
    ensure  => file,
    content => template("stackdriver/${::kernel}/${config}.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    notify  => Service[$::stackdriver::svc],
  }

}

