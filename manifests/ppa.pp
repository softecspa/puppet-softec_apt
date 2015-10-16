# == define apt::ppa
#
# Add a PPA repository
#
# === Parameters
#
# [*title*], name of the package you want to install using this PPA
#
# [*priority*], same meaning in apt::source_list, default value is 500
#
# [*key*], signing key reported on launchpad page (ignored if mirror is enabled)
#
# [*mirror*], instead of add launchpad repo, use Softec mirror (install Softec key)
#
# [*mirror_name*], use this if you want to mirror an already defined resource (changing $name)
#
# [*mirror_src*], mirror also src packages (used only if mirror is true)
#
# === Notes
#
# If mirror is not enabled, key must be a valid key
#
# === Example
#
# To add the repository named ppa:ondrej/php5 you can use:
#
# apt::ppa { 'ondrej/php5':
#   key => 'E5267A6C',
# }
#
define softec_apt::ppa(
  $ensure=present,
  $release= $::lsbdistcodename,
  $options= $apt::params::ppa_options,
  $priority=400,
  $key=false,
  $mirror=false,
  $mirror_name=undef,
  $mirror_src=false,
)
{
  if $lsbdistid != 'Ubuntu' {
    fail "Module $module_name is not compatible with distro $lsbdistid"
  }

  if ! $key and ! $mirror  {
    fail "One between key and mirror should be enabled!"
  }

  if $key {
    apt::key{ $key: }
  }

  if $mirror and $mirror_name {
    $ppa_details = split($mirror_name, '/')
  } else {
    $ppa_details = split($name, '/')
  }

  validate_array($ppa_details)
  $ppa_user = $ppa_details[0]
  $ppa_path = $ppa_details[1]
  validate_re($ppa_user, '[a-z][a-z0-9]+', "Invalid PPA user name: $ppa_user")
  validate_re($ppa_path, '[a-z][a-z0-9]+', "Invalid PPA path: $ppa_path")

  if $mirror {
    $ppa_source_list = "${ppa_user}-${ppa_path}-${lsbdistcodename}"
    softec_apt::mirror::repo { $ppa_source_list:
      title     => $ppa_source_list,
      priority  => $priority,
      url       => "ppa.launchpad.net",
      path      => "/${ppa_user}/${ppa_path}/ubuntu",
      enable    => true
    }

  } else  {
    apt::ppa {"ppa:$name":
      ensure  => $ensure,
      release => $release,
      options => $options
    }
    if $priority {
      apt::pin {$name:
        priority  => $priority,
        release   => $name,
        packages  => '*'
      }
    }
  }
}
