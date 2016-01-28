# == Class smforum::service
#
# This class is meant to be called from smforum.
# It ensure the service is running.
#
class smforum::service {

  service { $::smforum::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
