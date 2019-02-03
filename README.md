# docker-mosquitto

Simple docker container with mosquitto installed as mqtt server.
Let's encrypt is used to obain a valid ssl certificate.

## Configuration
 
 ### Volume Configuration
  | PATH in container | Description |
  | ---------------------- | ----------- |
  | /etc/mosquitto/conf.d | Directory of the mosquitto configuration. If this directory is empty on start a default configruation is provided. |
  | /var/log/mosquitto | Logging directory. Don't foreget to set wrtie permission to this directroy if you are using a local directroy on your docker host.|
  | /var/lib/mosquitto | Mosquitto persistence directory |
  | /etc/letsencrypt | Storage and configuration of the created let's encrypt certificates. If this directory is empty on start a default configruation is provided.|
 
 ### Letsencrypt
  | Environment Variable | Description |
  | ---------------------- | ----------- |
  | LETSENCRYPTDOMAINS | Comma seperated list of all domainnames to request/renew a let's encrypt certificate |
  | LETSENCRYPTEMAIL | E-Mail to be used for notifications from let's encrypt |
