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
  $known_hosts          = "${_ssh_dir}/known_hosts"


  if ! defined(File[$_ssh_dir]) {
    file { $_ssh_dir:
      ensure => directory,
    }
  }

  if $name =~ /\w+@\w+/ {
    $split_name = split($authorized_key, "@")
    $host = $split_name[1]
  } else {
    fail("requested key '${name}' is not in the correct format - should be user@host")
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

  exec { "known_host_${user}_${host}":
    user    => $user,
    command => "/usr/bin/ssh-keyscan -H ${host} >> $known_hosts",
    unless  => "/usr/bin/ssh-keygen -F ${host}",
  }

}
