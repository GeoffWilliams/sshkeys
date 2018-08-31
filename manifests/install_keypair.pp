# @summary Generate a public/private keypair on the Puppet Master and distribute to node
#
# We use a custom function `sshkeys::sshkey` to run `ssh-keygen` on the Puppet Master
# to generate the keys to download if they are missing. This allows us to install
# they keypairs without using exported resources etc. One obvious downside of this
# approach is that the private keys will exist on the master. This is an accepted risk
# if you want to use this approach.
#
# If you already have a set of keys you want to use, you could replace the files on
# the master yourself in the `/etc/puppetlabs/puppetserver/sshkeys` directory, or look
# at the `sshkeys::manual` type to copy known keys directly.
#
# You can also use this class to remove a keypair from a node. The files will remain on
# master until removed manually, however.
#
# @note Limitation: only one `user@host` combination can be defined per host. If you need
# to copy the same key multiple times, copy it once with this class and then come up
# with some other way to copy the remaining files.
#
# @example Creating default SSH keys
#   sshkeys::install_keypair { "charles@localhost":
#     default_files => true,
#   }
#   # Would create /home/charles/.ssh/id_rsa
#
# @example Creating SSH keys based on name
#   sshkeys::install_keypair { "diane@localhost": }
#   # Would create /home/diane/.ssh/diane@localhost
#
# @example Removing default SSH keys for `eve` user
#   sshkeys::install_keypair { "eve@localhost":
#     ensure        => absent,
#     default_files => true,
#   }
#   # Would delete `/home/eve/.ssh/id_rsa` and `/home/eve/.ssh/id_rsa.pub`
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
    Optional[String]          $ssh_dir          = undef,
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

  if $ensure == present {
    $private_key_content = sshkeys::sshkey($source)
    $public_key_content  = sshkeys::sshkey($source, true)
  } else {
    $private_key_content = undef
    $public_key_content  = undef
  }

  # private key
  file { $private_key_file:
    ensure  => $ensure,
    content => $private_key_content,
  }

  # public key
  file { $public_key_file:
    ensure  => $ensure,
    content => $public_key_content,
  }
}
