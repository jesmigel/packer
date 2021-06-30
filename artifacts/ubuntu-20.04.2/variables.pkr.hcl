##################################################################################
# ISO
##################################################################################
iso_urls                        = "http://releases.ubuntu.com/20.04/ubuntu-20.04.2-live-server-amd64.iso"
iso_checksum                    = "d1f2bf834bbe9bb43faf16f9be992a6f3935e65be0edece1dee2aa6eb1767423"
iso_checksum_type               = "sha256"
iso_path                        = "/packer_cache/"
iso_file                        = "ubuntu-20.04.2-live-server-amd64.iso"

##################################################################################
# VM Settings
##################################################################################
vm_guest_os_family              = "linux"
vm_guest_os_vendor              = "ubuntu"
vm_guest_os_member              = "server"
vm_guest_os_type                = "ubuntu64Guest"
vm_guest_os_version             = "20.04.2"
vm_cpu_sockets                  = "4"
vm_cpu_cores                    = "1"
vm_mem_size                     = "2048"
vm_cdrom_type                   = "sata"
vm_disk_controller_type         = ["pvscsi"]
vm_disk_size                    = "20480"

##################################################################################
# Boot Settings
##################################################################################
http_directory                  = "http"
vm_boot_wait                    = "5s"
vm_boot_command                 = ["<enter><enter><f6><esc><wait> ","autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/","<enter>"]
ssh_username                    = "ubuntu"
ssh_password                    = "ubuntu"
shell_scripts                   = ["scripts/provisioner.sh"]

##################################################################################
# Boot Settings
##################################################################################
execute_command                 = "echo 'ubuntu' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
