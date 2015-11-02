user { "rsync":
  ensure => present,
}
file { "/home/rsync":
  ensure => directory,
  owner  => "rsync",
  group  => "rsync",
}
host { "demo":
  ensure => present,
  ip     => "127.0.0.1",
}
sshkeys::authorize { "rsync":
  authorized_keys => [ "rsync@${::fqdn}"],
}


