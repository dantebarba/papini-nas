#!/bin/bash
/usr/bin/docker restart $(docker ps -a -q)