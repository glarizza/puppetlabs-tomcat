# Class: puppetlabs-tomcat::sunjdk
#
#   This class models the Sun Java Development Kit in Puppet
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppetlabs-tomcat::sunjdk {
  $module    = "puppetlabs-tomcat"
  $class     = "${module}::sunjdk"
  $prefix    = "/etc/puppet/modules"
  $p1        = "${prefix}/${module}"
  $p2        = "puppet:///modules/${module}"
  $architecture_real = $architecture ? {
    "x86_64" => "x64",
    default  => $architecture,
  }
  $installer = "jdk-6u21-linux-${architecture_real}-rpm.bin"

  Exec { path => "/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin" }

  file {
    "/var/tmp/${installer}":
      source  => [ "${p1}/${installer}", "${p2}/${installer}" ],
      recurse => "false"
  }
  exec { "install-jdk":
    command     => "/var/tmp/${installer} -noregister",
    refreshonly => true,
    subscribe   => File["/var/tmp/${installer}"],
  }
  # statements
}
