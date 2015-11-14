require 'spec_helper'
#require 'fakefs/spec_helpers'
describe 'sshkeys::authorize', :type => :define do
#  include FakeFS::SpecHelpers
#FakeFS.activate!
  let :pre_condition do
    '
    $concat_basedir = "/tmp/concat"
    class { "sshkeys": }'
  end
 
  # mock the file function, adapted from
  # https://github.com/TomPoulton/rspec-puppet-unit-testing/blob/master/modules/foo/spec/classes/bar_spec.rb

  before(:each) do
    MockFunction.new('file') { |f|
      f.stubs(:call).returns('DEADBEEF')
    }
  end

  context "work ya bastard" do
    let :title do
      "ftp"
    end
    let :params do
      {
        :authorized_keys => "alice@mylaptop.localdomain",
      }
    end 
    it {
#      FakeFS.activate!
#      puts "BEFORExxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#      FileUtils.mkdir_p("/etc/sshkeys")
#      File.write("/etc/sshkeys/alice@mylaptop.localdomain.pub", "hello world")
      should compile 
#      FakeFS.deactivate!

      puts "afteryyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
    }
  end

end
