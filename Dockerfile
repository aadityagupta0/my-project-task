FROM centos:latest

#Install the prerequisite OS packages using yum command
RUN yum -y install httpd php php-mysqlnd php-gd php-xmlrpc php-intl php-mbstring php-json
RUN yum -y install mariadb-server mariadb wget
VOLUME /var/lib/mysql



#Start the Web Server and Database Service
#RUN mysqld start 
RUN systemctl enable httpd.service
RUN systemctl enable mariadb


#Create Mediawiki Database
ARG MYSQL_DATABASE
ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG MYSQL_ROOT_PASSWORD

ENV MYSQL_DATABASE=${mediawiki_db}
ENV MYSQL_USER=${wiki_user}
ENV MYSQL_PASSWORD=${wiki}
ENV MYSQL_ROOT_PASSWORD=${root}
CMD ["mysqld"]

# UTC Timezone & Networking
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
	&& echo "NETWORKING=yes" > /etc/sysconfig/network

#Download MediaWiki 1.36.1 with wget command
RUN  wget https://releases.wikimedia.org/mediawiki/1.36/mediawiki-1.36.1.tar.gz && \
    tar -zxpvf mediawiki-1.36.1.tar.gz 
RUN mv mediawiki-1.36.1 /var/www/html/mediawiki 
RUN chown -R apache:apache /var/www/html/mediawiki/ && \
    chmod 755 /var/www/html/mediawiki/ 


ENTRYPOINT ["/usr/sbin/httpd"] 
CMD ["-D", "FOREGROUND"]


#Expose Ports
EXPOSE 3306
EXPOSE 8080
EXPOSE 80
