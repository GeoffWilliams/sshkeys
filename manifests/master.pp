class sshkeys::master(
    $key_hash,
    $key_dir = $sshkeys::params::key_dir,
) inherits sshkeys::params {

  file { $key_dir:
    ensure => directory,
    owner  => "root",
    group  => "root",
    mode   => "0700",
  }

  create_resources("sshkeys::ssh_keygen",$key_hash)
  
}
