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
#
define php::module::ini (
  $ensure       = undef,
  $pkgname      = false,
  $pkg_install  = true,                        # Install the module's package automatically?
  $prefix       = undef,
  $settings     = {},
  $zend         = false,
  $section      = undef,                       # The [section] header to create in the INI file.
  $php_conf_dir = $php::params::php_conf_dir,  # Allow custom INI configuration directory.
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
      /^php/  => $pkgname,
      false   => "${::php::params::php_package_name}-${title}",
      default => "${::php::params::php_package_name}-${pkgname}",
    }
  }

  # INI configuration file
  if $prefix {
    $inifile = "${php_conf_dir}/${prefix}-${modname}.ini"
  } else {
    $inifile = "${php_conf_dir}/${modname}.ini"
  }
  if $ensure == 'absent' {
    file { $inifile:
      ensure => absent,
    }
  } else {
    file { $inifile:
      ensure  => $ensure,
      content => template('php/module.ini.erb'),
    }

    # This allows the module to manage the INI file but not necessarially install
    # the package automatically.  This is useful if the module is custom compiled
    # and you don't want to manage the package via Puppet.
    if $pkg_install == true {
      File[$inifile] { require => Package[$ospkgname],}
    }


  }

  # Reload FPM if present
  if defined(Class['::php::fpm::daemon']) and $::php::fpm::daemon::ensure == 'present' {
    File[$inifile] ~> Service[$php::params::fpm_service_name]
  }

}
