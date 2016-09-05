# Define: php::fpm::systemd-socket-conf
#
# PHP FPM pool configuration definition. Note that the original php-fpm package
# includes a pre-configured one called 'www' so you should either use that name
# in order to override it, or "ensure => absent" it.
#
# Sample Usage:
#  php::fpm::systemd-socket-conf { 'www': ensure => absent }
#  php::fpm::systemd-socket-conf { 'customer1':
#      listen      => '/var/run/php-fpm/customer1.socket',
#      listen_port => 9001,
#      user        => 'customer1',
#  }
#  php::fpm::systemd-socket-conf { 'customer2':
#      listen      => '/var/run/php-fpm/customer1.socket',
#      listen_port => 9002,
#      user        => 'customer2',
#  }
#
define php::fpm::systemd-socket-conf (
  $ensure                    = 'present',
  $package_name              = undef,
  $service_name              = undef,
  $user                      = 'apache',
  $group                     = undef,
  $listen                    = undef,
  $listen_address            = '127.0.0.1',
  $listen_port               = '9000',
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
  $security_limit_extensions = undef,
  $env                       = [],
  $env_value                 = {},
  $php_value                 = {},
  $php_flag                  = {},
  $php_admin_value           = {},
  $php_admin_flag            = {},
  $php_directives            = [],
  $error_log                 = true,
) {

  include '::php::params'

  $pool = $title

  # Hack-ish to default to user for group too
  $group_final = $group ? { undef => $user, default => $group }

  # This is much easier from classes which inherit params...
  $fpm_package_name = $package_name ? {
    undef   => $::php::params::fpm_package_name,
    default => $package_name,
  }

  # Create systemd socket
  file { "/usr/lib/systemd/system/php-fpm-${pool}.socket":
    ensure  => $ensure,
    content => template('php/fpm/pool.socket.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    #require => Package[$fpm_package_name],
  }

  $socket_service_name = "php-fpm-${pool}.socket"

  service { $socket_service_name:
    ensure    => running,
    enable    => true,
    subscribe => File["/usr/lib/systemd/system/php-fpm-${pool}.socket"],
    require   => File["/usr/lib/systemd/system/php-fpm-${pool}.service"],
  }

  # Create per-pool service

  # Create "/var/run/php-fpm/php-systemd/" writable by $user because the daemon does not start as root
  file { "/var/run/php-fpm/php-systemd/":
    ensure => 'directory',
    owner  => $user,
    group  => $group,
  }

  $systemd_service_name = "php-fpm-${pool}.service"
  file { "/usr/lib/systemd/system/php-fpm-${pool}.service":
    ensure  => $ensure,
    content => template('php/fpm/pool.service.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    #require => Package[$fpm_package_name],
  }

  service { $systemd_service_name:
    enable    => true,
    subscribe => Service[$socket_service_name],
    require   => File["/usr/lib/systemd/system/php-fpm-${pool}.service"],
  }

  file { "${php::params::fpm_pool_dir}/${pool}.conf":
    ensure  => $ensure,
    content => template('php/fpm/pool-systemd.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    #require => Package[$fpm_package_name],
    notify  => Service[$systemd_service_name],
  }

}

