# Database container with simple data for a Web application
    # Using RHEL 7 base image and MariahDB database
    # Version 1
    # Pull the rhel image from the local repository
FROM rhel7:latest
USER root
MAINTAINER Chris Negus
# Update image
# RUN yum update -y
# Add Mariahdb software
RUN yum repolist all
RUN yum install -y yum-utils
RUN yum-config-manager --enable epel
RUN yum install -y mariadb-server -y
# Set up Mariahdb database
ADD gss_db.sql /tmp/gss_db.sql
RUN /usr/libexec/mariadb-prepare-db-dir
RUN /usr/bin/mysqld_safe --basedir=/usr && sleep 10s && \
/usr/bin/mysqladmin -u root password 'redhat' && \
mysql --user=root --password=redhat < /tmp/gss_db.sql && \
mysqladmin shutdown --password=redhat
# Expose Mysql port 3306
EXPOSE 3306
CMD ["--basedir=/usr"]
ENTRYPOINT ["/usr/bin/mysqld_safe"]
