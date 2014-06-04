# fpm.pp - 2014-02-19 07:36
#
# Copyright (c) 2014 Paul Houghton <paul4hough@gmail.com>
#
class php::fpm(
  $wwwdir      = undef,
  $php_modules = undef,
  $appuser     = undef,
  $appgroup    = undef,
  $port        = undef,
  $vhost       = 'localhost',
  ) {

  include '::php::params'

  $directories = hiera('directories',{'www' => '/srv/www'})
  $groups      = hiera('groups',{'www' => {'RedHat'=>'nginx','Debian'=>'www-data'}})
  $ports       = hiera('ports',{'php-fpm' => '9000'})
  $users       = hiera('users', { 'git' => 'git', 'gitlab' => 'git','www' => {'RedHat'=>'nginx','Debian'=>'www-data'} })

  $basedir = $wwwdir ? {
    undef   => $directories['www'],
    default => $wwwdir,
  }
  $user = $appuser ? {
    undef   => $users['www'][$::osfamily],
    default => $appuser,
  }
  $group = $appgroup ? {
    undef   => $groups['www'][$::osfamily],
    default => $appgroup,
  }
  $pxyport = $port ? {
    undef   => $ports['php-fpm'],
    default => $port,
  }

  File {
    owner   => $user,
    group   => $group,
  }

  if $::osfamily == 'Debian' {
    php::ini { '/etc/php5/fpm/php.ini':
      display_errors  => 'On',
      short_open_tag  => 'Off',
      date_timezone   => 'America/Denver',
      require         => Package[$::php::params::fpm_package_name],
    }
  }
  if ! defined(Class['php::cli']) {
    class { 'php::cli' : }
  }
  class { 'php::fpm::daemon' : }

  php::fpm::conf { 'www' :
    listen  => "127.0.0.1:${pxyport}",
    user    => $user,
    group   => $group,
    require => User[$user],
  }
  if $php_modules {
    php::module { $php_modules : }
  }
  $php_base_dir = $::osfamily ? {
    'Debian'  => '/var/lib/php5',
    default   => '/var/lib/php',
  }
  file { [$php_base_dir, "${php_base_dir}/session"] :
    ensure  => 'directory',
    mode    => '0775',
    require => User[$user],
  }

  if $basedir {
    file { "${basedir}/phpinfo.php" :
      ensure  => 'file',
      content => "<?php phpinfo(); ?>\n",
      require => File[$basedir],
    }
  }
  if ! defined(Class['nginx']) and $basedir {
    class { 'nginx' : }
    ensure_resource('file',$basedir,{
      ensure  => 'directory',
      owner   => $user,
      group   => $group,
      mode    => '0775',
      require => Class['nginx'],
    })
    if $vhost {
      nginx::resource::vhost { $vhost :
        ensure   => 'present',
        www_root => $basedir,
      }
    }
  }

  if $vhost and $basedir {
    nginx::resource::location { 'php':
      ensure          => 'present',
      vhost           => $vhost,
      location        => '~ \.php$',
      www_root        => $basedir,
      index_files     => undef,
      proxy           => undef,
      fastcgi         => "127.0.0.1:${pxyport}",
    }

    if $::selinux == 'true' {
      ensure_resource('selboolean','httpd_can_network_connect',{
        value => 'on',
      })
      # odd, this came up w/ fedora 20 port != 9000
      ensure_resource('selboolean','nis_enabled',{
        value => 'on',
      })
    }
    nginx::resource::location { 'static files':
      ensure          => 'present',
      vhost           => $vhost,
      location        => '~ \.(css|gif|jpg|js|png|html)$',
      www_root        => $basedir,
      index_files     => ['index.php','index.html',],
      proxy           => undef,
    }
  }
}
