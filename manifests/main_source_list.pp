class softec_apt::main_source_list {

  class {'apt_puppetlabs':
    always_apt_update     => true,
    purge_sources_list_d  => true,
    purge_sources_list    => true,
    purge_preferences     => true,
  }

  apt_puppetlabs::source {'lucid':
    location  => 'http://archive.ubuntu.com/ubuntu/',
    repos     => 'main restricted universe'
  }

  apt_puppetlabs::source {'lucid-updates':
    location  => 'http://archive.ubuntu.com/ubuntu/',
    release   => 'lucid-updates',
    repos     => 'main restricted universe',
  }

  apt_puppetlabs::source {'lucid-security':
    location  => 'http://security.ubuntu.com/ubuntu',
    release   => 'lucid-security',
    repos     => 'main restricted universe',
  }

  apt_puppetlabs::source {'lucid-partner':
    location  => 'http://archive.canonical.com/ubuntu',
    repos     => 'partner',
  }


}
