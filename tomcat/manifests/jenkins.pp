# Class: tomcat::jenkins
#
#   This class models the Jenkins Continuous Integration
#   service in Puppet.
#
#   http://jenkins-ci.org/
#
#   This management strategy is to deploy the war file
#   into ${TOMCAT_HOME:=/usr/tomcat}/webapps
#
#   Jeff McCune <jeff@puppetlabs.com>
#   2010-08-05
#
# Parameters:
#
# Actions:
#
#   Manages /usr/tomcat/webapps/jenkins.war
#
# Requires:
#
#   Service["tomcat"], File["/usr/tomcat"]
#   which are provided by provided by class { "tomcat": }
#
# Sample Usage:
#
#   include "tomcat::jenkins"
#
class tomcat::jenkins {
  $module = "tomcat"
  $class  = "${module}::jenkins"
  $prefix = "/etc/puppet/modules"
# JJM Look for files on the node filesystem first.
  $p1 = "${prefix}/${module}/files"
# JJM Look for files on the puppetmaster second.
  $p2 = "puppet:///modules/${module}"
# Our installer media.
  $jenkins_version = "1.400"
  $installer = "jenkins-${jenkins_version}.war"

  File { owner => "0", group => "0", mode  => "0644" }

  file {
    "/usr/tomcat/webapps/jenkins.war":
      source  => [ "${p1}/${installer}", "${p2}/${installer}" ],
      require => File["/usr/tomcat"],
      before  => Class["${module}::service"],
      notify  => Service["tomcat"];
  }
}
# JJM EOF
