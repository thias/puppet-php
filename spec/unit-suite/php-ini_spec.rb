# php-ini_spec.rb - 2014-05-09 07:29
#
# Copyright (c) 2014 Paul Houghton <paul4hough@gmail.com>
#
require 'spec_helper'

tobject = 'php::ini'

files = {
  'Debian' => {
    'undef' => {
      'undef' => ['/etc/php.ini'],
    },
  },
  'RedHat' => {
    'undef' => {
      'undef' => ['/etc/php.ini'],
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
        let (:title) { '/etc/php.ini' }
        context "supports facts #{tfacts}" do
          files[fam][os][rel].each { |fn|
            it { should contain_file(fn) }
          }
        end
      end
    }
  }
}
