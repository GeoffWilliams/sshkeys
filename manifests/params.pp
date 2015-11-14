# sshkeys::params
# ===============
# Common variables for the module to use (params pattern)
class sshkeys::params {

  # directory on the puppet master to store SSH keys in
  $key_dir  = "/etc/sshkeys"

  # default type of key to generate
  $type     = "rsa"

  # default keysize to generate
  $size     = 2048
}
