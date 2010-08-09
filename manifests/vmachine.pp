# Define: puppetlabs-tomcat::vmachine
#
#   Model a virtual machine as a puppet resource.
#   This defined resource type will create a new Xen
#   virtual machine on a domain 0 hypervisor.
#
#   The methodology is to create a writable snapshot
#   of base operating system, boot it, then allow
#   puppet to classify the virtual machine appropriately.
#
#   Jeff McCune <jeff@puppetlabs.com>
#   2010-08-09
#
#   TODO: Implement ensure => stopped
#
# Parameters:
#
# Actions:
#
#   1. LVM Snapshot of golden master image.
#   2. Populate configuration file (/etc/xen/<name>)
#   3. Boot the VM
#
# Requires:
#
# Sample Usage:
#
#   puppetlabs-tomcat::vmachine {
#     "tomcat1":
#       vm_mac         => "00:16:36:45:21:D0",
#       vm_uuid        => "fc47bc4c-f6ca-e418-7d5b-9b2f01044004",
#       vm_disk_source => "/dev/VolGroup00/tomcat0",
#       vm_memory      => "1024";
#   }
define puppetlabs-tomcat::vmachine($vm_mac=false,
  $vm_name=false,
  $vm_disk=false,
  $vm_disk_source="/dev/VolGroup00/tomcat0",
  $ensure="running",
  $vm_uuid,
  $hostname="",
  $vm_memory="512") {

# Selections
  $module = "puppetlabs-tomcat"
  $vm_name_real = $vm_name ? {
    false   => $name,
    default => $vm_name }
  $vm_disk_real = $vm_disk ? {
    false   => "/dev/VolGroup00/${vm_name_real}",
    default => $vm_disk }

# JJM Resource Defaults
  Exec { path => "/bin:/usr/bin:/sbin:/usr/sbin" }
  File { owner => "0", group => "0", mode  => "0644" }
# JJM Clone the GM
  file {
    "/etc/xen/${vm_name_real}":
      content => template("${module}/xenvm.erb");
  }
# JJM FIXME The logic to create the VM is simple.  It could be more robust.
  exec {
    "lvcreate ${vm_name_real}":
      command => "lvcreate -s ${vm_disk_source} -n ${vm_name_real} -L 10G",
      creates => "${vm_disk_real}",
      require => File["/etc/xen/${vm_name_real}"];
    "xm create ${vm_name_real}":
      command => "xm create /etc/xen/${vm_name_real}",
      unless  => "xm list | grep '^${vm_name_real}'",
      require => [ File["/etc/xen/${vm_name_real}"],
                   Exec["lvcreate ${vm_name_real}"], ];
  }
}
