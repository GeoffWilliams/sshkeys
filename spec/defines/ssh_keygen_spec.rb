require 'spec_helper'
describe 'sshkeys::ssh_keygen', :type => :define do
  let :pre_condition do
    'class { "sshkeys": }'
  end

  context "compiles ok" do
    let :title do
      "alice@mylaptop.localdomain"
    end
    it { should compile }
  end

end
