#!/bin/bash
# local_cidrs_file_name="ru.cidr.1"
# local_cidrs_file_name="ru.cidr"
# local_cidrs_file_name="ru.cidr.1"
actual_cidrs_file_name="ru.cidr"
static_cidrs_file_name="ru.cidr.static"
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

while getopts g:i:r:f: flag
do
  case "$flag" in
    g) gtw=$OPTARG;;
    i) ifc=$OPTARG;;
    r) del=$OPTARG;;
    f) local_cidrs_file_name=$OPTARG;;
    *) echo -e "The only flags allowed are:\n-g : gateway \n-i : interface \n-r : remove(yes/no) \nExample : -g 10.0.37.1 -i eth0 -r yes\n" ; exit 1;;
  esac
done

if [[ "$del" == "no" ]] ; then
  echo "Trying to get actual cidrs-list"
  rm -f "/usr/share/vpnc-scripts/$actual_cidrs_file_name"
  wget "https://github.com/herrbischoff/country-ip-blocks/raw/master/ipv4/ru.cidr" -O "/usr/share/vpnc-scripts/$actual_cidrs_file_name"
fi

if [[ -s "$SCRIPTPATH/$actual_cidrs_file_name" ]]; then
  # do with actual
  echo "Have got the new cidrs-list '$actual_cidrs_file_name', will process it"
  input="$SCRIPTPATH/$actual_cidrs_file_name"
elif [[ -s "$SCRIPTPATH/$static_cidrs_file_name" ]]; then
  # do with manualy updated
  echo "Havn't got the new cidrs-list, will process static list '$static_cidrs_file_name'"
  input="$SCRIPTPATH/$static_cidrs_file_name"
else
  echo "Havn't got the new cidrs-list '$actual_cidrs_file_name'!\nCould not find static list '$static_cidrs_file_name'!\nSadly exitting :("
  exit 1
fi

while IFS= read -r line
do
  if [[ "$del" == "no" ]] ; then
    # echo "del: no"
    # echo "gtw: $gtw"
    # echo "ifc: $ifc"
    # echo "del: $del"
    # echo "fl: $local_cidrs_file_name"
    ip route add "$line" via "$gtw" dev "$ifc" 
  elif [[ "$del" == "yes" ]] ; then
    # echo "del: yes"
    # echo "gtw: $gtw"
    # echo "ifc: $ifc"
    # echo "del: $del"
    # echo "fl: $local_cidrs_file_name"
    # ip route delete "$line" via "$gtw" dev "$ifc"
    ip route delete "$line"
  else
    echo -e "The only values allowed for flag '-r' are 'yes' or 'no'\n" ; exit 1
  fi
done < "$input"
echo "Have finished processing '$input'"

