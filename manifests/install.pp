# == Class smforum::install
#
# This class is called from smforum for install.
#
class smforum::install(
  $version,
  $document_root,
  $user,
) {
  $archive_version_str = regsubst($version, '\.', '-', 'G')
  $archive_str = "smf_${archive_version_str}_install"

  archive { $archive_str:
    url    => "http://download.simplemachines.org/index.php/${archive_str}.tar.gz",
    target => $document_root,
    user   => $user,
    checksum => false,
  }
}
