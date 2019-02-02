#!/bin/bash

if [ `ls /etc/letsencrypt/ | wc -l` -eq 0 ]
then
  cp -r /etc/letsencrypt_default/* /etc/letsencrypt/
fi

if [ `ls /etc/mosquitto/ | wc -l` -eq 0 ]
then
  cp -r /etc/mosquitto_default/* /etc/mosquitto/
fi

#LETSECNRYPT
if [ "$LETSENCRYPTDOMAINS" != "" ]
then
  certbot certonly --standalone -n -d $LETSENCRYPTDOMAINS --agree-tos --email $LETSENCRYPTEMAIL
fi

#Start Cron
/etc/init.d/anacron start
/etc/init.d/cron start

#Launch on Foreground
/usr/sbin/mosquitto
