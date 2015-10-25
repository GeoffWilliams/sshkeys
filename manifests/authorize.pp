define sshkeys::authorize(
    $authorized_keys,
    $ensure      = present,
    $ssh_dir     = false,
) {

  include sshkeys::params

  if $ssh_dir {
    $_ssh_dir = $ssh_dir
  } else {
    $_ssh_dir = "/home/${title}/.ssh"
  }
  $authorized_keys_file = "${_ssh_dir}/authorized_keys"

  $key_dir = $sshkeys::params::key_dir

  if ! defined(File[$_ssh_dir]) {
    file { $_ssh_dir:
      ensure => directory,
    }
  }

  concat { $authorized_keys_file:
    owner => $title,
    group => $title,
    mode  => "0600",
  }

  $authorized_keys.each |$authorized_key| {
    if $authorized_key =~ /\w+@\w+/ {
      $split_title = split($authorized_key, "@")
      $host = $split_title[1]

      concat::fragment { "sshkeys::authorize__${title}__${authorized_key}":
        ensure  => $ensure,
        target  => $authorized_keys_file,
        content => file("${key_dir}/${authorized_key}.pub"),
      }

      sshkeys::known_host { "${title}@${host}":
        ssh_dir => $_ssh_dir,
      }
    } else {
      fail("requested key '${authorized_key}' is not in the correct format - should be user@host")
    }
  }

}
