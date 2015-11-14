# sshkeys
[![Build Status](https://travis-ci.org/GeoffWilliams/sshkeys.svg)](https://travis-ci.org/GeoffWilliams/sshkeys)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with sshkeys](#setup)
    * [What sshkeys affects](#what-sshkeys-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with sshkeys](#beginning-with-sshkeys)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Generates, distributes and authorises SSH keys

## Module Description

Handles SSH keys by generating them once on the Puppet Master and distributing them to other nodes as `file` resources using Puppet's `file()` function.  This avoids the need for exported resources and associated synchronisation problems.

Since SSH keys are stored on the master, this weakens security somewhat vs PKIs are intended to work.  This can be mitigated by applying the principle of least privilege to accounts that use keys in this way.  Also if your Puppet Master is compromised, its game over anyway...

## Setup

### What sshkeys affects

* Generate and stores SSH keys on the Puppet Master in `/etc/sshkeys`
* Install SSH public/private keypairs on nodes that require them
* Sets up known hosts at the user level
* Generates SSH public/private keypairs
* Manages SSH key access via `~/.ssh/authorized_keys`

### Setup Requirements

* Requires all SSH packages are already installed

## Usage

### Generating an SSH key on the Puppet Master
```puppet
sshkeys::ssh_keygen( "alice@mylaptop.localdomain":
    $ensure     = present,
)
```
Create a public/private SSH keypair under `/etc/sshkeys` on the Puppet Master using the `ssh-keygen` program. Title should be in the format `user`@`host` which is what the other components of the module expect to be able to find.

The above declaration would create two files:
* `/etc/sshkeys/alice@mylaptop.localdomain` (private key)
* `/etc/sshkeys/alice@mylaptop.localdomain.pub` (public key)

Node to apply this on:  The Puppet Master

### Generating all SSH keys on the Puppet Master at once
```puppet
# $key_hash = hiera(...)
$key_hash = {
  "alice@mylaptop.localdomain" => {},
}

class { "sshkeys::master":
  key_hash => $key_hash
}
```

If you like, you can use the convenience wrapper `sskeys::master` to create all of the keys you need on the Puppet Master at once based on the value of a passed in hash.  This is ideal if you have a list of users in hiera that you wish to use.

The `sshkeys::master` class will ensure that the `/etc/sshkeys` directory exists with the correct permissions and will then use `create_resources()` to generate any required SSH keys based on the contents of `key_hash`.

Node to apply this on:  The Puppet Master

### Installing a public/private SSH keypair onto a node
```puppet
sshkeys::install_keypair { "alice@mylaptop.localdomain": }
```
Once an SSH keypair has been generated on the Puppet Master, it can be distributed to user(s).

This example would copy the files:
* `/etc/sshkeys/alice@mylaptop.localdomain` (private key)
* `/etc/sshkeys/alice@mylaptop.localdomain.pub` (public key)

To the local `alice` user's `~/.ssh` directory, creating it if it doesn't already exist.  The local user and host name are derived from the title.

Node to apply this on:  The node you wish to be able to SSH *FROM*

### Add an entry to known hosts
```puppet
sshkeys::known_host( "alice@ftp.localdomain": }
```

Retrieve the host keys for `ftp.localdomain` and install them into the `/home/alice/.ssh/known_hosts`.  The local user and host name are derived from the title.

Node to apply this on:  The node you wish to be able to SSH *FROM*

### Granting access to an account
``` puppet
sshkeys::authorize { "ftp":
  authorized_keys => [
    "alice@mylaptop.localdomain"
  ],
}
```
Once keys have been generated, distributed and hosts keys added to `authorized_hosts`, the last step to grant SSH access is to authorise a given key to access a local system account.

This example sources an SSH public key from the Puppet Master at `/etc/sshkeys/alice@mylaptop.localdomain.pub` and adds it to the `authorized_keys` file for the local `ftp` user.

Since the `authorized_keys` file is generated in one go, we need to specify all keys that should be authorised at the same time, which we can do by passing an array of key names.

Node to apply this on:  The node you wish to be able to SSH *TO*

## Reference
* `sshkeys` - Dummy class to get `sshkeys::params` in scope.  You may need to include this before using the defined resource types
* `sshkeys::authorize` - Add keys from Puppet Master to authorized hosts
* `sshkeys::install_keypair` - Copy keys from Puppet Master to local user account
* `sshkeys::ssh_keygen` - Generate an SSH public/private keypair on the Puppet Master
* `sshkeys::known_host` - Add the SSH host keys to a local user's `authorized_keys` file
* `sshkeys::params` - Externalised variables (params pattern)

## Limitations

Only tested on Debian and Ubuntu so far but should work on other Unix OSs with little or no modification

## Development

PRs accepted
