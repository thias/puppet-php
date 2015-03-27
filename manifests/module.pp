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
    $package = $::php::params::php_apc_package_name
  } else {
    # Hack to get pkg prefixes to work, i.e. php56-mcrypt title
    $package = $title ? {
      /^php/  => $title,
      default => "${::php::params::php_package_name}-${title}"
    }
  }

  if $title == 'opcache' { 
    package { 'php5-opcache':
      name => 'php5',
    }
  } else {
    package { $package:
      ensure => $ensure,
    }
  }

  # Enable module in Ubuntu 14.04 LTS
  if $lsbdistcodename == 'trusty' {
    exec { "enable $title":
      unless  => "php5query -s apache2 -m $title",
      command => "php5enmod $title",
      path    => ['/bin', '/usr/bin', '/usr/sbin'],
      require => Package[$package],
    }
  }

}

