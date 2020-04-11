#!/bin/bash -e
#
# This script is part of apcupsd-docker by Leroy Foerster.
# It is designed to be run by regularly (e.g. by cron). If it reads a first line '1' in the TRIGGERFILE, it will run the 'action()' function and replace the '1' with a '0'.
# Please change the content of the TRIGGERFILE variable and the action() function according to your needs. This has to be run on the host, not within a container, to be able to shut the machine down.

# Path of the file that get's created in the folder that you mapped into the apcupsd docker container
#   Example: docker run -d -v /tmp/apcupsd-docker:/tmp/apcupsd-docker gersilex/apcupsd
TRIGGERFILE="/tmp/apcupsd-docker/trigger"

# Put everything you want to do on a shutdown condition instide this function.
action(){
  echo "Detected '1' in '$TRIGGERFILE'."

  # Plan shutdown in 5 minutes, if supported by shutdown script
  /sbin/shutdown -P +5 || true

  # Shutdown now, if we finish early with previous command
  /sbin/shutdown -P now
}

### Do not change below. Except you know what you are doing ###
if [ -e "$TRIGGERFILE" ]; then
  read first_line < $TRIGGERFILE
  if [ "$first_line" == "1" ]; then
    echo "0" > $TRIGGERFILE
    action;
  fi
fi
