class softec_apt::disable_unattended_upgrades inherits softec_apt::unattended_upgrades {

  File['/etc/apt/apt.conf.d/50unattended-upgrades'] {
    ensure  => absent
  }

  File['/etc/apt/apt.conf.d/10periodic'] {
    content => template('softec_apt/10periodic_disabled.erb')
  }

}
