# Class: puppetlabs-tomcat::sunjdk
#
#   This class models the Sun Java Development Kit in Puppet
#
#   Developed and tested on CentOS 5.5 i386 and x86_64
#   NOTE: It is difficult to uninstall the JDK.  Take a snapshot
#   before evaluating this class.
#
#   NOTE: JJM I recommend services requiring Java establish a relationship
#   with the File["/usr/java"] puppet resource.
#
#   Jeff McCune <jeff@puppetlabs.com>
#   2010-08-05
#
# Parameters:
#
# Actions:
#
#   Installs the Sun Java Development Kit and Java Runtime
#   /usr/bin/java
#
# Requires:
#
# Sample Usage:
#
#   include puppetlabs-tomcat::sunjdk
#
class puppetlabs-tomcat::sunjdk {
  $module    = "puppetlabs-tomcat"
  $class     = "${module}::sunjdk"
  $prefix    = "/etc/puppet/modules"
  $p1        = "${prefix}/${module}/files"
  $p2        = "puppet:///modules/${module}"
  $architecture_real = $architecture ? {
    "x86_64" => "x64",
		"i386"   => "i586",
    default  => $architecture,
  }
  $installer = "jdk-6u21-linux-${architecture_real}-rpm.bin"

	File { owner => "0", group => "0", mode  => "0644" }
  Exec { path => "/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin" }

  file {
    "/var/tmp/${installer}":
		  mode   => "0755",
		  source => [ "${p1}/${installer}", "${p2}/${installer}" ],
		  notify => Exec["install-jdk"],
  }
# JJM Note, this installation is resource is difficult to undo.
# Snapshots are recommended if running in a Virtual Machine.
  exec {
		"install-jdk":
      command => "/var/tmp/${installer} -noregister",
      cwd     => "/var/tmp",
      creates => "/usr/java",
  }
	file {
    "/usr/java":
		  require => Exec["install-jdk"],
		  ensure  => "directory";
	}
}
