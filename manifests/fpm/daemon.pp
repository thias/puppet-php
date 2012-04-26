# Class: php::fpm::daemon
#
# Install the PHP FPM daemon. See php::fpm::conf for configuring its pools.
#
# Sample Usage:
#  include php::fpm::daemon
#
class php::fpm::daemon (
    $ensure = 'present',
    $log_level = 'notice',
    $emergency_restart_threshold = '0',
    $emergency_restart_interval = '0',
    $process_control_timeout = '0',
    $log_owner = 'root',
    $log_group = false
) {

    # Hack-ish to default to user for group too
    $log_group_final = $log_group ? {
        false   => $log_owner,
        default => $log_group,
    }

    if ( $ensure == 'absent' ) {

        package { 'php-fpm': ensure => absent }

    } else {

        package { 'php-fpm': ensure => installed }

        service { 'php-fpm':
            ensure    => running,
            enable    => true,
            restart   => '/sbin/service php-fpm reload',
            hasstatus => true,
            require   => Package['php-fpm'],
        }

        # When running FastCGI, we don't always use the same user
        file { '/var/log/php-fpm':
            owner   => $log_owner,
            group   => $log_group_final,
            require => Package['php-fpm'],
        }

        file { '/etc/php-fpm.conf':
            notify  => Service['php-fpm'],
            content => template('php/fpm/php-fpm.conf.erb'),
            owner   => 'root',
            group   => 'root',
            mode    => 0644,
        }

    }

}

