# Define: php::module::ini
#
# Configuration for optional PHP modules which are separately packaged.
# See also php::module for package installation.
#
# Sample Usage :
#  php::module::ini { 'xmlreader': pkgname => 'xml' }
#  php::module::ini { 'pecl-apc':
#      settings => {
#          'apc.enabled'      => '1',
#          'apc.shm_segments' => '1',
#          'apc.shm_size'     => '64',
#      }
#  }
#  php::module::ini { 'xmlwriter': ensure => absent }
#  php::module::ini { 'pecl-xdebug':
#      zend     => true,
#      settings => {
#          'xdebug.remote_enable' => '1',
#      }
#  }
define php::module::ini (
  $ensure   = undef,
  $pkgname  = false,
  $settings = {},
  $zend     = false,
) {

  include '::php::params'

  # Strip 'pecl-*' prefix is present, since .ini files don't have it
  $modname = regsubst($title , '^pecl-', '', 'G')

  # Handle naming issue of php-apc package on Debian
  if ($modname == 'apc' and $pkgname == false) {
    # Package name
    $ospkgname = $::php::params::php_apc_package_name
  } else {
    # Package name
    $ospkgname = $pkgname ? {
      /^php/  => "${pkgname}",
      false   => "${::php::params::php_package_name}-${title}",
      default => "${::php::params::php_package_name}-${pkgname}",
    }

  }

  # Extension directory where modules are located
  $zend_path = $zend ? {
    true    => $php::params::extension_dir,
    false   => '',
    default => $zend,
  }

  # INI configuration file
  if $ensure == 'absent' {
    file { "${::php::params::php_conf_dir}/${modname}.ini":
      ensure => absent,
    }
  } else {
    file { "${::php::params::php_conf_dir}/${modname}.ini":
      ensure  => $ensure,
      require => Package[$ospkgname],
      content => template('php/module.ini.erb'),
    }
  }
}

