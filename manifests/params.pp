# == Class smforum::params
#
# This class is meant to be called from smforum.
# It sets variables according to platform.
#
class smforum::params {
  $version = '2.0.11'
  $document_root = '/var/www'
  $owner = 'root'
  $group = 'root'

  $manage_mysql   = true
  $mysql_user     = 'smforum'
  $mysql_db       = 'smforum'
  $mysql_password = 'smforumpassword'

  $include_php    = true
  $php_fcgi = 'unix:/var/run/php5-fpm.sock'

  $manage_vhost   = true
  $vhost_fqdn     = $::fqdn
  $vhost_type     = 'nginx'
  $vhost_ssl      = false
  $vhost_ssl_only = false

  $www_user = 'nobody'
  $www_group = 'nobody'


  case $::osfamily {
    'Debian': {
      $package_name = 'smforum'
      $service_name = 'smforum'
    }
    'RedHat', 'Amazon': {
      $package_name = 'smforum'
      $service_name = 'smforum'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
