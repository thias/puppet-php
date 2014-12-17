class php::params {
  case $::osfamily {
    'Debian': {
      $php_package_name = 'php5'
      $php_apc_package_suffix = '-apc'
      $php_conf_dir = '/etc/php5/conf.d'
      $fpm_package_name = 'php5-fpm'
      $fpm_service_name = 'php5-fpm'
      $fpm_pool_dir = '/etc/php5/fpm/pool.d'
      $fpm_conf_dir = '/etc/php5/fpm'
      $fpm_error_log = '/var/log/php5-fpm.log'
      $fpm_pid = '/var/run/php5-fpm.pid'
      $httpd_package_name = 'apache2'
      $httpd_service_name = 'apache2'
      $httpd_conf_dir = '/etc/apache2/conf.d'
    }
    default: {
      $php_package_name = 'php'
      $php_apc_package_suffix = '-pecl-apc'
      $php_conf_dir = '/etc/php.d'
      $fpm_package_name = 'php-fpm'
      $fpm_service_name = 'php-fpm'
      $fpm_pool_dir = '/etc/php-fpm.d'
      $fpm_conf_dir = '/etc'
      $fpm_error_log = '/var/log/php-fpm/error.log'
      $fpm_pid = '/var/run/php-fpm/php-fpm.pid'
      $httpd_package_name = 'httpd'
      $httpd_service_name = 'httpd'
      $httpd_conf_dir = '/etc/httpd/conf.d'
    }
  }

  $common_package_suffix = '-common'
  $cli_package_suffix = '-cli'
}
