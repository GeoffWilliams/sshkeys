@test "root can login to alice account" {
    ssh alice@localhost ls /
}

@test "root can login to bob account" {
    ssh alice@localhost ls /
}

@test "alice can login to bob account" {
    ssh -i /home/alice/.ssh/id_rsa bob@localhost ls /
}

@test "bob can login to alice account" {
    ssh -i /home/bob/.ssh/id_rsa alice@localhost ls /
}

@test "stale id_rsa file removed from ingrid" {
    ! ls /home/ingrid/.ssh/id_rsa
}

@test "stale id_rsa.pub file removed from ingrid" {
    ! ls /home/ingrid/.ssh/id_rsa.pub
}

@test "stale known_hosts file removed from ingrid" {
    ! ls /home/ingrid/.ssh/known_hosts
}

@test "preserve id_rsa file for james" {
    grep preserve /home/james/.ssh/id_rsa
}

@test "preserve id_rsa.pub file for james" {
    grep preserve /home/james/.ssh/id_rsa.pub
}

@test "preserve known_hosts file for james" {
    grep preserve /home/james/.ssh/known_hosts
}