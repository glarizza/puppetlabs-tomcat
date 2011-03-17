class tomcat::jenkins {

    include tomcat
    include tomcat::service

    package { "jenkins":
        ensure  => installed,
        require => [ File["/etc/yum.repos.d/jenkins.repo"], Exec["install-jenkins-repo-key"] ]
    }

    File {
        owner => "root",
        group => "root",
        mode  => "0644",
    }

    file {
        "/etc/yum.repos.d/jenkins.repo":
            source => "puppet:///modules/tomcat/jenkins.repo",
            notify => Exec["install-jenkins-repo-key"];
        "/usr/tomcat/webapps/jenkins.war":
            ensure => link,
            target => "/usr/lib/jenkins/jenkins.war";
    }

    Exec {
        path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
    }

    exec { "install-jenkins-repo-key":
        command     => "rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key",
        refreshonly => true,
    }
}
