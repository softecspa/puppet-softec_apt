# = Define apt::mirror::repo
#
#   Enable mirroring on a repo and (optionally)
#   configures it locally
#
# == Params
#
# [*title*]
#   title of the resource
#
# [*url*]
#   url of the repository to mirror (ex: ppa.launchpad.net)
#
# [*path*]
#   path of the repo to mirror (ex: /ondrej/php5-oldstable/ubuntu)
#
# [*release*]
#   Force a release, if not specified $lsbcoderelease is taken
#
# [*priority*]
#   Used to set the local repository priority
#
# [*enable*]
#   If true the mirrored repo is configured locally
#
# [*export*]
#   If true a resource is exported so it can be collected by an apt-mirror
#
# [*export_tag*]
#   Tag used to export the resource (differentiate if you want more mirror). Default: apt-mirror
#
define softec_apt::mirror::repo(
  $title,
  $url,
  $path="",
  $release="",
  $priority=500,
  $enable=false,
  $export=true,
  $export_tag='apt-mirror'
) {

  $real_release = $release ? { '' => $lsbdistcodename, default => $release }
  $p = regsubst($path,'/','_', 'G')

  if $enable {
    if ! defined(Class['softec_apt::mirror::key']) {
      class{'softec_apt::mirror::key': }
    }

    apt::source {$title:
      location  => "http://${::apt_mirror_url}/${url}${path}",
      repos     => 'main',
      release   => $real_release,
      require   => Class['softec_apt::mirror::key'],
      include_src => false,
    }

    if $priority {
      apt::pin {$name:
        priority  => $priority,
        release   => $name,
        packages  => '*'
      }
    }
  }

  if $export {
    @@softec_apt::mirror::export_repo { "${title}##${hostname}":
      url => $url,
      path => $path,
      release => $real_release,
      mirror_tag => $export_tag
    }
  }
}
