# Database container with simple data for a Web application
    # Using RHEL 7 base image and MariahDB database
    # Version 1
    # Pull the rhel image from the local repository
FROM rhel7:latest
USER root
MAINTAINER Chris Negus
# Update image
RUN yum update -y
# Add Mariahdb software
RUN yum -y install mariadb-server -y
# Set up Mariahdb database
ADD gss_db.sql /tmp/gss_db.sql
ADD install_db.sh /tmp/install_db.sh
RUN /usr/libexec/mariadb-prepare-db-dir
RUN /tmp/install_db.sh
#RUN /usr/bin/mysqld_safe --basedir=/usr && echo BB && sleep 10s && echo "admin" && /usr/bin/mysqladmin -u root password 'redhat' && mysql --user=root --password=redhat < /tmp/gss_db.sql && mysqladmin shutdown --password=redhat
# Expose Mysql port 3306
EXPOSE 3306
CMD ["--basedir=/usr"]
ENTRYPOINT ["/usr/bin/mysqld_safe"]
