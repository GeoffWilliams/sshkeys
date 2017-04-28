# Sshkeys::Manual
#
# Manually import a set of ssh keys for a given user
define sshkeys::manual(
  $user            = $title,
  $home            = "/home",
  $group           = undef,
  $id_rsa          = undef,
  $id_rsa_pub      = undef,
  $known_hosts     = undef,
  $authorized_keys = undef,
) {

  if $group {
    $_group = $group
  } else {
    $_group = $user
  }

  $id_rsa_present = $id_rsa ? {
    undef   => 'absent',
    default => 'present'
  }
  $id_rsa_pub_present = $id_rsa_pub ? {
    undef   => 'absent',
    default => 'present'
  }
  $known_hosts_present = $known_hosts ? {
    undef   => 'absent',
    default => 'present'
  }
  $authorized_keys_present = $authorized_keys ? {
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
  }

  file { "${home}/.ssh/id_rsa.pub":
    ensure  => $id_rsa_pub_present,
    content => $id_rsa_pub,
  }

  file { "${home}/.ssh/authorized_keys":
    ensure  => $authorized_keys_present,
    content => $authorized_keys,
  }

  file { "${home}/.ssh/known_hosts":
    ensure  => $known_hosts_present,
    content => $known_hosts,
  }
}
