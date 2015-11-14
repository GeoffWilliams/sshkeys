# sshkeys::known_host
# ===================
# Add an entry to a local user's `authorized_keys` file
#
# Parameters
# ==========
# [*title*]
#   Specify the local system user and remote host to connect to in the format
#   user@host
# [*ssh_dir*]
#   Override the standard location of the SSH directory.  Defaults to 
#   /home/USER/ssh.  Note that user is specified in the title ONLY
define sshkeys::known_host(
  $ssh_dir = false,
) {

  if $title =~ /\w+@\w+/ {
    $split_name = split($title, "@")
    $user = $split_name[0]
    $host = $split_name[1]
    if $ssh_dir {
      $_ssh_dir = $ssh_dir
    } else {
      $_ssh_dir = "/home/${user}/.ssh"
    }
    $known_hosts          = "${_ssh_dir}/known_hosts"

    exec { "known_host_${user}_${host}":
      user    => $user,
      command => "ping -c 1 ${host} && ssh-keyscan -H ${host} >> ${known_hosts}",
      unless  => "ssh-keygen -F ${host}",
      path    => [
          "/bin/",
          "sbin",
          "/usr/bin",
      ],
    }
  } else {
      fail("title for sshkeys::known_host '${title}' is not in the correct format - should be local_user@remote_host")
  }

}
