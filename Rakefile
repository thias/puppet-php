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
task :unittest_prep do
 sh "
if [ -d .librarian ] ; then
  echo updating...
  librarian-puppet update;
else
  echo installing...
  librarian-puppet install --path=spec/fixtures/modules/;
fi
"
end

desc "Unit tests"
RSpec::Core::RakeTask.new(:unittest) do |t|
  t.pattern = 'spec/unit/**/*_spec.rb'
end

desc "Unit tests"
RSpec::Core::RakeTask.new(:unittest_doc) do |t|
  t.rspec_opts = ['--format=d']
  t.pattern = 'spec/unit/**/*_spec.rb'
end

desc "Unit-suite tests w/o doc"
RSpec::Core::RakeTask.new(:unittest_nodoc) do |t|
  t.pattern = 'spec/unit-suite/**/*_spec.rb'
end

desc "Unit-suite tests w/ doc"
RSpec::Core::RakeTask.new(:unittest_fulldoc) do |t|
  t.rspec_opts = ['--format=d','--out=unittest-suite-results.txt']
  t.pattern = 'spec/unit-suite/**/*_spec.rb'
end

desc "Generate test results markdown"
task :unittest_suite => [:unittest_fulldoc] do
  sh "outfn=unittest-suite-results.md;
echo '## 'Unit test results - `date` > $outfn;
echo '```' >> $outfn;
cat unittest-suite-results.txt >> $outfn;
echo '```' >> $outfn;
"
end
