# sshkeys::authorize
# ==================
# Retrieve the keys listed in the authorized_keys parameter from the Puppet
# Master and add them to the authorized_keys file for the local unix user 
# specified in the title
#
# Parameters
# ==========
# [*authorized_keys*]
#   Array of key names to source from the Puppet Master.  These will be used to
#   create the authorized_keys file
# [*user*]
#   Local system account that this resource is granting access to via SSH.  
#   Defaults to $title
# [*ensure*]
#   The state that the authorized_keys file should be in.  Valid values are 
#   `present` and `absent`
# [*ssh_dir*]
#   Override the default `.ssh` directory location.  Defaults to 
#   `/home/$user/.ssh`
define sshkeys::authorize(
    $authorized_keys,
    $user     = $title,
    $ensure   = present,
    $ssh_dir  = false,
) {

  include sshkeys::params

  if $ssh_dir {
    $_ssh_dir = $ssh_dir
  } else {
    $_ssh_dir = "/home/${user}/.ssh"
  }
  $authorized_keys_file = "${_ssh_dir}/authorized_keys"

  $key_dir = $sshkeys::params::key_dir

  if ! defined(File[$_ssh_dir]) {
    file { $_ssh_dir:
      ensure => directory,
    }
  }

  concat { $authorized_keys_file:
    owner => $user,
    group => $user,
    mode  => "0600",
  }

  $_authorized_keys = any2array($authorized_keys)
  $_authorized_keys.each |$authorized_key| {
    if $authorized_key =~ /\w+@\w+/ {
      $split_title = split($authorized_key, "@")
      $host = $split_title[1]

      concat::fragment { "sshkeys::authorize__${user}__${authorized_key}":
        ensure  => $ensure,
        target  => $authorized_keys_file,
        content => file("${key_dir}/${authorized_key}.pub"),
      }

    } else {
      fail("requested key '${authorized_key}' is not in the correct format - should be user@host")
    }
  }

}
