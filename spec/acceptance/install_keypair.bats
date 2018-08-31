@test "charles private key created on puppet master" {
    ls /etc/puppetlabs/puppetserver/sshkeys/charles@localhost
}

@test "charles public key created on puppet master" {
    ls /etc/puppetlabs/puppetserver/sshkeys/charles@localhost.pub
}

@test "charles can login to root account" {
    ssh -i /home/charles/.ssh/id_rsa root@localhost ls /
}

@test "diane can login to root account" {
    ssh -i /home/diane/.ssh/diane@localhost root@localhost ls /
}

@test "eve default private key removed" {
    ! ls /home/eve/.ssh/id_rsa
}

@test "eve default public key removed" {
    ! ls /home/eve/.ssh/id_rsa.pub
}

@test "eve alice private key removed" {
    ! ls /home/eve/.ssh/zoe@localhost
}

@test "eve alice public key removed" {
    ! ls /home/eve/.ssh/zoe@localhost.pub
}

@test "zoe private key never created" {
    ! ls /etc/puppetlabs/puppetserver/sshkeyszoe@localhost
}

@test "zoe public key never created" {
    ! ls /etc/puppetlabs/puppetserver/sshkeyszoe@localhost.pub
}

@test "secure permissions on /etc/puppetlabs/puppetserver/sshkeys" {
    [[ $(stat -c %a /etc/puppetlabs/puppetserver/sshkeys) == "700" ]]
}

@test "secure permissions on /etc/puppetlabs/puppetserver/sshkeys/charles@localhost private key" {
    [[ $(stat -c %a /etc/puppetlabs/puppetserver/sshkeys/charles@localhost) == "600" ]]
}

@test "secure permissions on /etc/puppetlabs/puppetserver/sshkeys/diane@localhost private key" {
    [[ $(stat -c %a /etc/puppetlabs/puppetserver/sshkeys/diane@localhost) == "600" ]]
}