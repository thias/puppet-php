# php-cli_spec.rb - 2014-05-09 04:11
#
# Copyright (c) 2014 Paul Houghton <paul4hough@gmail.com>
#
require 'spec_helper'

tobject = 'php::cli'

packages = {
  'Debian' => {
    'undef' => {
      'undef' => ['php5-cli'],
    },
  },
  'RedHat' => {
    'undef' => {
      'undef' => ['php-cli'],
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
      describe tobject, :type => :class do
        tfacts = {
          :osfamily               => fam,
          :operatingsystem        => os,
          :operatingsystemrelease => rel,
          :os_maj_version         => rel,
        }
        let(:facts) do tfacts end
        context "supports facts #{tfacts}" do
          packages[fam][os][rel].each { |pkg|
            it { should contain_package(pkg) }
          }
        end
      end
    }
  }
}
