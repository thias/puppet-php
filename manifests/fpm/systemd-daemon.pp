# Class: php::fpm::systemd-daemon
#
# Install the PHP FPM daemon. See php::fpm::systemd-socket-conf for configuring its pools.
#
# Sample Usage:
#  include php::fpm::systemd-daemon
#
class php::fpm::systemd-daemon (
  $ensure                      = 'present',
  $package_name                = $::php::params::fpm_package_name,
  $fpm_pool_dir                = $::php::params::fpm_pool_dir,
  $fpm_conf_dir                = $::php::params::fpm_conf_dir,
  $owner                   = 'apache',
  $group                   = 'apache',
) inherits ::php::params {

  # Hack-ish to default to user for group too
  $group_final = $group ? {
    false   => $owner,
    default => $group,
  }

  package { $package_name: ensure => $ensure }

  if ( $ensure != 'absent' ) {
    file { "/var/run/php-fpm":
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0775',
    }

    # Create "/var/run/php-fpm/php-systemd/" as group-writable because the daemon does not start as root
    file { "/var/run/php-fpm/php-systemd/":
      ensure => 'directory',
      owner  => $owner,
      group  => $group_final,
      mode	 => '0775',
    }

  }

}

