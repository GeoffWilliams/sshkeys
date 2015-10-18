require "fileutils"
Puppet::Type.type(:sshkeys).provide(:sshkeys) do
  desc "ssh keys support"

  def self.instances
    resources = []
    resources
  end

  commands  :ssh_keygen => "ssh-keygen"

  def create
    ssh_keygen("-N", @resource[:passphrase], "-f", @resource[:name], "-C", @resource[:comment])
    FileUtils.chown(@resource[:user], nil, @resource[:name])
    FileUtils.chown(@resource[:user], nil, public_key_filename())
    FileUtils.chmod(0600, @resource[:name])
  end

  def exists?
    return (File.file?(@resource[:name]) and File.file?(public_key_filename()))
  end

  # delete public and private key
  def destroy
    FileUtils.rm(@resource[:name])
    FileUtils.rm(public_key_filename())
  end

  def public_key_filename
    return @resource[:name] + ".pub"
  end

  def public_key
    File.read(public_key_filename())
  end
end
