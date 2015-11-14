include sshkeys
user { "rsync":
  ensure => present,
}
file { "/home/rsync":
  ensure => directory,
  owner  => "rsync",
  group  => "rsync",
}
sshkeys::install_keypair { "rsync@${::fqdn}": }

