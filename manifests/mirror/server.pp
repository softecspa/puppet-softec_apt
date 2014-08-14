# = Class apt::mirror::server
#
# Configure an apt-mirror server
class softec_apt::mirror::server (
  $mirror_tag = 'apt-mirror'
) {
  # TODO: #1335 fare meglio con inserimento repository su /etc/apt/mirror.list
  if !defined(Package['apt-mirror']) {
    package {'apt-mirror':
      ensure  =>  present,
    }
  }

  # create /etc/apt/mirror.list with fragments
  concat_build { 'apt-mirror-list':
    order   => ['*.tmp'],
    target  => "/etc/apt/mirror.list",
  }

  concat_fragment { "apt-mirror-list+00000.tmp":
    content => template('apt/mirror.list.erb'),
  }

  Softec_apt::Mirror::Export_repo <<| mirror_tag == $mirror_tag |>>

  file { '/usr/local/bin/dpkgrepo.py':
    ensure  => present,
    mode    => 0755,
    owner   => root,
    group   => root,
    source  => "puppet:///modules/softec_private/${fqdn}/bin/dpkgrepo.py",
    require => [
      Package['python-argparse'],
      Package['apt-mirror'],
      Package['dpkg-dev'],
    ],
  }

  file { '/usr/local/etc/dpkgrepo.conf':
    ensure  => present,
    mode    => 0640,
    owner   => root,
    group   => apt-mirror,
    source  => "puppet:///modules/softec_private/${fqdn}/etc/dpkgrepo.conf",
    require =>  File['/usr/local/bin/dpkgrepo.py'],
  }

  file { '/usr/local/bin/apt-mirror-wrapper.sh':
    ensure  => present,
    mode    => 0755,
    owner   => root,
    group   => root,
    source  => "puppet:///modules/softec_private/${fqdn}/bin/apt-mirror-wrapper.sh",
    require => [
      Package['apt-mirror'],
      File['/usr/local/bin/dpkgrepo.py'],
    ],
  }

  cron::customentry { 'apt-mirror':
    ensure  => 'present',
    command => '/usr/local/bin/apt-mirror-wrapper.sh',
    user    => 'apt-mirror',
    hour    => '16',
    minute  => '0',
    require => [
      Package['apt-mirror'],
      File['/usr/local/bin/dpkgrepo.py'],
    ],
  }

  file { '/var/spool/apt-mirror/.gnupg':
    ensure  => directory,
    recurse => true,
    ignore  => '.svn',
    mode    => 0700,
    owner   => apt-mirror,
    group   => apt-mirror,
    source  => "puppet:///modules/softec_private/${fqdn}/home/apt-mirror/gnupg",
    require => Package['apt-mirror'],
  }
}
