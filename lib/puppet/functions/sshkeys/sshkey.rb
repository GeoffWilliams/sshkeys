# @summary Read an SSH Key from the _puppet master_, creating it if doesn't already exist
#
# Keys will be read/written from '/etc/puppetlabs/puppetserver/sshkeys'
Puppet::Functions.create_function(:'sshkeys::sshkey') do

  # internal function to create keys as required
  def ensure_key(key_dir, key_name, passphrase, comment, type, size)
    if ! Dir.exists?(key_dir)
      FileUtils.mkdir_p(key_dir)
    end

    # fix dir permissions if required
    if (File.stat(key_dir).mode & 07777) != 0700
      File.chmod(0700, key_dir)
    end

    key_file = "#{key_dir}/#{key_name}"
    if ! File.exist?(key_file)
      cmd = "/usr/bin/ssh-keygen -C '#{comment}' -N '#{passphrase}' -t #{type} -b #{size} -f #{key_file}"
      system(cmd)
    end
    key_file
  end

  # @param key_name Name of key to create in format `user@host`, eg `alice@localhost`
  # @param pub `true` if we are reading a public key, otherwise create a private key
  # @param passphrase Passphrase to use if need to create a key to read it (default is no passphrase)
  # @param comment Comment to set if we need to create a key
  # @param type Key type to create if we need to create a key
  # @param size Key size to create if we need to create a key
  # @return [String] Content of public or private key
  def sshkey(key_name, pub=false, passphrase='', comment='', type='rsa', size='2048')

    if pub
      ext = '.pub'
    else
      ext = ''
    end
    key_dir = '/etc/puppetlabs/puppetserver/sshkeys'
    key_file = ensure_key(key_dir, key_name, passphrase, comment, type, size)
    target = key_file + ext
    if File.exists?(target)
      result = File.read(key_file + ext)
    else
      result = nil
    end
    result
  end

end
