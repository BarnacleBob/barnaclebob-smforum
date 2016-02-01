# Class: smforum
# ===========================
#
# Full description of class smforum here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class smforum (
  $version        = $::smforum::params::version,
  $user           = $::smforum::params::user,
  $document_root  = $::smforum::params::document_root,

  $manage_mysql   = $::smforum::params::manage_mysql,
  $mysql_user     = $::smforum::params::mysql_user,
  $mysql_db       = $::smforum::params::mysql_db,
  $mysql_password = $::smforum::params::mysql_password,

  $include_php    = $::smforum::params::include_php,
  $php_fcgi       = $::smforum::params::php_fcgi,

  $manage_vhost   = $::smforum::params::manage_vhost,
  $vhost_type     = $::smforum::params::vhost_type,
  $vhost_fqdn     = $::smforum::params::vhost_fqdn,
  $vhost_ssl      = $::smforum::params::vhost_ssl,
  $vhost_ssl_only = $::smforum::params::vhost_ssl_only,
  $vhost_ssl_cert = undef,
  $vhost_ssl_key  = undef,
) inherits ::smforum::params {

  validate_re($version, '[0-9]+\.[0-9]+\.[0-9]+')
  validate_bool($manage_mysql, $include_php, $manage_vhost, $vhost_ssl, $vhost_ssl_only)

  if $vhost_ssl {
    if !$vhost_ssl_cert or !$vhost_ssl_key {
      fail('you must set both a ssl key and cert file to enable ssl in vhost')
    }
  }

  if $vhost_ssl_only and !$vhost_ssl {
    fail('you cannot set a ssl only vhost with enabling ssl vhost')
  }

  class { '::smforum::install':
    version       => $version,
    document_root => $document_root,
    user          => $user,
  } ->
  class { '::smforum::vhost':
    manage        => $manage_vhost,
    type          => $vhost_type,
    vhost_fqdn    => $vhost_fqdn,
    ssl           => $vhost_ssl,
    ssl_only      => $vhost_ssl_only,
    ssl_cert      => $vhost_ssl_cert,
    ssl_key       => $vhost_ssl_key,
    include_php   => $include_php,
    php_fcgi      => $php_fcgi,
    document_root => $document_root,
  } ->
  Class['::smforum']

  if $manage_mysql {
    class { '::smforum::mysql':
      mysql_user     => $mysql_user,
      mysql_db       => $mysql_db,
      mysql_password => $mysql_password,
    } -> Class['::smforum']
  }
}
