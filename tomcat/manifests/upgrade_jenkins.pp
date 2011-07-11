class tomcat::upgrade_jenkins inherits jenkins {
  $jenkins_version = '1.419'
  $installer       = "jenkins-${jenkins_version}.war"

  file {'/usr/tomcat/webapps/jenkins':
    ensure  => absent,
    recurse => true,
    force   => true,
  }

  File ['/usr/tomcat/webapps/jenkins.war'] {
    source  => [ "${tomcat::jenkins::p1}/${installer}", "${tomcat::jenkins::p2}/${installer}" ],
    require => File['/usr/tomcat/webapps/jenkins'],
  }

}
