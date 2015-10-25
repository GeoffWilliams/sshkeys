define sshkeys::authorized_keys(
  $ssh_dir = false,
) {

  if $ssh_dir {
    $_ssh_dir = $ssh_dir
  } else {
    $_ssh_dir = "/home/${name}/.ssh"
  }
  $known_hosts          = "${_ssh_dir}/known_hosts"

  if $title =~ /\w+@\w+/ {
   
    $split_name = split($title, "@")
    $user = $split_name[0]
    $host = $split_name[1]


    exec { "known_host_${user}_${host}":
      user    => $name,
      command => "/usr/bin/ssh-keyscan -H ${host} >> $known_hosts",
      unless  => "/usr/bin/ssh-keygen -F ${host}",
    }
  } else {
      fail("requested key '${authorized_key}' is not in the correct format - should be user@host")
  }

}
