define sshkeys::install_keypair(
    $source = "${sshkeys::params::key_dir}/${name}",
    $user,
    $ssh_dir = false,
) {

  File { 
    owner => $user,
    group => $user,
    mode  => "0600",
  }

  if $ssh_dir {
    $_ssh_dir = $ssh_dir
  } else {
    $_ssh_dir = "/home/${user}/.ssh"
  }


  if ! defined(File[$_ssh_dir]) {
    file { $_ssh_dir:
      ensure => directory,
    }
  }


  # private key
  file { "${_ssh_dir}/${name}":
    ensure  => file,
    content => file($source),
  }

  # public key
  file { "${_ssh_dir}/${name}.pub":
    ensure  => file,
    content => file("${source}.pub"),
  }
}
