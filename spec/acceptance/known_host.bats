# because of the hashed output of ssh-keyscan, we won't always have the same content
# so just look for a marker to indicate success
@test "known_hosts correct content" {
    grep ssh-rsa /home/frank/.ssh/known_hosts
}