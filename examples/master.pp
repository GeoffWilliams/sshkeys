class { "sshkeys::master":
  key_hash => {
    "rsync@${::fqdn}" => {},
  },
}
