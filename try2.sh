#!/bin/bash
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
echo "$SCRIPTPATH"

DEFAULT_ROUTE_FILE="./default_rt"

while IFS= read -r line
do
  IFS= read dflt
  IFS= read via
  IFS= read NETGW
  IFS= read dev
  IFS= read NETDEV 
done < "$DEFAULT_ROUTE_FILE"
  echo $dflt
  echo $via
  echo $NETGW
  echo $dev
  echo $NETDEV 


 	DEFAULT_ROUTE="$(cat "$DEFAULT_ROUTE_FILE")"
  echo $DEFAULT_ROUTE
  NETGW=$(cat "$DEFAULT_ROUTE_FILE" | cut -f 3 -d ' ')
  NETDEV=$(cat "$DEFAULT_ROUTE_FILE" | cut -f 5 -d ' ')
  echo "NETGW : $NETGW"
  echo "NETDEV : $NETDEV"

actual_cidrs_file_name="ru.cidr"
static_cidrs_file_name="ru.cidr.static"

echo "Trying to get actual cidrs-list"
rm -f "/usr/share/vpnc-scripts/$actual_cidrs_file_name"
wget "https://github.com/herrbischoff/country-ip-blocks/raw/master/ipv4/ru.cidr1" -O "/usr/share/vpnc-scripts/$actual_cidrs_file_name"

if [[ -s "$SCRIPTPATH/$actual_cidrs_file_name" ]]; then
  # do with actual
  echo "Have got the new cidrs-list '$actual_cidrs_file_name', will process it"
elif [[ -s "$SCRIPTPATH/$static_cidrs_file_name" ]]; then
  # do with manualy updated
  echo "Havn't got the new cidrs-list, will process static list '$static_cidrs_file_name'"
else
  echo "Havn't got the new cidrs-list '$actual_cidrs_file_name'!\nCould not find static list '$static_cidrs_file_name'!\nSadly exitting :("
  exit 1
fi
