# @PDQTest
["charles", "diane"].each |$user| {
  user { $user:
    ensure => present,
  }
  file { "/home/${user}":
    ensure => directory,
    owner  => $user,
    group  => $user,
  }
}

# replaces id_rsa
sshkeys::install_keypair { "charles@localhost":
  default_files => true,
}

# after generation, copy the key to root's authorized keys so we can test...
~> exec { "authorize key for charles":
  provider    => shell,
  command     => "cat /home/charles/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys",
  refreshonly => true,
  path        => "/bin",
}

# uses a custom filename
sshkeys::install_keypair { "diane@localhost": }

# after generation, copy the key to root's authorized keys so we can test...
~> exec { "authorize key for diane":
  provider    => shell,
  command     => "cat /home/diane/.ssh/diane@localhost.pub >> /root/.ssh/authorized_keys",
  refreshonly => true,
  path        => "/bin",
}

sshkeys::install_keypair { "eve@localhost":
  ensure        => absent,
  default_files => true,
}

sshkeys::install_keypair { "zoe@localhost":
  ensure        => absent,
  ssh_dir       => "/home/eve/.ssh",
}

