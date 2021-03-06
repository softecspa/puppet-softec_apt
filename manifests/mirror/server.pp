# = Class apt::mirror::server
#
# Configure an apt-mirror server
class softec_apt::mirror::server (
  $mirror_tag = 'apt-mirror'
) {
  # TODO: #1335 fare meglio con inserimento repository su /etc/apt/mirror.list

  ensure_resource('package', 'apt-mirror', { ensure  =>  latest })

  # create /etc/apt/mirror.list with fragments
  concat_build { 'apt-mirror-list':
    order  => ['*.tmp'],
    target => '/etc/apt/mirror.list',
  }

  concat_fragment { 'apt-mirror-list+00000.tmp':
    content => template('softec_apt/mirror.list.erb'),
  }

  Softec_apt::Mirror::Export_repo <<| mirror_tag == $mirror_tag |>>

  file { '/usr/local/bin/dpkgrepo.py':
    ensure  => present,
    mode    => '0755',
    owner   => root,
    group   => root,
    source  => "puppet:///modules/softec_private/${::fqdn}/bin/dpkgrepo.py",
    require => [
      Package['python-argparse'],
      Package['apt-mirror'],
      Package['dpkg-dev'],
    ],
  }->
  file { '/usr/local/etc/dpkgrepo.conf':
    ensure => present,
    mode   => '0640',
    owner  => root,
    group  => apt-mirror,
    source => "puppet:///modules/softec_private/${::fqdn}/etc/dpkgrepo.conf",
  }->
  # Questo esegue apt-mirror e poi fa dpkgrepo.py per ricreare gli indici e le firme
  file { '/usr/local/bin/apt-mirror-wrapper.sh':
    ensure => present,
    mode   => '0755',
    owner  => root,
    group  => root,
    source => "puppet:///modules/softec_private/${::fqdn}/bin/apt-mirror-wrapper.sh",
  }->
  cron::customentry { 'apt-mirror':
    ensure  => 'present',
    command => '/usr/local/bin/solo -port=61235 /usr/local/bin/apt-mirror-wrapper.sh',
    user    => 'apt-mirror',
    special => 'hourly'
  }

  file { '/var/spool/apt-mirror/.gnupg':
    ensure  => directory,
    recurse => true,
    ignore  => '.svn',
    mode    => '0700',
    owner   => apt-mirror,
    group   => apt-mirror,
    source  => "puppet:///modules/softec_private/${::fqdn}/home/apt-mirror/gnupg",
    require => Package['apt-mirror'],
  }
}
