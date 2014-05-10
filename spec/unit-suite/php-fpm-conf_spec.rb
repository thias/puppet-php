# php-fpm-conf_spec.rb - 2014-05-09 09:16
#
# Copyright (c) 2014 Paul Houghton <paul4hough@gmail.com>
#
# php-ini_spec.rb - 2014-05-09 07:29
#
# Copyright (c) 2014 Paul Houghton <paul4hough@gmail.com>
#
require 'spec_helper'

tobject = 'php::fpm::conf'

files = {
  'Debian' => {
    'undef' => {
      'undef' => ['/etc/php5/fpm/pool.d/test.conf'],
    },
  },
  'RedHat' => {
    'undef' => {
      'undef' => ['/etc/php-fpm.d/test.conf'],
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
        let (:title) { 'test' }
        context "supports facts #{tfacts}" do
          files[fam][os][rel].each { |fn|
            it { should contain_file(fn) }
          }
        end
      end
    }
  }
}
