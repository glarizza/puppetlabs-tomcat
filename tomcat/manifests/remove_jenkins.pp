class tomcat::remove_jenkins inherits tomcat::jenkins{
  exec {'stop-tomcat-jenkins':
    command => '/usr/bin/stop_tomcat.sh',
    onlyif  => '/bin/ls /usr/tomcat/webapps/jenkins.war',
    before  => [ File['/usr/tomcat/webapps/jenkins.war'], File['/usr/tomcat/webapps/jenkins'] ],
  }

  File ['/usr/tomcat/webapps/jenkins.war'] {
      ensure => absent,
	}

  file {'/usr/tomcat/webapps/jenkins':
      ensure => absent,
      purge  => true,
      force  => true,
      backup => false,
  }
   
}
