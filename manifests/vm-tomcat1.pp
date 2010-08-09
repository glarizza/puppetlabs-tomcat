# Class: puppetlabs-tomcat::vm-tomcat1
#
#   This class models a virtual machine named tomcat1
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppetlabs-tomcat::vm-tomcat1 {
  $module = "puppetlabs-tomcat"
  $class  = "${module}::tomcat1"

  puppetlabs-tomcat::vmachine {
    "tomcat1":
      vm_mac  => "00:16:36:45:21:D0",
      vm_uuid => "f8902ea2-bea0-46b1-b034-88c22a8b987a",
  }
}
