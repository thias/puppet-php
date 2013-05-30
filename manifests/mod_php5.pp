# Class: php::mod_php5
#
# Apache httpd PHP module. Requires the 'httpd' service and package to be
# declared somewhere, usually from the apache_httpd module.
#
# Sample Usage :
#  php::ini { '/etc/php-httpd.ini': }
#  class { 'php::mod_php5': inifile => '/etc/php-httpd.ini' }
#
class php::mod_php5 ( $inifile = '/etc/php.ini' ) inherits php::params {
  package { $php_package_name:
    ensure  => installed,
    require => File[$inifile],
    notify  => Service[$httpd_service_name],
  }
  # Custom httpd conf snippet
  file { "${httpd_conf_dir}/php.conf":
    content => template('php/httpd/php.conf.erb'),
    require => Package[$httpd_package_name],
    notify  => Service[$httpd_service_name],
  }
  # Notify the httpd service for any php.ini changes too
  File[$inifile] ~> Service[$httpd_service_name]
}

