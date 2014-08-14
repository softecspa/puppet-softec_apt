class softec_apt::proxy (
  $priority   = '02',
  $proxy      = 'http://packages.tools.softecspa.it',
  $port       = '3142'
) {

  apt::conf{'proxy':
    priority  => $priority,
    content   => "Acquire::http { Proxy \"${proxy}:${port}\"; };",
  }

}
