#!/usr/bin/env bash
#
# Evaluate free system memory from Linux based systems based on percentage
# This was forked from Sensu Community Plugins
#
# Date: 2007-11-12
# Author: Thomas Borger - ESG
# Date: 2012-04-02
# Modified: Norman Harman - norman.harman@mutualmobile.com
# Date: 2013-9-30
# Modified: Mario Harvey - Zumetrics
# Date: 2015-01-10
# Modified Ollie Armstrong <ollie@armstrong.io>
# Date: 2016-02-15
# Modified: J. Brandt Buckley <brandt.buckley@sendgrid.com>

# set lang
LANG=C

# get arguments

# #RED
while getopts 'w:c:hp' OPT; do
  case $OPT in
    w)  WARN=$OPTARG;;
    c)  CRIT=$OPTARG;;
    h)  hlp="yes";;
    p)  perform="yes";;
    *)  unknown="yes";;
  esac
done

# usage
HELP="
    usage: $0 [ -w value -c value -p -h ]

        -w --> Warning Percentage < value
        -c --> Critical Percentage < value
        -p --> print out performance data
        -h --> print this help screen
"

if [ "$hlp" = "yes" ]; then
  echo "$HELP"
  exit 0
fi

WARN=${WARN:=80}
CRIT=${CRIT:=90}

os=$(uname)
if [ $os = "Darwin" ]; then
  #Get total memory available on machine
  TotalMem=$(sysctl -a | grep '^hw\.m' | cut -d" " -f2)
  #Determine amount of free memory on the machine
  FreeMem=$(vm_stat | grep "Pages free" | tr -d '[:space:]' | cut -d: -f2 | cut -d. -f1)
elif [ $os = "Linux" ]; then
  #Get total memory available on machine
  TotalMem=$(free -m | grep Mem | awk '{ print $2 }')
  #Determine amount of free memory on the machine
  set -o pipefail
  FreeMem=$(free -m | grep buffers/cache | awk '{ print $4 }')
  if [ $? -ne 0 ]; then
    FreeMem=$(free -m | grep Mem | awk '{ print $7 }')
  fi
fi

#Get percentage of free memory
FreePer=$(awk -v total="$TotalMem" -v free="$FreeMem" 'BEGIN { printf("%-10f\n", (free / total) * 100) }' | cut -d. -f1)
#Get actual memory usage percentage by subtracting free memory percentage from 100
UsedPer=$((100-$FreePer))


if [ "$UsedPer" = "" ]; then
  echo "MEM UNKNOWN -"
  exit 3
fi

if [ "$perform" = "yes" ]; then
  output="system memory usage: $UsedPer% | free memory="$UsedPer"%;$WARN;$CRIT;0"
else
  output="system memory usage: $UsedPer%"
fi

if (( $UsedPer >= $CRIT )); then
  echo "MEM CRITICAL - $output"
  exit 2
elif (( $UsedPer >= $WARN )); then
  echo "MEM WARNING - $output"
  exit 1
else
  echo "MEM OK - $output"
  exit 0
fi
