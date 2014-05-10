# Class: php::mod_php5
#
# Apache httpd PHP module. Requires the 'httpd' service and package to be
# declared somewhere, usually from the apache_httpd module.
#
# Sample Usage :
#  php::ini { '/etc/php-httpd.ini': }
#  class { 'php::mod_php5': inifile => '/etc/php-httpd.ini' }
#
class php::mod_php5 (
  $ensure  = 'installed',
  $inifile = '/etc/php.ini',
  ) {
  class { '::php::params' : }
  package { $::php::params::php_package_name:
    ensure  => $ensure,
    require => File[$inifile],
    notify  => Service[$::php::params::httpd_service_name],
  }

  # Custom httpd conf snippet
  file { "${::php::params::httpd_conf_dir}/php.conf":
    content => template('php/httpd/php.conf.erb'),
    require => Package[$::php::params::httpd_package_name],
    notify  => Service[$::php::params::httpd_service_name],
  }

  # Notify the httpd service for any php.ini changes too
  File[$inifile] ~> Service[$::php::params::httpd_service_name]

}
