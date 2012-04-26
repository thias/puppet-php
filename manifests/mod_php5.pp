# Class: php::mod_php5
#
# Apache httpd PHP module. Requires the 'httpd' service and package to be
# declared somewhere, usually from the apache_httpd module.
#
# Sample Usage :
#  php::ini { '/etc/php-httpd.ini': }
#  class { 'php::mod_php5': inifile => '/etc/php-httpd.ini' }
#
class php::mod_php5 ( $inifile = '/etc/php.ini' ) {
    package { 'php':
        ensure  => installed,
        require => File[$inifile],
        notify  => Service['httpd'],
    }
    # Custom httpd conf snippet
    file { '/etc/httpd/conf.d/php.conf':
        content => template('php/httpd/php.conf.erb'),
        require => Package['httpd'],
        notify  => Service['httpd'],
    }
    # Notify the httpd service for any php.ini changes too
    File[$inifile] ~> Service['httpd']
}

