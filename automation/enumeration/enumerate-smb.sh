#!/bin/bash
set -e
#set -x 

#################################
#### NOT DONE YET DO NOT USE ####
#################################

if [ "$#" -ne 99 ]
then
#	echo -e "Usage:\\n$BASH_SOURCE <IP address or Hostname> or;\\n$BASH_SOURCE <IP address or Hostname> <username> <password>"
	echo -e "NOT DONE YET DON'T USE THIS CRAPPY SCRIPT"
	exit 1
fi

#Declare variables and create pretty colours
target=$1
smbusername=$2
smbpassword=$3
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
scanpath="./1-initial-reconnaissance/smb"

#Make directory for nmap scans to go in to
mkdir -p "$scanpath/archive"
mkdir -p "$scanpath/loot"

#open_tcp_ports=$(cat ./"$scanpath"/"$target"_tcp_initial.xml | grep "state=\"open\"" | cut -d"\"" -f 4 | tr '\n' ',' | sed 's/\,$//g')

smb_ports=$(cat ./1-initial-reconnaissance/nmap/archive/"$target"_tcp_initial.xml | grep -E '(Samba|smb|SMB|netbios|139|445)' | grep "state=\"open\"" | cut -d"\"" -f 4)

#########################################################
# Try and grab the hostname of the target using nmblookup
#########################################################
# use printf instead of print in awk to prevent awk placing a 0a at the end of the output
# <20> in nbmlookup output indicates that the service is a "File Service" per https://www.hackingarticles.in/a-little-guide-to-smb-enumeration/
#### For unique names:
#### 
####     00: Workstation Service (workstation name)
#### 
####     03: Windows Messenger service
#### 
####     06: Remote Access Service
#### 
####     20: File Service (also called Host Record)
#### 
####     21: Remote Access Service client
#### 
####     1B: Domain Master Browser – Primary Domain Controller for a domain
#### 
####     1D: Master Browser
#### 
#### For group names:
#### 
####     00: Workstation Service (workgroup/domain name)
#### 
####     1C: Domain Controllers for a domain
#### 
####     1E: Browser Service Elections

echo "Running nmblookup on "$target" to discover hostname"
nmblookup -A "$target" > "$scanpath"/archive/nmblookup_output.txt
nmbhostname=$(cat "$scanpath"/archive/nmblookup_output.txt | grep '<20>' | awk '{printf $1}')

if [ -z $nmbhostname ]
then
    echo "$nmbhostname" is empty!""
    exit 50
else
    echo -e "nmblookup successful\\nSMB Hostname:\\t"$nmbhostname""
fi

# Now that we have the hostname, lets see if we can authenticate to the server. First with a NULL session (not using credentials), and then with (if provided)

if [  -z $smbusername ] #if no username was provided at runtime then test for NULL sessions
then
    smbclient -L \\\\"$nmbhostname" -I "$target" -U "" -N > "$scanpath"/archive/smbclient_output.txt
    # check if NULL session authentication was successful
    nullsessionstatus=$?
    if [ $nullsessionstatus -ne 0  ]
    then
        echo -e "$(RED)Cannot authenticate to $target using NULL session\\nPlease provide credentials${NC}"
        exit 50
    else
        echo -e "${GREEN}"$target" allows NULL sessions. Discovering shares...${NC}"
    fi
else
    #if credentials were provided at runtime then use them here to enumerate the shares
    smbclient -L \\\\"$nmbhostname" -I "$target" -U \""$smbusername"\"%\""$smbpassword"\" > "$scanpath"/archive/smbclient_output.txt
fi

allsmbshares=$(cat "$scanpath"/archive/smbclient_output.txt | grep -E '(Disk|IPC)' | cut -f 2)
nondefaultshares=$(cat "$scanpath"/archive/smbclient_output.txt | grep -E '(Disk|IPC)' | grep -Ev '(print\$.*Disk.*Printer Drivers|IPC\$.*IPC.*)' | cut -f 2 | cut -d" " -f 1)


for share in $nondefaultshares
do
    # smbclient \\\\RED\\kathy -I stapler -U "" -N -c 'prompt OFF; recurse ON ; lcd './stapler/smb/'; mget *'
    mkdir -p "./$scanpath/loot/$share"
    smbclient \\\\"$nmbhostname"\\$share -I $target -U \""$smbusername"\"%\""$smbpassword"\" -c "prompt OFF; recurse ON ; lcd "./$scanpath/loot/$share/"; mget *" 2> "$scanpath"/archive/loot_output.txt
    echo "Looted share "$share", found:"
    for i in $(ls "./$scanpath/loot/$share/")
    do
        echo -e "\\t$i"
    done
done

# Kick off initial nmap scan to find open ports. Faster to just to a TCP connection to discover open ports than to do a version scan of the entire range
# echo -e "performing initial TCP scan. Saving results to "$scanpath"/"$target"_tcp_initial"
# nmap -sT -p- -T4 -Pn -v --reason --open --stylesheet=/usr/share/nmap/nmap.xsl -oA ./"$scanpath"/"$target"_tcp_initial "$target" > /dev/null
# 
# #check if the initial TCP scan was successful
# 
# initialstatus=$?
# 
# if [ $initialstatus -ne 0  ]
# then
# 	echo -e "$(RED)Initial TCP scan of host $target failed${NC}"
# 	exit $initialstatus
# else
# 	echo -e "${GREEN}Initial TCP scan for "$target" completed successfully${NC}"
# fi