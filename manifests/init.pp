# Class: puppetlabs-tomcat
#
#   This class models the tomcat service in Puppet
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppetlabs-tomcat {
  $module = "puppetlabs-tomcat"
  $prefix = "/etc/puppet/modules"
# JJM Look for files on the node filesystem first.
  $p1 = "${prefix}/${module}/files"
# JJM Look for files on the puppetmaster second.
  $p2 = "puppet:///modules/${module}"
# Our installer media.
  $tomcat_version = "5.5.30"
  $installer = "apache-tomcat-${tomcat_version}.tar.gz"

  File { owner => "0", group => "0", mode  => "0644" }
  Exec { path => "/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin" }

  file {
    "/var/tmp/${installer}":
      source  => [ "${p1}/${installer}", "${p2}/${installer}" ],
  }
  exec {
    "unpack-tomcat":
      command => "tar -C /usr -x -z -f /var/tmp/${installer}",
      creates => "/usr/apache-tomcat-${tomcat_version}",
      require => File["/var/tmp/${installer}"],
  }
  file { "/usr/tomcat": ensure => "/usr/apache-tomcat-${tomcat_version}" }
}
