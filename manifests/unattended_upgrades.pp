class softec_apt::unattended_upgrades inherits apt::unattended_upgrades {

  File['/etc/apt/apt.conf.d/50unattended-upgrades'] {
    content => template('softec_apt/50unattended-upgrades.erb')
  }

  File['/etc/apt/apt.conf.d/10periodic'] {
    content => template('softec_apt/10periodic.erb')
  }

  # Se gli unattended-upgrades vengono installati da pacchetto manualmente, viene creato il file
  # 20auto-upgrades. Poiche' il modulo apt di puppetlabs gestisce il tutto con il file 10periodic
  # elimino il 20auto-upgrades ed utilizzero' solo il 10periodic

  file {'/etc/apt/apt.conf.d/20auto-upgrades':
    ensure  => absent,
  }

}
