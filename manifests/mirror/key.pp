# = Class apt::mirror::key
#
# Install Softec key for apt-mirror
class softec_apt::mirror::key {
    exec{ "add_apt_mirror_key":
        command => "/usr/bin/wget -qO - http://${::apt_mirror_url}/${::apt_mirror_key} | sudo apt-key add -",
        unless  => "/usr/bin/apt-key list | grep 'sistemi@support.softecspa.it'"
    }
}
