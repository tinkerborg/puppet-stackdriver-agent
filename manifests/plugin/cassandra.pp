# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# == Class: stackdriver::plugin::cassandra
#
# Enable Cassandra Plugin for Stackdriver Agent
#
# === Parameters
# ---
#
# [*conf*]
# - Default - /opt/stackdriver/collectd/etc/collectd.d/cassandra-22.conf
# - Plugin configuration file
#
# === Usage
# ---
#
# ==== Puppet Code
#
#  Enable Cassandra plugin via Puppet CODE:
#
#  include '::stackdriver::plugin::cassandra'
#
# ==== Hiera
#
#  Enable Redis plugin via Hiera:
#
#  stackdriver::plugins:
#   - 'cassandra'
#
class stackdriver::plugin::cassandra(

  $config   =  '/opt/stackdriver/collectd/etc/collectd.d/cassandra-22.conf',

) {

  Class['stackdriver'] -> Class[$name]

  validate_string ( $config )

  contain "${name}::config"

}

