# == Class: profile::php
#
class profile::php {

  include ::php::fpm

  php::fpm::conf { 'www':
    listen                    => '/run/php/php7.0-fpm.sock',
    listen_owner              => 'www-data',
    listen_group              => 'www-data',
    user                      => 'www-data',
    security_limit_extensions => '.php',
    require                   => [ Package['nginx'], File['/run/php'] ],
  }

  php::module { ['mcrypt', 'mysql', 'curl', 'gd', 'intl', 'tidy', 'json']: }

  supervisord::program { 'php':
    command => '/usr/sbin/php-fpm7.0',
  }

}
