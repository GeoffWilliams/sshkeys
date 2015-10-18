include sshkeys::params
class { "sshkeys::master":
  key_hash => {
    "rsync@demo" => {},
  },
}
