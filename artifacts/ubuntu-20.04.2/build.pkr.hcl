##################################################################################
# VARIABLES: vCenter
##################################################################################
variable "vcenter_username" {
  type    = string
  description = "The username for authenticating to vCenter."
  default = ""
  sensitive = true
}

variable "vcenter_password" {
  type    = string
  description = "The plaintext password for authenticating to vCenter."
  default = ""
  sensitive = true
}

variable "vcenter_insecure_connection" {
  type    = bool
  description = "If true, does not validate the vCenter server's TLS certificate."
  default = true
}

variable "vcenter_server" {
  type    = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance."
  default = ""
}

variable "vcenter_datacenter" {
  type    = string
  description = "Required if there is more than one datacenter in vCenter."
  default = ""
}

variable "vcenter_host" {
  type = string
  description = "The ESXi host where target VM is created."
  default = ""
}

variable "vcenter_datastore" {
  type    = string
  description = "Required for clusters, or if the target host has multiple datastores."
  default = ""
}

variable "vcenter_network" {
  type    = string
  description = "The network segment or port group name to which the primary virtual network adapter will be connected."
  default = ""
}

variable "vcenter_network_card" {
  type = string
  description = "The virtual network card type."
  default = ""
}

variable "vcenter_folder" {
  type    = string
  description = "The VM folder in which the VM template will be created."
  default = ""
}

##################################################################################
# VARIABLES: VM Settings
##################################################################################
variable "vm_guest_os_family" {
  type    = string
  description = "The guest operating system family."
  default = ""
}

variable "vm_guest_os_vendor" {
  type    = string
  description = "The guest operating system vendor."
  default = ""
}

variable "vm_guest_os_member" {
  type    = string
  description = "The guest operating system member."
  default = ""
}

variable "vm_guest_os_version" {
  type    = string
  description = "The guest operating system version."
  default = ""
}

variable "vm_guest_os_type" {
  type    = string
  description = "The guest operating system type, also know as guestid."
  default = ""
}

variable vm_version {
  type = number
  description = "The VM virtual hardware version."
  # https://kb.vmware.com/s/article/1003746
  default = 14
}

variable "vm_firmware" {
  type    = string
  description = "The virtual machine firmware. (e.g. 'bios' or 'efi')"
  default = "bios"
}

variable "vm_cpu_sockets" {
  type = number
  description = "The number of virtual CPUs sockets."
}

variable "vm_cpu_cores" {
  type = number
  description = "The number of virtual CPUs cores per socket."
}

variable "vm_mem_size" {
  type = number
  description = "The size for the virtual memory in MB."
}

variable "vm_cdrom_type" {
  type    = string
  description = "The virtual machine CD-ROM type."
  default = ""
}

variable "vm_disk_size" {
  type = number
  description = "The size for the virtual disk in MB."
}

variable "vm_disk_controller_type" {
  type = list(string)
  description = "The virtual disk controller types in sequence."
}

##################################################################################
# VARIABLES: ISO
##################################################################################
variable "iso_path" {
  type    = string
  description = "The path on the source vSphere datastore for ISO images."
  default = ""
}

variable "iso_urls" {
  type    = string
  description = "The url source of the ISO image."
  default = ""
}

variable iso_file{
  type = string
  description = "The file name of the guest operating system ISO image installation media."
  default = ""
}

variable "iso_checksum" {
  type    = string
  description = "The SHA checkcum of the ISO image."
  default = ""
}

variable "iso_checksum_type" {
  type    = string
  description = "The SHA checkcum type of the ISO image."
  default = ""
}

variable "http_directory" {
  type    = string
  description = "Directory of config files(user-data, meta-data)."
  default = ""
}

##################################################################################
# VARIABLES: Boot Settings
##################################################################################
variable "vm_boot_wait" {
  type = string
  description = "The time to wait before boot. "
  default = ""
}

variable "vm_boot_command" {
  type = list(string)
  description = "A list of containing boot commands."
  default = []
}

variable "execute_command" {
  type = string
  description = "Post OS command execution"
  default = ""
}

variable "ssh_username" {
  type    = string
  description = "The username to use to authenticate over SSH."
  default = ""
  sensitive = true
}

variable "ssh_password" {
  type    = string
  description = "The plaintext password to use to authenticate over SSH."
  default = ""
  sensitive = true
}

variable "shell_scripts" {
  type = list(string)
  description = "A list of scripts."
  default = []
}

##################################################################################
# LOCALS
##################################################################################
locals {
  buildtime = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
}

##################################################################################
# SOURCE
##################################################################################
source "vsphere-iso" "linux" {
  notes = "Built by HashiCorp Packer on ${local.buildtime}."

# vCenter
  username = var.vcenter_username
  password = var.vcenter_password
  vcenter_server = var.vcenter_server
  datacenter = var.vcenter_datacenter
  datastore = var.vcenter_datastore
  host = var.vcenter_host
  folder = var.vcenter_folder
  insecure_connection = var.vcenter_insecure_connection
  tools_upgrade_policy = true
  remove_cdrom = true
  convert_to_template = true
  guest_os_type = var.vm_guest_os_type

# VM Settings
  vm_name = "${var.vm_guest_os_family}-${var.vm_guest_os_vendor}-${var.vm_guest_os_member}-${var.vm_guest_os_version}"
  vm_version = var.vm_version
  firmware = var.vm_firmware
  cpu_cores = var.vm_cpu_cores
  CPUs = var.vm_cpu_sockets
  CPU_hot_plug = false
  RAM = var.vm_mem_size
  RAM_hot_plug = false
  cdrom_type = var.vm_cdrom_type
  disk_controller_type = var.vm_disk_controller_type
  storage {
    disk_size = var.vm_disk_size
    disk_controller_index = 0
    disk_thin_provisioned = true
  }
  network_adapters {
    network = var.vcenter_network
    network_card = var.vcenter_network_card
  }

# ISO Objects
  iso_url = var.iso_urls
  iso_checksum = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_paths = [
      "[${ var.vcenter_datastore }] /${ var.iso_path }/${var.vm_guest_os_family}-${var.vm_guest_os_vendor}-${var.vm_guest_os_member}-${var.vm_guest_os_version}/${ var.iso_file }"
  ]

# Boot Settings
  http_directory = var.http_directory
  boot_order = "disk,cdrom"
  boot_wait = var.vm_boot_wait
  boot_command = var.vm_boot_command
  ip_wait_timeout = "20m"
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_port = 22
  ssh_timeout = "30m"
  ssh_handshake_attempts = "100000"
  shutdown_command = "echo '${var.ssh_password}' | sudo -S -E shutdown -P now"
  shutdown_timeout = "20m"
}

##################################################################################
# BUILD
##################################################################################
build {
  sources = [
    "source.vsphere-iso.linux"
  ]
  provisioner "shell" {
    execute_command = var.execute_command
    scripts = var.shell_scripts
    expect_disconnect = true
  }
 }