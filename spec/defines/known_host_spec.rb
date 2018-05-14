require 'spec_helper'
describe 'sshkeys::known_host', :type => :define do

  context "compiles ok" do
    let :title do
      "alice@mylaptop.localdomain"
    end
    it { should compile }
  end

end
