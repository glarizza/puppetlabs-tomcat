# Class: tomcat
#
#   This class models the tomcat service in Puppet
#   Developed and tested on CentOS 5.5 x86_64
#
#   Once the service is running, connect to:
#   http://<ipaddress>:8080/
#
#   Don't forget to manage the system firewall.
#
#   Jeff McCune <jeff@puppetlabs.com>
#   2010-08-05
#   Status: This class is working and properly starts a tomcat process.
#
# Parameters:
#
# Actions:
#
#   Unpacks tomcat into /usr/apache-tomcat-<version>
#   Links /usr/tomcat to /usr/apache/tomcat-<version>
#   Manages the tomcat service using the system service manager
#
# Requires:
#
#   Java Runtime.  Available in class sunjdk in the pupeptlabs-tomcat
#   module.
#
#   File["/usr/java"] provided by class { "tomcat::sunjdk": }
#
# Sample Usage:
#
#   include tomcat::sunjdk
#   include tomcat
#
class tomcat {
  $module = "tomcat"
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

# JJM The installer tarball.  Copy from local cache if availalbe.
  file {
    "/var/tmp/${installer}":
      source  => [ "${p1}/${installer}", "${p2}/${installer}" ],
  }
  exec {
    "unpack-tomcat":
      command => "tar -C /usr -x -z -f /var/tmp/${installer}",
      creates => "/usr/apache-tomcat-${tomcat_version}",
      require => File["/var/tmp/${installer}"];
    "tomcat-check-script":
      command => "/usr/bin/tomcat-check-script",
      unless  => "/usr/sbin/lsof -n -i :8080",
      require => File["/usr/bin/tomcat-check-script"];
  }
  file {
    "/usr/tomcat":
      ensure  => "/usr/apache-tomcat-${tomcat_version}",
      require => Exec["unpack-tomcat"];
    "/etc/init.d/tomcat":
      mode    => "0755",
      source  => [ "${p1}/tomcat-init-script", "${p2}/tomcat-init-script" ],
      require => File["/usr/tomcat"],
      before  => Service["tomcat"];
    "/usr/bin/tomcat-check-script":
      mode => "0755",
      source => [ "${p1}/tomcat-check-script", "${p2}/tomcat-check-script" ],
      require => Service["tomcat"];
  }
  service {
    "tomcat":
      require   => File["/usr/java"],
      hasstatus => true,
      ensure    => running,
      enable    => true;
  }
}
