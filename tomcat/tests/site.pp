node default {
  include puppetlabs-tomcat
  include puppetlabs-tomcat::sunjdk
  include puppetlabs-tomcat::hudson
}
