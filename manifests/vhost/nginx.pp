# == Class smforum::vhost::nginx
#
# This class is called from smforum for nginx vhost setup.
#
class smforum::vhost::nginx(
  $type,
  $vhost_fqdn,
  $ssl,
  $ssl_only,
  $ssl_cert,
  $ssl_key,
  $include_php,
  $php_fcgi,
  $document_root,
){
  include '::nginx'

  if $include_php {
    include '::php'
    include '::php::fpm'
    include '::php::extension::apc'
  }

  $redirect_rule = { 'rewrite' => '^ https://$server_name$request_uri? permanent' }

  $http_redirect = $ssl_only ? {
    true    => $redirect_rule,
    default => undef,
  }

#  nginx::resource::vhost { "${vhost_fqdn} http":
#    ensure              => present,
#    www_root            => $document_root,
#    location_cfg_append => $http_redirect,
#  }

  if $ssl {
    nginx::resource::vhost { "${vhost_fqdn} ssl":
      ensure      => present,
#      listen_port => 443,
      www_root    => $document_root,
      index_files => [ 'index.php' ],
      ssl         => true,
      ssl_cert    => $ssl_cert,
      ssl_key     => $ssl_key,
      use_default_location => false,
      rewrite_to_https => true,
    }
  }

#  nginx::resource::location { "${vhost_fqdn}_root":
#    ensure              => present,
#    ssl                 => true,
#    ssl_only            => $ssl_only,
#    vhost               => "${vhost_fqdn} ssl",
#    www_root            => $document_root,
#    location            => '~ \.php$',
#    index_files         => ['index.php', 'index.html', 'index.htm'],
#    fastcgi             => $php_fcgi,
#    fastcgi_script      => undef,
#    location_cfg_append => {
#      fastcgi_connect_timeout => '3m',
#      fastcgi_read_timeout    => '3m',
#      fastcgi_send_timeout    => '3m',
#    },
#  }
}
