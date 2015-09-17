class softec_apt::main_source_list {

  include ::apt

  if $operatingsystem == 'Ubuntu' {

      apt::source {$::lsbdistcodename:
        location  => 'http://archive.ubuntu.com/ubuntu/',
        repos     => 'main restricted universe'
      }

      apt::source {"${::lsbdistcodename}-updates":
        location  => 'http://archive.ubuntu.com/ubuntu/',
        release   => "${::lsbdistcodename}-updates",
        repos     => 'main restricted universe',
      }

      apt::source {"${::lsbdistcodename}-security":
        location  => 'http://security.ubuntu.com/ubuntu',
        release   => "${::lsbdistcodename}-security",
        repos     => 'main restricted universe',
      }

      apt::source {"${::lsbdistcodename}-partner":
        location  => 'http://archive.canonical.com/ubuntu',
        repos     => 'partner',
      }
    }
}
