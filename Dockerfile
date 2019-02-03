FROM debian:stretch 

MAINTAINER foxcris

#repositories richtig einrichten
RUN echo 'deb http://deb.debian.org/debian stretch main' > /etc/apt/sources.list 
RUN echo 'deb http://deb.debian.org/debian stretch-updates main' >> /etc/apt/sources.list 
RUN echo 'deb http://security.debian.org stretch/updates main' >> /etc/apt/sources.list
#backports fuer certbot
RUN echo 'deb http://ftp.debian.org/debian stretch-backports main' >> /etc/apt/sources.list 


RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales && apt-get clean 
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 ENV LANG en_US.UTF8

#automatische aktualiserung installieren + basic tools
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get install -y nano less anacron unattended-upgrades apt-transport-https htop && apt-get clean

#mosquitto
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get install -y mosquitto && apt-get clean

#certbot
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get install -y python-certbot -t stretch-backports && apt-get clean
RUN mv /etc/letsencrypt /etc/letsencrypt_default

EXPOSE 1883 8883 
COPY docker-entrypoint.sh / 
RUN chmod 755 /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
