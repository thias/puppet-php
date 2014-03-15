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

  # Manage the incorrect named php-apc and memcache(d) packages under Debians
  if ($title == 'apc') {
    $package = $php::params::php_apc_package_name
  } elsif ($title == 'memcache') {
    # Package name
    $package = $php::params::php_memcache_package_name
  } elsif ($title == 'memcached') {
    # Package name
    $package = $php::params::php_memcached_package_name
  } else { 
    $package = "${php::params::php_package_name}-${title}"
  }
  
  package { $package:
    ensure => $ensure,
  }
}

