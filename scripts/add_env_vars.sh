#!/bin/sh
echo 'DNS_HTTP_USER=' >> /etc/environment
echo 'DNS_HTTP_PASS=' >> /etc/environment
echo 'CONFIG_LOCATION' >> /etc/environment
echo 'DNSMASQ_CONFIG=' >> /etc/environment
echo 'DUPLICATI_HOME=' >> /etc/environment
echo 'RESILIO_HOME=' >> /etc/environment
echo 'FILEBROWSER_HOME=' >> /etc/environment
echo 'DOCKER_MEDIA_SERVER' >> /etc/environment
echo 'RADARR_API_TOKEN=' >> /etc/environment
echo 'SONARR_API_TOKEN=' >> /etc/environment
echo 'REMOTE_UPSTREAM=' >> /etc/environment
echo 'REMOTE_STORAGE_LOCATION="export $(ssh $REMOTE_UPSTREAM "env | grep STORAGE_LOCATION)"' >> /etc/environment
echo 'CUPS_USER_PASSWORD=' >> /etc/environment
echo 'DOCKER_LOCATION=' >> /etc/environment
echo 'LOGIO_ADMIN_PASSWORD=' >> /etc/environment