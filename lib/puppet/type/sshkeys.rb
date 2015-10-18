# generate an ssh key and export back to puppetdb via the state of the resource
# the public key of this keypair
Puppet::Type.newtype(:sshkeys) do
  @doc = "Manage an ssh keypair"

  ensurable do
    desc "Create or remove a keypair"
    defaultvalues
    defaultto(:present)
  end

  # this gets exported to puppetdb
  newproperty(:public_key) do
    desc "The contents of the public key"
  end

  newproperty(:public_key_filename) do
    desc "The filename of the public key"
  end

  newparam(:comment) do
    desc "Key comment"
    defaultto ""
  end

  newparam(:name) do
    desc "The filename of the private key to create"
  end

  newparam(:user) do
    desc "The user who should own the generated keyfiles"
    defaultto "root"
  end

  newparam(:passphrase) do
    desc "Passphrase to set for this keypair.  Only used on initial creation!"
    defaultto ""
  end

  # require any parent directory be created first
  autorequire :file do
    [ File.dirname(self[:name]) ]
  end
end
