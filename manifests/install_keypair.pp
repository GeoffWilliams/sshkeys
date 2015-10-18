define sshkeys::install_keypair(
    $source = "${sshkeys::params::key_dir}/${name}",
    $user,
    $ssh_dir = "/home/${user}/.ssh",
) {

  File { 
    owner => $user,
    group => $user,
    mode  => "0600",
  }

  if ! defined(File[$ssh_dir]) {
    file { $ssh_dir:
      ensure => directory,
    }
  }

  # private key
  file { "${ssh_dir}/${name}":
    ensure  => file,
    content => file($source),
  }

  # public key
  file { "${ssh_dir}/${name}.pub":
    ensure  => file,
    content => file("${source}.pub"),
  }

}
