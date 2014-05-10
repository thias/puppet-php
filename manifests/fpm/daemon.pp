# Class: php::fpm::daemon
#
# Install the PHP FPM daemon. See php::fpm::conf for configuring its pools.
#
# Sample Usage:
#  include php::fpm::daemon
#
class php::fpm::daemon (
  $ensure                      = 'present',
  $log_level                   = 'notice',
  $emergency_restart_threshold = '0',
  $emergency_restart_interval  = '0',
  $process_control_timeout     = '0',
  $process_max                 = undef,
  $process_priority            = undef,
  $log_owner                   = 'root',
  $log_group                   = false,
  $log_dir_mode                = '0770',
  ) {
  class { '::php::params' : }

  # Hack-ish to default to user for group too
  $log_group_final = $log_group ? {
    false   => $log_owner,
    default => $log_group,
  }

  package { $::php::params::fpm_package_name: ensure => $ensure }

  if ( $ensure != 'absent' ) {
    service { $::php::params::fpm_service_name:
      ensure    => running,
      enable    => true,
      restart   => "service ${::php::params::fpm_service_name} reload",
      hasstatus => true,
      require   => Package[$::php::params::fpm_package_name],
    }

    # When running FastCGI, we don't always use the same user
    file { '/var/log/php-fpm':
      ensure  => directory,
      owner   => $log_owner,
      group   => $log_group_final,
      mode    => $log_dir_mode,
      require => Package[$::php::params::fpm_package_name],
    }

    file { "${::php::params::fpm_conf_dir}/php-fpm.conf":
      notify  => Service[$::php::params::fpm_service_name],
      content => template('php/fpm/php-fpm.conf.erb'),
      require => Package[$::php::params::fpm_package_name],
    }
  }
}
