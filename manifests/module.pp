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
define php::module ( $ensure = installed ) {
  require php::params

  # Manage the incorrect named php-apc package under Debians
  if ($title == 'apc') {
    $package = $php::params::php_apc_package_name
  } else { 
    $package = "${php::params::php_package_name}-${title}"
  }
  
  package { $package:
    ensure => $ensure,
  }
}

