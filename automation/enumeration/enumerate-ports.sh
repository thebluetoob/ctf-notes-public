#!/bin/bash
set -e

if [ "$#" -ne 1 ]
then
	echo -e "Usage:\n$BASH_SOURCE <IP address or Hostname>"
	exit 1
fi

#Declare variables and create pretty colours
target=$1
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
scanpath="1-initial-reconnaissance/nmap"

#Make directory for nmap scans to go in to
mkdir -p "$scanpath/archive"

# Kick off initial nmap scan to find open ports. Faster to just to a TCP connection to discover open ports than to do a version scan of the entire range
echo -e "performing initial TCP scan. Saving results to "$scanpath"/"$target"_tcp_initial"
sudo nmap -sS -p- -T4 -Pn -v --reason --open --stylesheet=/usr/share/nmap/nmap.xsl -oA ./"$scanpath"/"$target"_tcp_initial "$target" > /dev/null

#check if the initial TCP scan was successful

initialstatus=$?

if [ $initialstatus -ne 0  ]
then
	echo -e "$(RED)Initial TCP scan of host $target failed${NC}"
	exit $initialstatus
else
	echo -e "${GREEN}Initial TCP scan for "$target" completed successfully${NC}"
fi

#generate human readable HTML report for initial TCP scan using xsltproc and nmap stylesheet

echo "Generating HTML report for initial TCP scan"

xsltproc "$scanpath"/"$target"_tcp_initial.xml -o "$scanpath"/"$target"_tcp_initial_report.html

echo "Initial TCP scan report generated"

#carve out open TCP ports from the XML version of the file as it's cleaner than trying to grep the nmap or gnmap files. Final sed strips off trailing comma from tr invokation
open_tcp_ports=$(cat ./"$scanpath"/"$target"_tcp_initial.xml | grep "state=\"open\"" | cut -d"\"" -f 4 | tr '\n' ',' | sed 's/\,$//g')

#Kick off TCP version scan only on the open TCP ports to save time
echo -e "performing TCP version scan. Saving results to "$scanpath"/"$target"_tcp_version"
sudo nmap -sS -sV -sC -O -p"$open_tcp_ports" -T4 -Pn -v --reason --open --stylesheet=/usr/share/nmap/nmap.xsl -oA ./"$scanpath"/"$target"_tcp_version "$target" > /dev/null

#Check if the TCP version scan was successful

versionstatus=$?

if [ $versionstatus -ne 0  ]
then
	echo -e "$(RED)TCP version scan of host "$target" failed${NC}"
	exit $initialstatus
else
	echo -e "${GREEN}TCP version scan for "$target" completed successfully${NC}"
fi

#generate human readable HTML report for the TCP version scan using xsltproc and nmap style sheet
xsltproc "$scanpath"/"$target"_tcp_version.xml -o "$scanpath"/"$target"_tcp_version_report.html

echo "TCP version scan report generated"

mv "$scanpath"/"$target"_*.xml "$scanpath"/archive/
mv "$scanpath"/"$target"_*.gnmap "$scanpath"/archive/
mv "$scanpath"/"$target"_tcp_initial* "$scanpath"/archive/

echo "nmap scans complete for $target"