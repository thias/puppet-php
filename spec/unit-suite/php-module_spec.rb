# php-module_spec.rb - 2014-05-09 07:41
#
# Copyright (c) 2014 Paul Houghton <paul_houghton@cable.comcast.com>
#
require 'spec_helper'

tobject = 'php::module'

packages = {
  'Debian' => {
    'undef' => {
      'undef' => ['php5-test'],
    },
  },
  'RedHat' => {
    'undef' => {
      'undef' => ['php-test'],
    },
  },
}

supported = {
  'Debian' => {
    'undef' => ['undef'
               ],
  },
  'RedHat' => {
    'undef' => ['undef'
               ],
  },
}

supported.keys.each { |fam|
  osfam = supported[fam]
  osfam.keys.each { |os|
    osfam[os].each { |rel|
      describe tobject, :type => :define do
        tfacts = {
          :osfamily               => fam,
          :operatingsystem        => os,
          :operatingsystemrelease => rel,
          :os_maj_version         => rel,
        }
        let(:facts) do tfacts end
        let(:title) { 'test' }
        context "supports facts #{tfacts}" do
          packages[fam][os][rel].each { |pkg|
            it { should contain_package(pkg) }
          }
        end
      end
    }
  }
}
