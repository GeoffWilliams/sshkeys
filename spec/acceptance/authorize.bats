@test "private key for gill created" {
    ls /etc/puppetlabs/puppetserver/sshkeys/gill@localhost
}

@test "public key for gill created" {
    ls /etc/puppetlabs/puppetserver/sshkeys/gill@localhost.pub
}

@test "private key for helen created" {
    ls /etc/puppetlabs/puppetserver/sshkeys/helen@localhost
}

@test "public key for helen created" {
    ls /etc/puppetlabs/puppetserver/sshkeys/helen@localhost.pub
}

@test "authorized_users for gill OK" {
    diff /etc/puppetlabs/puppetserver/sshkeys/gill@localhost.pub /home/gill/.ssh/authorized_keys
}

@test "authorized_users for helen OK" {
    cat /etc/puppetlabs/puppetserver/sshkeys/gill@localhost.pub /etc/puppetlabs/puppetserver/sshkeys/helen@localhost.pub > /tmp/helen_authorized_keys
    diff /tmp/helen_authorized_keys /home/helen/.ssh/authorized_keys
}
