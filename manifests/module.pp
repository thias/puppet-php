# Define: php::module
#
# Manage optional PHP modules which are separately packaged.
# See also php::module:ini for optional configuration.
#
# Sample Usage :
#  php::module { [ 'ldap', 'mcrypt', 'xml' ]: }
#  php::module { 'odbc': ensure => absent }
#  php::module { 'pecl-apc': }
#
define php::module (
  $ensure = installed,
) {

  include '::php::params'

  # Manage naming issue of pecl installed packages on RHEL
  if ($title == 'apc') {
    $package = $::php::params::php_apc_package_name
  } 
  elsif ($title == 'memcache') {
    $package = $::php::params::php_memcache_package_name
  } 
  else {
    # Hack to get pkg prefixes to work, i.e. php56-mcrypt title
    $package = $title ? {
      /^php/  => $title,
      default => "${::php::params::php_package_name}-${title}"
    }
  }

  package { $package:
    ensure => $ensure,
  }

  # Reload FPM if present
  if defined(Class['::php::fpm::daemon']) and $::php::fpm::daemon::ensure == 'present' {
    Package[$package] ~> Service[$php::params::fpm_service_name]
  }

}

