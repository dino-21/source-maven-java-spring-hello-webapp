FROM docker.io/library/tomcat:9-jre21
COPY target/hello-world.war /usr/local/tomcat/webapps/

