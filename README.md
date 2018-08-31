# sshkeys
[![Build Status](https://travis-ci.org/GeoffWilliams/sshkeys.svg)](https://travis-ci.org/GeoffWilliams/sshkeys)

#### Table of Contents

1. [Description](#description)
1. [Features](#features)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Overview

Provides several methods for generation, distribution and authorization of SSH keys

## Features
Per-user management of:
* `~/.ssh`
* `~/.ssh/id_rsa`
* `~/.ssh/id_rsa.pub`
* `~/.ssh/known_hosts`
* `~/.ssh/authorized_keys`
* `~/.ssh/some_other_key` (`sshkeys::install_keypair` only)
* `~/.ssh/some_other_key.pub` (`sshkeys::install_keypair` only)

## Usage
There are two methods of operation (consult REFERENCE for detailed instructions):

### Manual management
Create files with known data sourced from Puppet (Hiera, files from modules, etc):
* `sshkeys::manual`

Suggested uses:
* Distributing known keys for sysadmins
* Enabling logins from applications using a known key

### Generation
Generate files as needed (will be stored on the Puppet Master in `/etc/puppetlabs/puppetserver/sshkeys`):
* `sshkeys::authorize`
* `sshkeys::install_keypair`
* `sshkeys::known_host`

Suggested uses:
* SSH being used as a transport mechanism where the value of the key itself is
  immaterial and limited in scope, with all parties under puppet control. A
  good example of this would be rsync between puppet nodes and this is what the
  module was originally written for.
  
**Important**

Since SSH keys are stored on the master when using generation methods, this 
weakens security somewhat vs how PKIs are intended to work.  This can be 
mitigated by applying the principle of least privilege to accounts that use 
keys in this way.  Also if your Puppet Master is compromised, its game over 
anyway. Be sure your comfortable with this before using.

**Note**
SSH Keys are read from and generated on the Puppet Master using the 
`sshkeys::sshkey` function that ships with this module. When running
Puppet in apply mode, the user running the function will normally be `root`
however in agent mode the user would be `pe-puppet` or equivalent. This
prevents us creating files in `/etc` as `pe-puppet` has no ability to
write there. Instead, we create our own directory at 
`/etc/puppetlabs/puppetserver/sshkeys`. Since `/etc/puppetlabs/puppetserver`
is writable by `pe-puppet`, we are able to write files to this location.

### Setup Requirements

* Requires all SSH packages are already installed


## Limitations

* Tested on Debian and Ubuntu
* If generation is used, SSH keys will be stored on the master
* Only one copy of a given key can be installed per-node when using `sshkeys::install_keypair`

## Development

PRs accepted :)

## Testing
This module supports testing using [PDQTest](https://github.com/declarativesystems/pdqtest).


Test can be executed with:

```
bundle install
make
```

See `.travis.yml` for a working CI example
