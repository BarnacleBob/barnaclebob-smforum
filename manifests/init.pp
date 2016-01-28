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
  $version      = $::smforum::params::version,
  $user         = $::smforum::params::user,
  $document_root = $::smforum::params::document_root,

  $manage_mysql = $::smforum::params::manage_mysql,
  $mysql_user   = $::smforum::params::mysql_user,
  $mysql_db     = $::smforum::params::mysql_db,

  $manage_vhost               = $::smforum::params::manage_vhost,
  $vhost_type                 = $::smforum::params::vhost_type,
  $vhost_fqdn                 = $::smforum::params::vhost_fqdn,
  $vhost_ssl                  = $::smforum::params::vhost_ssl,
  $vhost_ssl_only             = $::smforum::params::vhost_ssl_only,
  $vhost_ssl_cert     = undef,
  $vhost_ssl_key      = undef,
  $   = $::smforum::params::
  $   = $::smforum::params::
  $   = $::smforum::params::
) inherits ::smforum::params {

  case $vhost_type {
    'nginx': {
      $_vhost_class = '::smforum::vhost::nginx'
    }
    default: {
      fail("vhost type ${vhost_type} not supported")
    }
  }

  # validate parameters here
  #todo: validate

  if $vhost_ssl $vhost_ssl_only {
    if not $vhost_ssl_cert or not $vhost_ssl_key {
      fail("you must specify a ssl cert and key with use of a ssl vhost")
    }
  }

  class { '::smforum::install': } ->
  class { '::smforum::mysql': } ->
  class { '::smforum::vhost': } ->
  Class['::smforum']
}
