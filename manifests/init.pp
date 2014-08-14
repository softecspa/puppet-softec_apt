class softec_apt{

  class {'apt':
    always_apt_update    => true,
    purge_sources_list_d => true,
    purge_preferences_d  => true,
  }

}
