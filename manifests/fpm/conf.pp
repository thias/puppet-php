# Define: php::fpm::conf
#
# PHP FPM pool configuration definition. Note that the original php-fpm package
# includes a pre-configured one called 'www' so you should either use that name
# in order to override it, or "ensure => absent" it.
#
# Sample Usage:
#  php::fpm::conf { 'www': ensure => absent }
#  php::fpm::conf { 'customer1':
#      listen => '127.0.0.1:9001',
#      user   => 'customer1',
#  }
#  php::fpm::conf { 'customer2':
#      listen => '127.0.0.1:9002',
#      user   => 'customer2',
#  }
#
define php::fpm::conf (
  $ensure                    = 'present',
  $user                      = 'apache',
  $group                     = undef,
  $listen                    = '127.0.0.1:9000',
  # Puppet does not allow dots in variable names
  $listen_backlog            = '-1',
  $listen_owner              = undef,
  $listen_group              = undef,
  $listen_mode               = undef,
  $listen_allowed_clients    = '127.0.0.1',
  $process_priority          = undef,
  $pm                        = 'dynamic',
  $pm_max_children           = '50',
  $pm_start_servers          = '5',
  $pm_min_spare_servers      = '5',
  $pm_max_spare_servers      = '35',
  $pm_process_idle_timeout   = undef,
  $pm_max_requests           = '0',
  $pm_status_path            = undef,
  $ping_path                 = undef,
  $ping_response             = 'pong',
  $slowlog                   = "/var/log/php-fpm/${name}-slow.log",
  $request_slowlog_timeout   = undef,
  $request_terminate_timeout = undef,
  $rlimit_files              = undef,
  $rlimit_core               = undef,
  $chroot                    = undef,
  $chdir                     = undef,
  $catch_workers_output      = 'no',
  $clear_env                 = undef,
  $security_limit_extensions = undef,
  $env                       = [],
  $env_value                 = {},
  $php_value                 = {},
  $php_flag                  = {},
  $php_admin_value           = {},
  $php_admin_flag            = {},
  $php_directives            = [],
  $error_log                 = true,
  $fpm_package_name          = false,
) {

  include '::php::params'

  $pool = $title

  # Hack-ish to default to user for group too
  $group_final = $group ? { undef => $user, default => $group }

  # Determine PHP FPM package name.
  $ospkgname = $fpm_package_name ? {
    false => "${::php::params::fpm_package_name}",
    default => "$fpm_package_name",
  }

  if ( $ensure == 'absent' ) {

    file { "${php::params::fpm_pool_dir}/${pool}.conf":
      notify  => Service[$php::params::fpm_service_name],
      ensure  => absent,
      require => Package[$ospkgname],
    }

  } else {

    file { "${php::params::fpm_pool_dir}/${pool}.conf":
      notify  => Service[$php::params::fpm_service_name],
      content => template('php/fpm/pool.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package[$ospkgname],
    }

  }

}

