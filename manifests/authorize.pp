define sshkeys::authorize(
    $authorized_keys,
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

  $authorized_keys.each |$authorized_key| {
    if $authorized_key =~ /\w+@\w+/ {
      $split_name = split($authorized_key, "@")
      $host = $split_name[1]

      concat::fragment { "sshkeys::authorize__${name}__${authorized_key}":
        ensure  => $ensure,
        target  => $authorized_keys,
        content => file("${key_dir}/${authorized_key}.pub"),
      }

      exec { "known_host_${host}":
        user    => $name,
        command => "/usr/bin/ssh-keyscan -H ${host} >> $known_hosts",
        unless  => "/usr/bin/ssh-keygen -F ${host}",
      }  
    } else {
      fail("requested key '${authorized_key}' is not in the correct format - should be user@host")
    }
  }

}
