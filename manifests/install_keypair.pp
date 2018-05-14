# sshkeys::install_keypair
#
# Download a public/private SSH keypair from the Puppet Master and copy them to
# the `~/.ssh` directory for the specified user.
#
# @param title identify the key to copy from the puppet master to the local machine. Must
#   be in the form `user@host`.  As well as specifying the keypair to copy from
#   the Puppet Master, the title also denotes the local system user to install
#   the keys for
# @param ensure Whether a keypair should be present or absent
# @param source File on the Puppet Master to source the private key from.  The filename of
#   the public key will be computed by appending `.pub` to this string.  This
#   is normally derived fully from the sshkeys::params class and the resource
#   title so is not normally needed
# @param ssh_dir Override the default SSH directory of `/home/$user/.ssh`
# @param default_files Write files to `id_rsa` and `id_rsa.pub`. This is useful if your only managing a single set of
#   keys. If not, leave this off and key files will be generated based on `title`. You can then use `ssh -i` to use the
#   key you want.
# @param default_filename Base filename to use when generating files with the default name.
define sshkeys::install_keypair(
    Enum['present', 'absent'] $ensure           = present,
    String                    $source           = $title,
    Variant[Boolean, String]  $ssh_dir          = false,
    Boolean                   $default_files    = false,
    String                    $default_filename = "id_rsa",
) {

  if $title =~ /\w+@\w+/ {
    $split_title = split($title, "@")
    $user = $split_title[0]
    $host = $split_title[1]

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
  } else {
    fail("requested key '${title}' is not in the correct format - should be user@host")
  }


  if ! defined(File[$_ssh_dir]) {
    file { $_ssh_dir:
      ensure => directory,
    }
  }

  if $default_files {
    $private_key_file = "${_ssh_dir}/${default_filename}"
    $public_key_file  = "${_ssh_dir}/${default_filename}.pub"
  } else {
    $private_key_file = "${_ssh_dir}/${name}"
    $public_key_file  = "${_ssh_dir}/${name}.pub"
  }

  # private key
  file { $private_key_file:
    ensure  => $ensure,
    content => sshkeys::sshkey($source),
  }

  # public key
  file { $public_key_file:
    ensure  => $ensure,
    content => sshkeys::sshkey($source, true),
  }
}
