# docker-mosquitto installation

Simple docker container with mosquitto installed as mqtt server.
Let's encrypt is used to obain a valid ssl certificate.

## Configuration
 
### Configuration files, log files, buisness data
The following directories can be loaded from the host to keep the data and configuration files out of the container:

 | PATH in container | Description |
 | ---------------------- | ----------- |
 | /etc/mosquitto/conf.d | Directory of the mosquitto configuration. If this directory is empty on start a default configruation is provided. |
 | /var/log/mosquitto | Logging directory. Don't forget to set wrtie permission to this directroy if you are using a local directory on your docker host.|
 | /var/lib/mosquitto | Mosquitto persistence directory |
 | /etc/letsencrypt | Storage and configuration of the created let's encrypt certificates. If this directory is empty on start a default configruation is provided.|

### Environment variables
The following environment variables are available to configure the container on startup.

 | Environment Variable | Description |
 | ---------------------- | ----------- |
 | LETSENCRYPTDOMAINS | Comma seperated list of all domainnames to request/renew a let's encrypt certificate |
 | LETSENCRYPTEMAIL | E-Mail to be used for notifications from let's encrypt |

## Container Tags

 | Tag name | Description |
 | ---------------------- | ----------- |
 | latest | Latest stable version of the container |
 | stable | Latest stable version of the container |
 | dev | latest development version of the container. Do not use in production environments! |

## Usage

To run the container and store the data and configuration on the local host run the following commands:
1. Create storage directroy for the configuration files, log files and data. Also create a directroy to store the necessary script to create the docker container and replace it (if not using eg. watchtower)
```
mkdir /srv/docker/mosquitto
mkdir /srv/docker-config/mosquitto
```

2. Create an file to store the configuration of the environment variables
```
touch /srv/docker-config/mosquitto/env_file
``` 
```
#Comma seperated list of domainnames
LETSENCRYPTDOMAINS=mqtt.example.com
LETSENCRYPTEMAIL=example@example.com
```

3. Create the mosquitto configuration file
```
touch /srv/docker/mosquitto/etc/mosquitto/conf.d/mosquitto.conf
```
```
user mosquitto
port 8883


#capath
cafile /etc/letsencrypt/live/example.example.com/chain.pem

# Path to the PEM encoded server certificate.
#certfile
certfile /etc/letsencrypt/live/example.example.com/cert.pem

# Path to the PEM encoded keyfile.
#keyfile
keyfile /etc/letsencrypt/live/example.example.com/keyfile.pem

allow_anonymous false
password_file /etc/mosquitto/conf.d/password_file

```

4. Create the mosquitto password file
```
touch /srv/docker/mosquitto/etc/mosquitto/conf.d/password_file
```
To add users to the password file run the following command inside the container:
```
mosquitto_passwd -c /etc/mosquitto/conf.d/password_file <username>
```

5. Create the docker container. I always create a script for that and store it under
```
touch /srv/docker-config/mosquitto/create.sh
```
Content of create.sh:
```
#!/bin/bash

docker pull foxcris/docker-mosquitto
docker create\
 --restart always\
 --name mosquitto\
 --env-file=/srv/docker-config/mosquitto/env_file\
 -p 8883:8883\
 -v /srv/docker/mosquitto/etc/mosquitto/conf.d:/etc/mosquitto/conf.d\
 -v /srv/docker/mosquitto/var/lib/mosquitto:/var/lib/mosquitto\
 -v /srv/docker/mosquitto/var/log/letsencrypt:/var/log/letsencrypt\
 -v /srv/docker/mosquitto/var/log/letsencrypt:/var/log/letsencrypt\
 -v /srv/docker/mosquitto/etc/letsencrypt:/etc/letsencrypt\
 foxcris/docker-mosquitto
```

6. Create replace.sh to install/update the container. Store it in
```
touch /srv/docker-config/mosquitto/replace.sh
```
```
#/bin/bash
docker stop mosquitto
docker rm mosquitto
./create.sh
docker start mosquitto
```
