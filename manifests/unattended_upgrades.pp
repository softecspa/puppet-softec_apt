class softec_apt::unattended_upgrades {

  file{ '/etc/apt/apt.conf.d/50unattended-upgrades': 
    content => template('softec_apt/50unattended-upgrades.erb')
  }

  file { '/etc/apt/apt.conf.d/10periodic':
    content => template('softec_apt/10periodic.erb')
  }

}
