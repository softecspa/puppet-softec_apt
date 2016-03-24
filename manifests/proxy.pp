class softec_apt::proxy (
  $ensure     = present,
  $priority   = '02',
  $proxy      = 'http://packages.tools.softecspa.it',
  $port       = '3142'
) {

  apt::conf { 'proxy':
    ensure   => $ensure,
    priority => $priority,
    content  => "Acquire::http { Proxy \"${proxy}:${port}\"; };",
  }

}
