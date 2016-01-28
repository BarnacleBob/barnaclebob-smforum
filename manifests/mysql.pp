# == Class smforum::install
#
# This class is called from smforum for install of mysql db.
#
class smforum::mysql() {
  include '::mysql::server'

  mysql::db { 'mydb':
    user     => $::smforum::mysql_user,
    password => $::smforum::mysql_db,
    host     => 'localhost',
    grant    => ['SELECT', 'UPDATE', 'INSERT', 'DELETE', 'CREATE', 'ALTER', 'DROP', 'INDEX'],
  }
}
