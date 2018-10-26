# @PDQTest

["alice", "bob", "ingrid", "james"].each |$user| {
  user { $user:
    ensure => present,
  }
  file { "/home/${user}":
    ensure => directory,
    owner  => $user,
    group  => $user,
  }
}

$id_rsa = @(END)
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAtICY0UIsZZd04ylf45e0E3tQkj5Tov4nvNnwLQE/BolEKh/7
qIeCU41xVsE5FRsF1NpN0/3nOPGU3yu25JdKkPdVPQrRGQOF/ncayMnZYia1zG9s
KYDY8tu2dEw+9hbA/NEmt5yLUYasNhNJI+cId8uF1n75b1Np7KxqfqZ6BLjpCbgG
AXDOt3s9iDfUYQ4NrZnHzSjsMxdtTv60Yfr+B9kh3BCbrV+Op8FedKC/sVEJfWBQ
HQaTFmWnOn8wFpqn3So3p3208v2wBcxj6dVKdYb3r2MAVGxXCvucnh8zhKacd9D/
58mPiwtm5tc5d/cU0C+IXf2agI9N51UyCArLuQIDAQABAoIBAAIsTiquxkQO17xo
YhwmVmepo2WvVGhw8N+ILCkOi8izXFu5eNklkH8bA9NMjjhf0+klG6zCsMbxuZ4a
M6B65c3q/F64w52uei1/F5Z1P6W725JzgPTa9UGvPXoW9OcXjQk+J14sh0za9zXL
c6T4AhUXISxc6PnbIjpUNRADRxLJderSDvY3jYAuPTRTKIeMTUG/2ylOEV4tQ/5I
IO6lyFw+GS2rh0NnMgjiDEdoGiMB8m/IlAefRB1an1pPxrhbHnJnRQMiQ9+7qA6h
HO2/iVYX7aQp0cqR3di386/y52KA1HoMLeJ52cVLcaKopzyuPA9HG8r8bQGEdris
uC4zBoECgYEA6khq5sNiuvPB3yh55j4WrAmhnYB3jGaOaAud84V9lEw5v1qNBq1r
+vUSVxw0e4GSna22sy+ow0EYaSqRLNTqb2mCsSO4Ed5Byhg94x1WSZBeVtpk/FjG
Fh34EfVkB1kz6pZq8NWn9wjugfNE8tLPagE9juAM2X+n9bUa5+/+2dECgYEAxTv0
nV5VjOAJYrvFcKpSSzxt+UDwGfXcWhgvXaYSqaTC8F7kSwt7tWqgYBmtoZiEhdsD
jKOeI/3x1uenmCQ275pbd3Vn3XwQppC0m8YuL2nHDSwfcyWdrrp2l/6FhzYV58fg
uix/nAe4qJF9i1KWt57ezvTyYPs8RqFf+VRUZWkCgYBS1BuHTlifhAJs5SCDuDvH
wvfyeTLK3o9GVaUYLX/CaFiaQGdPjwx4AyDiz0P2zk6JlJrdKuJddawtsjD1Sqk/
jmv4OIqhNpTH4F4w53RUOchAqKG/XZtawmmr37fnqS/jph5U2xSxD+VS6DDeMI3I
Cnw7ARdJ5gn5onfKvFy7oQKBgF634Uxlzi3eNYOt6y6lDOpGtgWakvPUp6K4tJ6D
r7i6gEeROo9zj1BbSXN9QW42YYYq3LSAquRcAvUSwOCGm79LYJuozV2HRDPJkIKy
lOF+KfKAewYATY5oy6VIvPVnGvP5gEnILuxOpPaHEESFQA4khJnc9j1uyc6dlwqU
3gbpAoGAQoVu11BrAUyaIXZuJJyoL7Sw5QbuwrZEe/yHEIOhvPUeezhVRHCL3LIn
OWROQxAUBu6S+7rCaIgv4rOBkZncvu4TXswpgPaVIRATFRqtcIW0D/1ofJgn1CIq
ky/wUT7EQoIY1RLyWowK/bcPDr+S8wXS9kdz+paEE33lldUTgZc=
-----END RSA PRIVATE KEY-----
END

$id_rsa_pub = @(END)
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0gJjRQixll3TjKV/jl7QTe1CSPlOi/ie82fAtAT8GiUQqH/uoh4JTjXFWwTkVGwXU2k3T/ec48ZTfK7bkl0qQ91U9CtEZA4X+dxrIydliJrXMb2wpgNjy27Z0TD72FsD80Sa3nItRhqw2E0kj5wh3y4XWfvlvU2nsrGp+pnoEuOkJuAYBcM63ez2IN9RhDg2tmcfNKOwzF21O/rRh+v4H2SHcEJutX46nwV50oL+xUQl9YFAdBpMWZac6fzAWmqfdKjenfbTy/bAFzGPp1Up1hvevYwBUbFcK+5yeHzOEppx30P/nyY+LC2bm1zl39xTQL4hd/ZqAj03nVTIICsu5 alice@test
END

$authorized_keys = @(END)
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDH8a7YinR6G1CCEx8azGZz/D8Ym0hSpqM5BTK0TwtcCfLeoX3v+3qPO755+RFWrT5Y0NXu/OdVS8sBcxfHqhepPf46FgeAoUAD7jEIs8CWCD0f1K0uQ3mZohbA9c9Fl/LVqTr3IYP9GujTPYyOn/Y5+bTyX/KP3YUNUTjqD12zy6pP+NIctauoBMR1RLetg+PbKN65iCPJtTyYDJD9t/INg7zIPhy3q4wBbO32N9hKM9fT6lIDXudLgdm+1F5bbCxNKubgw44/lSnFBnI65w/patrhzh9zo40oSrun4m0uripR/XaYnJOC02uJE8sW0B1AoZUTKaVRUBLiYSE0C4qH root@test
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpxG4f/rzweABu6S410C9jlFlb0V2dMk6H0MfvyHqqdAlInmXpKivb8wjcpysvXuIgd180zjXRDjHTlkgZcifLhIK4i12KDhmedRMz5sJU0oFAVaZHPrZbMZIJ80dcTbBFCE1Oi311R14QaKq/1EcX3MMaDWb6Lt1RiE9F/qbMWxunIFZV9Ok71I+l+ATuqT+kkuRuuYmpPAIu4ayeC6GA/HQYVRQ2cQtiLuBtnnULcXKiQ9IuM9v7Von1Ftwo1OJRdML8w3yeUcIjTJ0ufl6nMCNe4jl+YbONJvpClE+REv3g4Ng78ksd7ZHhOhkqkLB1wACKsV9FePgTtNq4sPqx bob@test
END

$known_hosts = @(END)
localhost ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCAB36jI2MJBMLLZkDdMyFrjvH+dUYcL+zGKpDsOTFfjAFeyejSxSoY1+ui1M6xAhP2h9lnIZT+k21CYsgO+GHo=
END

# setup alice and allow root user to access
sshkeys::manual { "alice":
  id_rsa          => $id_rsa,
  id_rsa_pub      => $id_rsa_pub,
  known_hosts     => $known_hosts,
  authorized_keys => $authorized_keys,
  group           => "alice",
  home            => "/home/alice",
}

# setup bob and allow root user to access
sshkeys::manual { "bob":
  id_rsa_file          => "/testcase/spec/mock/keys/bob/id_rsa",
  id_rsa_pub_file      => "/testcase/spec/mock/keys/bob/id_rsa.pub",
  known_hosts_file     => "/testcase/spec/mock/keys/known_hosts",
  authorized_keys_file => "/testcase/spec/mock/keys/bob/authorized_keys",
  group                => 1000,
}

# pre-existing keys should be deleted
sshkeys::manual { "ingrid":
  authorized_keys => "ingrid authorized keys",
  purge_unmanaged => true,
}

# pre-existing keys should be preserved
sshkeys::manual { "james":
  authorized_keys => "james authorized keys",
}