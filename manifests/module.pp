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
  $package_prefix = '',
) {

  include '::php::params'

  # Package prefix allows mixture of PHP packages with different
  # base names (e.g. php53u-pecl-apc and php-pear-Mail).
  if ($package_prefix == '') {
    # Default to php_package_name if no prefix is specified.
    $package_prefix = $php::params::php_package_name
  }

  # Manage the incorrect named php-apc package under Debians
  if ($title == 'apc') {
    $package = $php::params::php_apc_package_name
  } else {
    $package = "${package_prefix}-${title}"
  }

  package { $package:
    ensure => $ensure,
  }
}

