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

  file { '/usr/src/smforum':
    ensure => 'directory',
    mode   => '0755',
    owner  => $user,
    group  => $user,
  }

  archive { $archive_str:
    url        => "http://download.simplemachines.org/index.php/${archive_str}.tar.gz",
    target     => $document_root,
    user       => $user,
    checksum   => false,
    require    => File['/usr/src/smforum'],
    src_target => '/usr/src/smforum',
  }
}


#set file perms for rest should be root
#attachments
#avatars
#cache
#Packages
#Packages/installed.list
#Smileys
#Themes
#agreement.txt
#Settings.php
#Settings_bak.php
