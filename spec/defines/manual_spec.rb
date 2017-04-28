require 'spec_helper'
describe 'sshkeys::manual', :type => :define do

  context "compiles ok" do
    let :title do
      "alice"
    end

    let :params do
      {
        :id_rsa          => "AAA",
        :id_rsa_pub      => "BBB",
        :known_hosts     => "CCC",
        :authorized_keys => "DDD",
      }
    end
    it { should compile }
  end

end
