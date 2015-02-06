nohup cd usr && /usr/bin/mysqld_safe --basedir=/usr & 
echo BB 
sleep 10s 
echo "admin" 
cd /usr && /usr/bin/mysqladmin -u root password 'redhat' 
mysql --user=root --password=redhat < /tmp/gss_db.sql 
mysqladmin shutdown --password=redhat
