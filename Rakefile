# Rakefile - 2014-03-27 06:45
#
# Copyright (c) 2014 Paul Houghton <paul4hough@gmail.com>
#
require 'rake'
require 'rspec/core/rake_task'

require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.disable_80chars
PuppetLint.configuration.disable_class_parameter_defaults
PuppetLint.configuration.ignore_paths = FileList['**/fixtures/modules/**/**']

desc "Test prep with librarian-puppet"
task :unittest_suite do
 sh "echo fixme - need unittest"
end
