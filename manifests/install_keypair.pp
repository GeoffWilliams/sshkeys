# sshkeys::install_keypair
# ========================
# Download a public/private SSH keypair from the Puppet Master and copy them to
# the `~/.ssh` directory for the specified user.
#
# Parameters
# ==========
# [*title*]
#   identify the key to copy from the puppet master to the local machine. Must
#   be in the form `user@host`.  As well as specifying the keypair to copy from
#   the Puppet Master, the title also denotes the local system user to install
#   the keys for
# [*source*]
#   File on the Puppet Master to source the private key from.  The filename of
#   the public key will be computed by appending `.pub` to this string.  This
#   is normally derived fully from the sshkeys::params class and the resource
#   title so is not normally needed
# [*ssh_dir*]
#   Override the default SSH directory of `/home/$user/.ssh`
define sshkeys::install_keypair(
    $source   = "${sshkeys::params::key_dir}/${title}",
    $ssh_dir  = false,
) {

  if $ssh_dir {
    $_ssh_dir = $ssh_dir
  } else {
    if $title =~ /\w+@\w+/ {
      $split_title = split($title, "@")
      $user = $split_title[0]
      $host = $split_title[1]

      File {
        owner => $user,
        group => $user,
        mode  => "0600",
      }

      $_ssh_dir = "/home/${user}/.ssh"
    } else {
      fail("requested key '${title}' is not in the correct format - should be user@host")
    }
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
