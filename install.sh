#!/bin/sh


#####
# Descargr las direcciones IP V6 de CloudFlare
wget https://www.cloudflare.com/ips-v6 

#####
# Descargar las direcciones IP V4 de CloudFlare
wget https://www.cloudflare.com/ips-v4


#####
# Dar acceso las IPs V6
for ip in `cat ips-v6`; do ufw allow from $ip; done

#####
# Dar acceso a las IPs V4
for ip in `cat ips-v4`; do ufw allow from $ip; done

ufw reload > /dev/null

rm ips-v6
rm ips-v4


