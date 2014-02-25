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
  $ensure  = $php::params::mod_php_ensure,
  $inifile = $php::params::mod_php_inifile,
  $php_package_name = $php::params::php_package_name,
  $httpd_conf_dir = $php::params::httpd_conf_dir,
  $httpd_package_name = $php::params:httpd_package_name,
  $httpd_service_name = $php::params:httpd_service_name,
  $manage_httpd_php_conf = $php::params:manage_httpd_php_conf,
  $notify_httpd_service = $php::params:mod_ini_notify_httpd,
) inherits ::php::params {

  package { $php_package_name:
    ensure  => $ensure,
    require => File[$inifile],
    notify  => Service[$httpd_service_name],
  }

  if($manage_httpd_php_conf == 'true') {
    # Custom httpd conf snippet
    file { "${httpd_conf_dir}/php.conf":
      content => template('php/httpd/php.conf.erb'),
      require => Package[$httpd_package_name],
      notify  => Service[$httpd_service_name],
    }
  }

  if($notify_httpd_service == 'true') {
    # Notify the httpd service for any php.ini changes too
    File[$inifile] ~> Service[$httpd_service_name]
  }

}

