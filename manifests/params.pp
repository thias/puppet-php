class php::params {
  case $::osfamily {
    'Debian': {
      $common_package_name = 'php5-common'
      $cli_package_name = 'php5-cli'
      $fpm_package_name = 'php5-fpm'
      $fpm_service_name = 'php5-fpm'
      $fpm_pool_dir = '/etc/php5/fpm/pool.d'
    }

    default: {
      $common_package_name = 'php-common'
      $cli_package_name = 'php-cli'
      $fpm_package_name = 'php-fpm'
      $fpm_service_name = 'php-fpm'
      $fpm_pool_dir = '/etc/php-fpm.d'
    }
  }
}
