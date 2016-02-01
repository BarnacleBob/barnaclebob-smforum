# == Class smforum::install
#
# This class is called from smforum for install of mysql db.
#
class smforum::mysql(
  $mysql_user,
  $mysql_db,
  $mysql_password
) {
  include '::mysql::server'

  mysql::db { $mysql_db:
    user     => $mysql_user,
    password => $mysql_password,
    host     => 'localhost',
    grant    => ['SELECT', 'UPDATE', 'INSERT', 'DELETE', 'CREATE', 'ALTER', 'DROP', 'INDEX'],
  }
}
