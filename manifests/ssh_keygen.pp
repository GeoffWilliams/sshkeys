define sshkeys::ssh_keygen(
    $ensure     = present,
    $comment    = "",
    $passphrase = "",
    $type       = $sshkeys::params::type,
    $size       = $sshkeys::params::size,
) {
  include sshkeys::params
  $key_dir = $sshkeys::params::key_dir
  $key_file = "${key_dir}/${name}"

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
    file { [ $key_file, "${key_file.pub}" ]:
      ensure => absent,
    }
  }
}
