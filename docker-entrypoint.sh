#!/bin/bash

if [ `ls /etc/letsencrypt/ | wc -l` -eq 0 ]
then
  cp -r /etc/letsencrypt_default/* /etc/letsencrypt/
fi

#LETSECNRYPT
if [ "$LETSENCRYPTDOMAINS" != "" ]
then
  domains=$(echo $LETSENCRYPTDOMAINS | tr "," "\n")
  for domain in $domains
  do
    certbot certonly --standalone -n -d $domain --agree-tos --email $LETSENCRYPTEMAIL
  done
  cat /etc/letsencrypt/live/mqtt.volker-boehme.de/{privkey,fullchain}.pem > /etc/letsencrypt/live/mqtt.volker-boehme.de/keyfile.pem
  for dir in /etc/letsencrypt/live/*/
  do
    cat ${dir}{privkey,fullchain}.pem > ${dir}keyfile.pem
  done
fi

#Fix permission
chown -R mosquitto /var/lib/mosquitto
chown -R mosquitto /var/log/mosquitto
mkdir /var/run/mosquitto
chown -R mosquitto /var/run/mosquitto

#Start Cron
/etc/init.d/anacron start
/etc/init.d/cron start

#Launch on Foreground
/usr/sbin/mosquitto -c /etc/mosquitto/mosquitto.conf
