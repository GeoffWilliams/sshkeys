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