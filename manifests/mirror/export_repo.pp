# = Define softec_apt::mirror::export_repo
#
#   Export a fragment for collecting on apt-mirror
#
# == Params
# [*url*]
#   url of the repository to mirror
#
# [*path*]
#   path of the repo to mirror
#
# [*release*]
#   Force a release, if not specified $lsbcoderelease is taken
#
# [*mirror_tag*]
#   Tag used to export the resource (differentiate if you want more mirror). Default: apt-mirror
#
# [*delimiter*]
#   Remove from title for name uniqueness. Default: ##
#
define softec_apt::mirror::export_repo(
  $url,
  $path,
  $release='',
  $mirror_tag='apt-mirror',
  $delimiter='##'
) {

  $real_release = $release ? { '' => $lsbdistcodename, default => $release }
  $p = regsubst($path,'/','_', 'G')
  $params = {
    'tag' => $mirror_tag,
    'content' => template('softec_apt/mirror_repo.erb')
  }
  
  if ($::lsbdistrelease < '10.04') {
    notify { 'apt-mirror is not supported in release out of maintenance': }
  } else {
    ensure_resource('concat_fragment', "apt-mirror-list+${url}-${p}-${real_release}.tmp", $params)
  }

}
