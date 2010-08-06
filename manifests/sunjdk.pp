# Class: puppetlabs-tomcat::sunjdk
#
#   This class models the Sun Java Development Kit in Puppet
#
#   Jeff McCune <jeff@puppetlabs.com>
#   2010-08-05
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

	File { owner => "0", group => "0", mode  => "0644" }
  Exec { path => "/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin" }

  file {
    "/var/tmp/${installer}":
		  mode    => "0755",
      source  => [ "${p1}/${installer}", "${p2}/${installer}" ],
  }
  exec { "install-jdk":
    command     => "/var/tmp/${installer} -noregister",
    refreshonly => true,
		cwd         => "/var/tmp",
    subscribe   => File["/var/tmp/${installer}"],
  }
  # statements
}
