define sshkeys::authorize(
    $key_names,
    $ensure      = present,
    $ssh_dir     = "/home/${name}/.ssh",
) {

  include sshkeys::params
  $authorized_keys = "${ssh_dir}/authorized_keys"
  $known_hosts     = "${ssh_dir}/known_hosts"

  $key_dir = $sshkeys::params::key_dir

  if ! defined(File[$ssh_dir]) {
    file { $ssh_dir:
      ensure => directory,
    }
  }

  concat { $authorized_keys:
    owner => $name,
    group => $name,
    mode  => "0600",
  }

  $key_names.each |$key_name| {
    $split_name = split($key_name, "@")
    $host = $split_name[1]

    concat::fragment { "sshkeys::authorize__${name}__${key_name}":
      ensure  => $ensure,
      target  => $authorized_keys,
      content => file("${key_dir}/${key_name}.pub"),
    }

    exec { "known_host_${host}":
      user    => $name,
      command => "/usr/bin/ssh-keyscan -H ${host} >> $known_hosts",
      unless  => "/usr/bin/ssh-keygen -F ${host}",
    }  
  }

}
