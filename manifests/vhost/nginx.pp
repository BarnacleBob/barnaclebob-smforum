# == Class smforum::vhost::nginx
#
# This class is called from smforum for nginx vhost setup.
#
class smforum::vhost::nginx {
  include '::nginx'

  if $::smforum::include_php {
    include '::php'
    include '::php::fpm'
    include '::php::extension::apc'
  }

  $http_redirect = $::smforum::vhost_ssl_only ? {
    true    => { 'rewrite' => '^ https://$servername$request_uri? permanent' }
    default => undef,
  }

  if $::smforum::vhost_ssl_only {
    nginx::resource::vhost { $::smforum::vhost_fqdn:
      ensure                => present,
      www_root              => $::smforum::documentroot,
      index_files           => [ 'index.php' ],
      location_cfg_append   => $http_redirect,
    }
  }

  if $::smforum::vhost_ssl or $::smforum::vhost_ssl_only {
    nginx::resource::vhost { $::smforum::vhost_fqdn:
      ensure                => present,
      listen_port           => 443,
      www_root              => $::smforum::documentroot,
      index_files           => [ 'index.php' ],
      ssl                   => true,
      ssl_cert              => $::smforum::vhost_ssl_cert,
      ssl_key               => $::smforum::vhost_ssl_key,
    }
  }

  nginx::resource::location { "${::smforum::vhost_fqd}_root":
    ensure          => present,
    ssl             => true,
    ssl_only        => $::smforum_vhost_ssl_only,
    vhost           => $::smforum::vhost_fqdn,
    www_root        => $::smforum::documentroot,
    location        => '~ \.php$',
    index_files     => ['index.php', 'index.html', 'index.htm'],
    fastcgi         => $::smforum_vhost_nginx_fcgi,
    fastcgi_script  => undef,
    location_cfg_append => {
      fastcgi_connect_timeout => '3m',
      fastcgi_read_timeout    => '3m',
      fastcgi_send_timeout    => '3m'
    }
  }
}
