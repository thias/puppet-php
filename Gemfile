# Gemfile - 2014-05-10 03:03
#
# Copyright (c) 2014 Paul Houghton <paul4hough@gmail.com>
#
source 'https://rubygems.org'

group :development, :test do
  gem 'bundler'
  gem 'builder','~>3.2.2'
  gem 'puppetlabs_spec_helper', :require => false
  gem 'rspec-puppet'
  gem 'librarian-puppet'
  gem 'puppet-lint', '~> 0.3.2'
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end
