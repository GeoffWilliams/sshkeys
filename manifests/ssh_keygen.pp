# sshkeys::ssh_keygen
# ===================
# Run ssh-keygen to generate SSH keys for storage on the Puppet Master
#
# Parameters
# ==========
# [*title*]
#   name of the key to generate, in user@host format
# [*ensure*]
#   state that this resource should be in.  Allowable values are `present` and 
#   `absent`
# [*comment*]
#   optional comment to embed in the key file.  Default: none
# [*passphrase*]
#   optional passphrase to secure the private key with.  Defaults to 
#   passwordless access
# [*type*]
#   override the default SSH key type to generate
# [*size*]
#   override the default SSH key size to generate
define sshkeys::ssh_keygen(
    $ensure     = present,
    $comment    = "",
    $passphrase = "",
    $type       = $sshkeys::params::type,
    $size       = $sshkeys::params::size,
) {
  include sshkeys::params

  if ! ($title =~ /\w+@\w+/) {
    fail("requested key '${title}' is not in the correct format - should be user@host")
  }

  $key_dir = $sshkeys::params::key_dir
  $key_file = "${key_dir}/${title}"

  if $ensure == present {
    exec { "ssh-keygen_${key_file}":
      command => "/usr/bin/ssh-keygen -C '${comment}' -N '${passphrase}' -t ${type} -b ${size} -f ${key_file}",
      creates => $key_file,
    }

    # allow puppet master daemon to read generated file
    file { $key_file:
      ensure => present,
      owner  => "root",
      group  => "pe-puppet",
      mode   => "0640",
    }
  } else {
    file { [ $key_file, "${key_file}.pub" ]:
      ensure => absent,
    }
  }
}
