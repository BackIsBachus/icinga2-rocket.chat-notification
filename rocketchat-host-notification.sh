#!/bin/bash

ICINGA_HOSTNAME="<YOUR_ICINGAWEB2_HOSTNAME>"
ROCKETCHAT_WEBHOOK_URL="<YOUR_ROCKETCHAT_WEBHOOK_INTEGRATION_URL>"

#Set the message icon based on ICINGA service state
if [ "$HOSTSTATE" = "Down" ]
then
    ICON=":exclamation:"
elif [ "$HOSTSTATE" = "Up" ]
then
    ICON=":white_check_mark:"
else
    ICON=":white_medium_square:"
fi

#Send message to Rocket.Chat
PAYLOAD="payload={\"text\": \"${ICON} ${NOTIFICATIONTYPE} <http://${ICINGA_HOSTNAME}/icingaweb2/monitoring/host/services?host=${HOSTNAME}|${HOSTDISPLAYNAME}>: *${HOSTSTATE}* | ${HOSTOUTPUT} | [ *${NOTIFICATIONAUTHORNAME}* ] ${NOTIFICATIONCOMMENT} \"}"
curl --connect-timeout 30 --max-time 60 -s -S -X POST --data-urlencode "${PAYLOAD}" "${ROCKETCHAT_WEBHOOK_URL}"
