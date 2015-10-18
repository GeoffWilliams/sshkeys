# Run SSH keygen to create a local keypair
class ssh_keys::ssh_keygen(
    $user,
    $comment = ""
    $passphrase = ""
) {
  exec { "ssh-keygen -C ${comment} -N ${passphrase}"
    user => $user,
    creates => "
}
