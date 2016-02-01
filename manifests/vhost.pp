# == Class smforum::vhost
#
# This class is called from smforum for vhost setup.
#
class smforum::vhost(
  $manage,
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
  if $manage {
    case $type {
      'nginx': {
        class { '::smforum::vhost::nginx':
          type          => $type,
          vhost_fqdn    => $vhost_fqdn,
          ssl           => $ssl,
          ssl_only      => $ssl_only,
          ssl_cert      => $ssl_cert,
          ssl_key       => $ssl_key,
          include_php   => $include_php,
          php_fcgi      => $php_fcgi,
          document_root => $document_root,
        } -> Class['::smforum::vhost']
      }
      default: {
        fail("vhost type ${type} not supported")
      }
    }
  }
}
