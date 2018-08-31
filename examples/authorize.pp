# @PDQTest
["gill", "helen"].each |$user| {
  user { $user:
    ensure => present,
  }
  file { "/home/${user}":
    ensure => directory,
    owner  => $user,
    group  => $user,
  }
}

sshkeys::authorize { "gill":
  authorized_keys => "gill@localhost",
}

sshkeys::authorize { "helen":
  authorized_keys => ["gill@localhost", "helen@localhost"],
}

