# Sshkeys::Manual
#
# Manually import a set of ssh keys for a given user.  File can be supplied
# inline as strings or via URIs suitable for the `source` attribute of the
# puppet `file` resource.  It is an error to specify both `content` and `source`
#
# @param user User to install keys for
# @param home Location of home directories.  All files will be created inside
#   `$home/$user`
# @param group Group that will own the installed keys
# @param id_rsa Content of the regular `id_rsa` (private key) file
# @param id_rsa Source of the regular `id_rsa` (private key) file.  This can
#   be any location understood by the puppet `file` resource
# @param id_rsa_pub Content of the regular `id_rsa.pub` (public key) file
# @param id_rsa_pub_file Source of the regular `id_rsa_pub` (public key) file.
#   This can be any location understood by the puppet `file` resource
# @param known_hosts Content of the regular `known_hosts` file
# @param known_hosts_file Source of the regular `known_hosts` file.  This can be
#   any location understood by the puppet `file` resource
# @param authorized_keys Content of the regular `authorized_keys` file
# @param authorized_keys_file Source of the regular `authorized_keys` file.
#   This can be any location understood by the puppet `file` resource
define sshkeys::manual(
  $user                 = $title,
  $home                 = "/home",
  $group                = undef,
  $id_rsa               = undef,
  $id_rsa_file          = undef,
  $id_rsa_pub           = undef,
  $id_rsa_pub_file      = undef,
  $known_hosts          = undef,
  $known_hosts_file     = undef,
  $authorized_keys      = undef,
  $authorized_keys_file = undef,
) {

  if $group {
    $_group = $group
  } else {
    $_group = $user
  }

  $id_rsa_present = pick($id_rsa, $id_rsa_file) ? {
    undef   => 'absent',
    default => 'present'
  }
  $id_rsa_pub_present = pick($id_rsa_pub, $id_rsa_pub_file) ? {
    undef   => 'absent',
    default => 'present'
  }
  $known_hosts_present = pick($known_hosts, $known_hosts_file) ? {
    undef   => 'absent',
    default => 'present'
  }
  $authorized_keys_present = pick($authorized_keys, $authorized_keys_file) ? {
    undef   => 'absent',
    default => 'present'
  }

  File {
    mode  => "0600",
    owner => $user,
    group => $_group,
  }

  file { "${home}/.ssh":
    ensure => directory,
  }


  file { "${home}/.ssh/id_rsa":
    ensure  => $id_rsa_present,
    content => $id_rsa,
    source  => $id_rsa_file,
  }

  file { "${home}/.ssh/id_rsa.pub":
    ensure  => $id_rsa_pub_present,
    content => $id_rsa_pub,
    source  => $id_rsa_pub_file,
  }

  file { "${home}/.ssh/authorized_keys":
    ensure  => $authorized_keys_present,
    content => $authorized_keys,
    source  => $authorized_keys_file,
  }

  file { "${home}/.ssh/known_hosts":
    ensure  => $known_hosts_present,
    content => $known_hosts,
    source  => $known_hosts_file,
  }
}
