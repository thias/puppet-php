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

  # Manage the incorrect named php-apc package under Debians
  if ($title == 'apc') {
    $package = "${::php::php_name}${::php::params::php_apc_package_suffix}"
  } else {
    # Hack to get pkg prefixes to work, i.e. php56-mcrypt title
    $package = $title ? {
      /^php/  => $title,
      default => "${::php::php_name}-${title}"
    }
  }

  package { $package:
    ensure => $ensure,
  }
}

