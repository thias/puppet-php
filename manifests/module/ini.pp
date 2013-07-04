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
  $pkgname  = false,
  $settings = {},
  $zend     = false,
  $ensure   = undef
) {

  # Strip 'pecl-*' prefix is present, since .ini files don't have it
  $modname = regsubst($title , '^pecl-', '', G)

  # Package name
  $rpmpkgname = $pkgname ? {
    false   => "php-${title}",
    default => "php-${pkgname}",
  }

  # Extension directory where modules are located
  $zend_path = $zend ? {
    true    => $php::params::extension_dir,
    false   => '',
    default => $zend,
  }

  # INI configuration file
  file { "/etc/php.d/${modname}.ini":
    ensure  => $ensure,
    require => Package[$rpmpkgname],
    content => template('php/module.ini.erb'),
  }
}

