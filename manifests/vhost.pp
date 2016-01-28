# == Class smforum::vhost
#
# This class is called from smforum for vhost setup.
#
class smforum::vhost {
  case $::smforum::vhost_type {
    'nginx': {
      $_vhost_class = '::smforum::vhost::nginx'
    }
    default: {
      fail(" not supported")
    }
  }
  if $::smforum::manage_vhost {
    class { '::smforum::vhost::nginx': } -> Class['::smforum::vhost']
  }
}
