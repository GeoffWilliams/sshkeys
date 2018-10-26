# Reference
<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

**Defined types**

* [`sshkeys::authorize`](#sshkeysauthorize): Setup `authorized_keys` file with keys read from the Puppet Master
* [`sshkeys::install_keypair`](#sshkeysinstall_keypair): Generate a public/private keypair on the Puppet Master and distribute to node
* [`sshkeys::known_host`](#sshkeysknown_host): Setup `known_hosts` file for a given user and host
* [`sshkeys::manual`](#sshkeysmanual): Distribute pre-generated SSH keys, `authorized_hosts` and `known_hosts`

**Functions**

* [`sshkeys::sshkey`](#sshkeyssshkey): Read an SSH Key from the _puppet master_, creating it if doesn't already exist

## Defined types

### sshkeys::authorize

Retrieve the keys listed in the authorized_keys parameter from the Puppet
Master and use them to write the authorized_keys file for the local unix user
specified in the title. If a key does not exist on the Puppet Master, it will
be created when read.

* **Note** replaces any existing `authorized_keys` file when used

#### Examples

##### Reading a single key and adding to `authorized keys`

```puppet
sshkeys::authorize { "gill":
  authorized_keys => "gill@localhost",
}
# creates /home/gill/.ssh/authorized_keys with the gil@localhost.pub file
# as its content
```

##### Reading multiple keys and adding to `authorized_keys`

```puppet
sshkeys::authorize { "helen":
  authorized_keys => ["gill@localhost", "helen@localhost"],
}
# creates /home/helen/.ssh/authorized_keys with the gil@localhost.pub and
# helen@localhost files concatentated as its content
```

#### Parameters

The following parameters are available in the `sshkeys::authorize` defined type.

##### `authorized_keys`

Data type: `Variant[String, Array[String]]`

Array of key names to source from the Puppet Master.  These will be used to
create the authorized_keys file

##### `user`

Data type: `String`

Local system account that this resource is granting access to via SSH.
Defaults to $title

Default value: $title

##### `ssh_dir`

Data type: `Optional[String]`

Override the default `.ssh` directory location.  Defaults to
`/home/$user/.ssh`

Default value: `undef`

### sshkeys::install_keypair

We use a custom function `sshkeys::sshkey` to run `ssh-keygen` on the Puppet Master
to generate the keys to download if they are missing. This allows us to install
they keypairs without using exported resources etc. One obvious downside of this
approach is that the private keys will exist on the master. This is an accepted risk
if you want to use this approach.

If you already have a set of keys you want to use, you could replace the files on
the master yourself in the `/etc/puppetlabs/puppetserver/sshkeys` directory, or look
at the `sshkeys::manual` type to copy known keys directly.

You can also use this class to remove a keypair from a node. The files will remain on
master until removed manually, however.

to copy the same key multiple times, copy it once with this class and then come up
with some other way to copy the remaining files.

* **Note** Limitation: only one `user@host` combination can be defined per host. If you need

#### Examples

##### Creating default SSH keys

```puppet
sshkeys::install_keypair { "charles@localhost":
  default_files => true,
}
# Would create /home/charles/.ssh/id_rsa
```

##### Creating SSH keys based on name

```puppet
sshkeys::install_keypair { "diane@localhost": }
# Would create /home/diane/.ssh/diane@localhost
```

##### Removing default SSH keys for `eve` user

```puppet
sshkeys::install_keypair { "eve@localhost":
  ensure        => absent,
  default_files => true,
}
# Would delete `/home/eve/.ssh/id_rsa` and `/home/eve/.ssh/id_rsa.pub`
```

#### Parameters

The following parameters are available in the `sshkeys::install_keypair` defined type.

##### `title`

identify the key to copy from the puppet master to the local machine. Must
be in the form `user@host`.  As well as specifying the keypair to copy from
the Puppet Master, the title also denotes the local system user to install
the keys for

##### `ensure`

Data type: `Enum['present', 'absent']`

Whether a keypair should be present or absent

Default value: present

##### `source`

Data type: `String`

File on the Puppet Master to source the private key from.  The filename of
the public key will be computed by appending `.pub` to this string.  This
is normally derived fully from the sshkeys::params class and the resource
title so is not normally needed

Default value: $title

##### `ssh_dir`

Data type: `Optional[String]`

Override the default SSH directory of `/home/$user/.ssh`

Default value: `undef`

##### `default_files`

Data type: `Boolean`

Write files to `id_rsa` and `id_rsa.pub`. This is useful if your only managing a single set of
keys. If not, leave this off and key files will be generated based on `title`. You can then use `ssh -i` to use the
key you want.

Default value: `false`

##### `default_filename`

Data type: `String`

Base filename to use when generating files with the default name.

Default value: "id_rsa"

### sshkeys::known_host

Test to see whether `ssh-keygen` thinks a particular host is in the `known_hosts` file. If
it isn't, obtain and store the key using `ssh-keyscan`.

#### Examples

##### 

```puppet
sshkeys::known_host{"frank@localhost":}
# `ssh-keyscan` on `localhost`, results saved to `/home/frank/.ssh/known_hosts`
```

#### Parameters

The following parameters are available in the `sshkeys::known_host` defined type.

##### `title`

Specify the local system user and remote host to connect to in the format
`user@host`

##### `ssh_dir`

Data type: `Optional[String]`

Override the standard location of the SSH directory.  Defaults to
/home/`user`/ssh.  Note that `user` is specified in `title` ONLY

Default value: `undef`

### sshkeys::manual

Manage the `~/.ssh` directory and any or all of:
  * `~/.ssh/id_rsa`
  * `~/.ssh/id_rsa.pub`
  * `~/.ssh/known_hosts`
  * `~/.ssh/authorized_keys`

For the given `user`, normally supplied in `title`.

Files can be supplied:
  * Inline - Write the supplied content directly to file (`file` resource
    `content`)
  * Filename - Write file using this URI (`file` resource `source`)

It is an error to specify both `content` and `source`. Where content is not
explicitly mananagd by this Puppet type, we will leave it alone and just fix
permissions unless the `purge_unmanaged` parameter is set `true`, in which
case any of the above files will be deleted if we were not supposed to set
content inside them.

#### Examples

##### Writing SSH connection settings by content

```puppet
sshkeys::manual { "alice":
  id_rsa          => $id_rsa,
  id_rsa_pub      => $id_rsa_pub,
  known_hosts     => $known_hosts,
  authorized_keys => $authorized_keys,
}
```

##### Writing SSH connection settings by file URI

```puppet
# You can use any URI supported by the puppet `file` resource `source` parameter...
sshkeys::manual { "bob":
  id_rsa_file          => "/testcase/spec/mock/keys/bob/id_rsa",
  id_rsa_pub_file      => "/testcase/spec/mock/keys/bob/id_rsa.pub",
  known_hosts_file     => "/testcase/spec/mock/keys/known_hosts",
  authorized_keys_file => "/testcase/spec/mock/keys/bob/authorized_keys",
}
```

##### Purge unmanaged SSH files

```puppet
# deletes Ingrid's `known_hosts`, `id_rsa`, `id_rsa.pub`) and sets content
# of `authorized_keys` file to the string `ingrid authorized keys`
sshkeys::manual { "ingrid":
  authorized_keys => "ingrid authorized keys",
  purge_unmanaged => true,
}
```

#### Parameters

The following parameters are available in the `sshkeys::manual` defined type.

##### `user`

Data type: `String`

User to install keys for

Default value: $title

##### `home`

Data type: `String`

Location of this user's home directory

Default value: "/home/${title}"

##### `group`

Data type: `Variant[Integer,String,Undef]`

Group that will own the installed keys

Default value: `undef`

##### `purge_unmanaged`

Data type: `Boolean`

Purge any unmanaged `id_rsa`, `id_rsa.pub`,
`known_hosts`, `authorized_keys` files

Default value: `false`

##### `id_rsa`

Data type: `Optional[String]`

Content of the regular `id_rsa` (private key) file

Default value: `undef`

##### `id_rsa_file`

Data type: `Optional[String]`

Source of the regular `id_rsa` (private key) file.  This can
be any location understood by the puppet `file` resource

Default value: `undef`

##### `id_rsa_pub`

Data type: `Optional[String]`

Content of the regular `id_rsa.pub` (public key) file

Default value: `undef`

##### `id_rsa_pub_file`

Data type: `Optional[String]`

Source of the regular `id_rsa_pub` (public key) file.
This can be any location understood by the puppet `file` resource

Default value: `undef`

##### `known_hosts`

Data type: `Optional[String]`

Content of the regular `known_hosts` file

Default value: `undef`

##### `known_hosts_file`

Data type: `Optional[String]`

Source of the regular `known_hosts` file.  This can be
any location understood by the puppet `file` resource

Default value: `undef`

##### `authorized_keys`

Data type: `Optional[String]`

Content of the regular `authorized_keys` file

Default value: `undef`

##### `authorized_keys_file`

Data type: `Optional[String]`

Source of the regular `authorized_keys` file.
This can be any location understood by the puppet `file` resource

Default value: `undef`

## Functions

### sshkeys::sshkey

Type: Ruby 4.x API

Keys will be read/written from '/etc/puppetlabs/puppetserver/sshkeys'

#### `sshkeys::sshkey(Any $key_name, Optional[Any] $pub = false, Optional[Any] $passphrase = '', Optional[Any] $comment = '', Optional[Any] $type = 'rsa', Optional[Any] $size = '2048')`

Keys will be read/written from '/etc/puppetlabs/puppetserver/sshkeys'

Returns: `String` Content of public or private key

##### `key_name`

Data type: `Any`

Name of key to create in format `user@host`, eg `alice@localhost`

##### `pub`

Data type: `Optional[Any]`

`true` if we are reading a public key, otherwise create a private key

##### `passphrase`

Data type: `Optional[Any]`

Passphrase to use if need to create a key to read it (default is no passphrase)

##### `comment`

Data type: `Optional[Any]`

Comment to set if we need to create a key

##### `type`

Data type: `Optional[Any]`

Key type to create if we need to create a key

##### `size`

Data type: `Optional[Any]`

Key size to create if we need to create a key
