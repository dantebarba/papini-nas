#!/bin/bash
/usr/bin/echo "INFO: stopping all containers"
/usr/bin/docker stop $(/usr/bin/docker ps -aq)
/usr/bin/echo "INFO: Restarting virtual storage"
/usr/bin/docker start $(/usr/bin/docker ps -aq --filter 'label=com.docker.compose.project=plexdrive')
/usr/bin/echo "INFO: Waiting 15s for virtual storage startup"
/usr/bin/sleep 15s
/usr/bin/echo "INFO: Restarting all containers"
/usr/bin/docker start $(/usr/bin/comm -2 -3 <(/usr/bin/docker ps -aq | /usr/bin/sort) <(/usr/bin/docker ps -aq --filter 'label=com.docker.compose.project=plexdrive' | /usr/bin/sort))