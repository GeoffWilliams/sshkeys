# @summary Setup `authorized_keys` file with keys read from the Puppet Master
#
# Retrieve the keys listed in the authorized_keys parameter from the Puppet
# Master and use them to write the authorized_keys file for the local unix user
# specified in the title. If a key does not exist on the Puppet Master, it will
# be created when read.
#
# @note replaces any existing `authorized_keys` file when used
#
# @example Reading a single key and adding to `authorized keys`
#   sshkeys::authorize { "gill":
#     authorized_keys => "gill@localhost",
#   }
#   # creates /home/gill/.ssh/authorized_keys with the gil@localhost.pub file
#   # as its content
#
# @example Reading multiple keys and adding to `authorized_keys`
#   sshkeys::authorize { "helen":
#     authorized_keys => ["gill@localhost", "helen@localhost"],
#   }
#   # creates /home/helen/.ssh/authorized_keys with the gil@localhost.pub and
#   # helen@localhost files concatentated as its content
#
# @param authorized_keys Array of key names to source from the Puppet Master.  These will be used to
#   create the authorized_keys file
# @param user Local system account that this resource is granting access to via SSH.
#   Defaults to $title
# @param ssh_dir Override the default `.ssh` directory location.  Defaults to
#   `/home/$user/.ssh`
define sshkeys::authorize(
    Variant[String, Array[String]]  $authorized_keys,
    String                          $user             = $title,
    Optional[String]                $ssh_dir          = undef,
) {


  if $ssh_dir {
    $_ssh_dir = $ssh_dir
  } else {
    $_ssh_dir = "/home/${user}/.ssh"
  }
  $authorized_keys_file = "${_ssh_dir}/authorized_keys"

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
        target  => $authorized_keys_file,
        content => sshkeys::sshkey($authorized_key, true),
      }

    } else {
      fail("requested key '${authorized_key}' is not in the correct format - should be user@host")
    }
  }

}
