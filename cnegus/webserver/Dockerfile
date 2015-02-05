# Webserver container with CGI python script
# Using RHEL 7 base image and Apache Web server
# Version 1
# Pull the rhel image from the local repository
FROM rhel7:latest
USER root
RUN yum update -y
RUN yum install httpd procps-ng MySQL-python -y
ADD action /var/www/cgi-bin/action
RUN chown root:apache /var/www/cgi-bin/action
RUN chmod 755 /var/www/cgi-bin/action
RUN echo "The Web Server is Running" > /var/www/html/index.html
EXPOSE 80
# Start the service
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]
