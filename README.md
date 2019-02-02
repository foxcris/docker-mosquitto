# docker-mosquitto

Simple docker container with mosquitto installed as mqtt server.
Let's encrypt is used to obain a valid ssl certificate.

## Configuration
 
 ### Volume Configuration
  | PATH in container | Description |
  | ---------------------- | ----------- |
  | /mosquitto/conf | Directory of the mosquitto configuration. If this directory is empty on start a default configruation is provided. |
  | /var/log/mosquitto | Logging directory |
  | /etc/letsencrypt | Storage of the created let's encrypt certificates |
 
 ### Letsencrypt
  | Environment Variable | Description |
  | ---------------------- | ----------- |
  | LETSENCRYPTDOMAINS | Comma seperated list of all domainnames to request/renew a let's encrypt certificate |
  | LETSENCRYPTEMAIL | E-Mail to be used for notifications from let's encrypt |
