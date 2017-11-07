# Parameters class.
#
class php::params {
  case $::osfamily {
    'Debian': {
      case $::lsbdistcodename {
        wheezy, precise, jessie, trusty: {
          $php_package_name = 'php5'
          $php_apc_package_name = 'php-apc'
          $common_package_name = 'php5-common'
          $cli_package_name = 'php5-cli'
          $cli_inifile = '/etc/php5/cli/php.ini'
          $php_conf_dir = '/etc/php5/mods-available'
          $fpm_package_name = 'php5-fpm'
          $fpm_service_name = 'php5-fpm'
          $fpm_pool_dir = '/etc/php5/fpm/pool.d'
          $fpm_conf_dir = '/etc/php5/fpm'
          $fpm_error_log = '/var/log/php5-fpm.log'
          $fpm_pid = '/var/run/php5-fpm.pid'
          $fpm_service_restart = 'restart'
        }
        xenial, stretch: {
          $php_package_name = 'php'
          $php_apc_package_name = 'php-apcu'
          $common_package_name = 'php-common'
          $cli_package_name = 'php-cli'
          $cli_inifile = '/etc/php/7.0/cli/php.ini'
          $php_conf_dir = '/etc/php/7.0/mods-available'
          $fpm_package_name = 'php-fpm'
          $fpm_service_name = 'php7.0-fpm'
          $fpm_pool_dir = '/etc/php/7.0/fpm/pool.d'
          $fpm_conf_dir = '/etc/php/7.0/fpm'
          $fpm_error_log = '/var/log/php7.0-fpm.log'
          $fpm_pid = '/run/php/php7.0-fpm.pid'
          $fpm_service_restart = 'restart'
        }
        default: {
          fail("Unsupported lsbdistcodename: ${::lsbdistcodename}")
        }
      }
    }
    default: {
      $php_package_name = 'php'
      $php_apc_package_name = 'php-pecl-apc'
      $common_package_name = 'php-common'
      $cli_package_name = 'php-cli'
      $cli_inifile = '/etc/php.ini'
      $php_conf_dir = '/etc/php.d'
      $fpm_package_name = 'php-fpm'
      $fpm_service_name = 'php-fpm'
      $fpm_service_restart = 'reload'
      $fpm_pool_dir = '/etc/php-fpm.d'
      $fpm_conf_dir = '/etc'
      $fpm_error_log = '/var/log/php-fpm/error.log'
      $fpm_pid = '/var/run/php-fpm/php-fpm.pid'
    }
  }
}
