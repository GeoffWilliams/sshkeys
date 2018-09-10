# @summary Distribute pre-generated SSH keys, `authorized_hosts` and `known_hosts`
#
# Manage the `~/.ssh` directory and any or all of:
#   * `~/.ssh/id_rsa`
#   * `~/.ssh/id_rsa.pub`
#   * `~/.ssh/known_hosts`
#   * `~/.ssh/authorized_keys`
#
# For the given `user`, normally supplied in `title`.
#
# Files can be supplied:
#   * Inline - Write the supplied content directly to file (`file` resource `content`)
#   * Filename - Write file using this URI (`file` resource `source`)
#
# It is an error to specify both `content` and `source`.
#
# @example Writing SSH connection settings by content
#   sshkeys::manual { "alice":
#     id_rsa          => $id_rsa,
#     id_rsa_pub      => $id_rsa_pub,
#     known_hosts     => $known_hosts,
#     authorized_keys => $authorized_keys,
#   }
#
# @example Writing SSH connection settings by file URI
#   # You can use any URI supported by the puppet `file` resource `source` parameter...
#   sshkeys::manual { "bob":
#     id_rsa_file          => "/testcase/spec/mock/keys/bob/id_rsa",
#     id_rsa_pub_file      => "/testcase/spec/mock/keys/bob/id_rsa.pub",
#     known_hosts_file     => "/testcase/spec/mock/keys/known_hosts",
#     authorized_keys_file => "/testcase/spec/mock/keys/bob/authorized_keys",
#   }
#
# @param user User to install keys for
# @param home Location of this user's home directory
# @param group Group that will own the installed keys
# @param id_rsa Content of the regular `id_rsa` (private key) file
# @param id_rsa_file Source of the regular `id_rsa` (private key) file.  This can
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
  String                        $user                 = $title,
  String                        $home                 = "/home/${title}",
  Variant[Integer,String,Undef] $group                = undef,
  Optional[String]              $id_rsa               = undef,
  Optional[String]              $id_rsa_file          = undef,
  Optional[String]              $id_rsa_pub           = undef,
  Optional[String]              $id_rsa_pub_file      = undef,
  Optional[String]              $known_hosts          = undef,
  Optional[String]              $known_hosts_file     = undef,
  Optional[String]              $authorized_keys      = undef,
  Optional[String]              $authorized_keys_file = undef,
) {

  if $group {
    $_group = $group
  } else {
    $_group = $user
  }

  $id_rsa_present = pick($id_rsa, $id_rsa_file, false) ? {
    false   => 'absent',
    default => 'file'
  }
  $id_rsa_pub_present = pick($id_rsa_pub, $id_rsa_pub_file, false) ? {
    false   => 'absent',
    default => 'file'
  }
  $known_hosts_present = pick($known_hosts, $known_hosts_file, false) ? {
    false   => 'absent',
    default => 'file'
  }
  $authorized_keys_present = pick($authorized_keys, $authorized_keys_file, false) ? {
    false   => 'absent',
    default => 'file'
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
