# sshkeys::install_keypair
# ========================
# Download a public/private SSH keypair from the Puppet Master and copy them to
# the `~/.ssh` directory for the specified user.
#
# Parameters
# ==========
# [*source*]
#   File on the Puppet Master to source the private key from.  The filename of
#   the public key will be computed by appending `.pub` to this string.  This
#   is normally derived fully from the sshkeys::params class and the resource
#   title so is not normally needed
# [*user*]
#   The local system user to install the SSH keypair for
# [*ssh_dir*]
#   Override the default SSH directory of `/home/$user/.ssh`
define sshkeys::install_keypair(
    $source = "${sshkeys::params::key_dir}/${title}",
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
