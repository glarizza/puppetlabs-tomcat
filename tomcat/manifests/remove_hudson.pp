class tomcat::remove_hudson inherits tomcat::hudson{
 exec {'stop-tomcat-hudson':
     command => '/usr/bin/stop_tomcat.sh',
     onlyif  => '/bin/ls /usr/tomcat/webapps/hudson.war',
     before  => [ File['/usr/tomcat/webapps/hudson.war'], File['/usr/tomcat/webapps/hudson'] ],
  }
 
  File ['/usr/tomcat/webapps/hudson.war'] {
      ensure => absent,
	}
	
  file {'/usr/tomcat/webapps/hudson':
      ensure => absent,
      purge  => true,
      force  => true,
      backup => false,
  }

}
