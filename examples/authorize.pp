user { "rsync":
  ensure => present,
}
file { "/home/rsync":
  ensure => directory,
  owner  => "rsync",
  group  => "rsync",
}

sshkeys::authorize { "rsync":
  key_names => [ "rsync@demo"],
}
