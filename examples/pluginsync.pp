file { "/opt/puppetlabs/puppet/cache/lib":
  ensure  => directory,
  recurse => true,
  source  => 'puppet:///plugins',
  force   => true,
  purge   => true,
  backup  => false,
  noop    => false,
}

