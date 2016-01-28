# == Class smforum::install
#
# This class is called from smforum for install.
#
class smforum::install() {
  $archive_version_str = regsubst($::smforum::version, '\.', '-', 'G')
  $archive_str = "smf_${archive_version_str}_install"

  archive { $archive_str:
    url    => "http://download.simplemachines.org/index.php/${archive_str}.tar.gz"
    target => $::smforum::document_root,
    user   => $::smforum::user,
  }
}
