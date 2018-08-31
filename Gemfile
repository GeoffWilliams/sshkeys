source ENV['GEM_SOURCE'] || 'https://rubygems.org'
case RUBY_PLATFORM
when /darwin/
  gem 'CFPropertyList'
end
gem 'puppet', '5.5.6'
gem 'facter', '2.4.6'
gem 'rspec-puppet-facts', '1.7.0'

# Workaround for PDOC-160
gem 'puppet-strings', :git => 'https://github.com/puppetlabs/puppet-strings'
gem 'pdqtest', '1.4.0'
gem 'rspec-puppet-utils'
