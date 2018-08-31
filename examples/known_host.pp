# @PDQTest
user { "frank":
  ensure => present,
}

file { ["/home/frank", "/home/frank/.ssh"]:
  ensure => directory,
  owner  => "frank",
  group  => "frank",
  mode   => "0700",
}

sshkeys::known_host{"frank@localhost":}