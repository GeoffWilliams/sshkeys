Puppet::Functions.create_function(:'sshkeys::sshkey') do

  def ensure_key(key_dir, key_name, passphrase, comment, type, size)
    if ! Dir.exists?(key_dir)
      Dir.mkdir(key_dir)
    end
    key_file = "#{key_dir}/#{key_name}"
    if ! File.exist?(key_file)
      cmd = "/usr/bin/ssh-keygen -C '#{comment}' -N '#{passphrase}' -t #{type} -b #{size} -f #{key_file}"
      system(cmd)
    end
    key_file
  end

  def sshkey(key_name, pub=false, passphrase='', comment='', type='rsa', size='2048')

    if pub 
      ext = '.pub'
    else
      ext = ''
    end
    key_dir = '/etc/puppetlabs/puppetserver/sshkeys'
    key_file = ensure_key(key_dir, key_name, passphrase, comment, type, size)
    File.read(key_file + ext)
  end

end
