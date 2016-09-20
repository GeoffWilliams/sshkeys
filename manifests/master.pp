# sshkeys::master
# ===============
# Create the `/etc/sshkeys` directory and ensure that all requested keys have
# been generated
#
# Parameters
# ==========
# [*key_hash*]
#   Hash of keys to create in a format suitable for `create_resources()`
# [*key_dir*]
#   Override the default location on the Puppet Master for SSH keys.  Defaults
#   to `/etc/sshkeys`
class sshkeys::master(
    $key_hash,
    $key_dir = $sshkeys::params::key_dir,
) inherits sshkeys::params {

#  file { $key_dir:
#    ensure => directory,
#    owner  => "root",
#    group  => "pe-puppet",
#    mode   => "0750",
#  }
#
#  create_resources("sshkeys::ssh_keygen",$key_hash)
#  
}
