sshkeys { "/tmp/foo":
  ensure => present,
}

sshkeys { "/tmp/foobar":
  ensure  => present,
  comment => "hello world",
}

sshkeys { "/tmp/foobarbaz":
  ensure => present,
  user   => "geoff",
}

sshkeys { "/tmp/xyz":
  ensure => absent,
} 
