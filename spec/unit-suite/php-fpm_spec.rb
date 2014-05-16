# master-app-jenkins_spec.rb - 2014-03-09 11:01
#
# Copyright (c) 2014 Paul Houghton <paul4hough@gmail.com>
#
require 'spec_helper'

tobject = 'php::fpm'


files = {
  'Debian' => {
    'Debian' => {
      '7' => ['/etc/php.ini','/etc/php5/fpm/php.ini','/var/lib/php5'],
    },
    'Ubuntu' => {
      'undef' => ['/etc/php.ini','/etc/php5/fpm/php.ini','/var/lib/php5'],
    },
  },
  'RedHat' => {
    'undef' => {
      'undef' => ['/etc/php.ini','/var/lib/php'],
    },
  },
}

classes = {
  'Debian' => {
    'Debian' => {
      '7' => ['php::cli','php::fpm::daemon'],
    },
    'Ubuntu' => {
      'undef' => ['php::cli','php::fpm::daemon'],
    },
  },
  'RedHat' => {
    'undef' => {
      'undef' => ['php::cli','php::fpm::daemon'],
    },
  },
}

lsbname = {
  'undef' => {'undef' => {'undef'=>'undef'}},
  'Debian' => {
    'Debian' => {'7' => 'wheezy'},
    'Ubuntu' => {
      'undef' => 'precise',
      '12'    => 'precise',
      '13'    => 'saucy',
      '14'    => 'trusty',
    },
  },
  'RedHat' => {
    'undef' => {},
    'Fedora' => {
      '19' => '19',
      '20' => '20',
      '21' => '21',
    },
    'CentOS' => {
      '6' => '6',
      '7' => '7',
    },
  },
}

justone = {'Debian' => {'Ubuntu' => ['undef',],}}


justone.keys.each { |fam|
  osfam = justone[fam]
  osfam.keys.each { |os|
    osfam[os].each { |rel|
      describe tobject, :type => :class do
        tfacts = {
          :osfamily               => fam,
          :operatingsystem        => os,
          :operatingsystemrelease => rel,
          :os_maj_version         => rel,
          :lsbdistid              => os,
          :lsbdistcodename        => lsbname[fam][os][rel],
        }
        let(:facts) do tfacts end
        context "supports facts #{tfacts}" do
          files[fam][os][rel].each { |fn|
            it { should contain_file(fn) }
          }
          classes[fam][os][rel].each { |cls|
            it { should contain_class(cls) }
          }
          it { should contain_php__fpm__conf('www') }
        end
      end
    }
  }
}

supported = {
  'Debian' => {
    'Debian' => ['7',],
    'Ubuntu' => ['undef',],
  },
  'RedHat' => {'undef' => ['undef'], },
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
          :lsbdistid              => os,
          :lsbdistcodename        => lsbname[fam][os][rel],
        }
        let(:facts) do tfacts end
        context "supports facts #{tfacts}" do
          classes[fam][os][rel].each { |cls|
            it { should contain_class(cls) }
          }
          files[fam][os][rel].each { |fn|
            it { should contain_file(fn) }
          }
        end
      end
    }
  }
}
