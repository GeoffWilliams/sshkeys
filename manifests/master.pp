class sshkeys::master(
    $key_hash,
    $key_dir = $sshkeys::params::key_dir,
) inherits sshkeys::params {

  file { $key_dir:
    ensure => directory,
    owner  => "root",
    group  => "pe-puppet",
    mode   => "0750",
  }

  create_resources("sshkeys::ssh_keygen",$key_hash)
  
}
