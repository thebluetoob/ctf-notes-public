#!/bin/bash

# Generate a useful folder and file structure for note taking in markdown format

set -e

if [ "$#" -ne 1 ]
then
	echo -e "Usage:\n$BASH_SOURCE <NAME_IP-Address>"
	exit 1
fi

#Declare variables and create pretty colours
machine=$1
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# create folder for new VM and change in to that directory to create additional folders
mkdir -p "./$machine"

# create folder for nmap and smb enumeration script output
mkdir -p "./$machine/1-initial-reconnaissance/nmap"
mkdir -p "./$machine/1-initial-reconnaissance/smb"

# create initial information sheet

echo -e "## Summary\n-VM Name: \n-IP Address: \n-Operating System: \n-Kernel: \n" > ./$machine/summary.md

mkdir -p "./$machine/1-initial-reconnaissance"
mkdir -p "./$machine/2-exploitation"
mkdir -p "./$machine/3-post-exploitation"
mkdir -p "./$machine/4-privilege-escalation"
mkdir -p "./$machine/5-proof"

echo -e "# Initial Reconnaissance\n\n## Heading 1 (Port 80 - HTTP)\n### Sub-heading 1 (Nikto)\n## Heading 2\n### Sub-heading 2" > "./$machine/1-initial-reconnaissance/"$machine"_initial-reconnaissance.md"
echo -e "# Exploitation\n\n## Heading 1 (Service Exploited)\n### Sub-heading 1 (Exploit)\n## Heading 2\n### Sub-heading 2" > "./$machine/2-exploitation/"$machine"_exploitation.md"
echo -e "# Post Exploitation\n\n## Heading 1 (Operating System Information)\n### Sub-heading 1 (LinEnum Output)\n## Heading 2 (Users and Groups)\n### Sub-heading 2 (Users)\n### Sub-heading 3 (Groups)\n### Sub-heading 4 (Scheduled Tasks)" > "./$machine/3-post-exploitation/"$machine"_post-exploitation.md"
echo -e "# Privilege Escalation\n\n## Heading 1\n### Sub-heading 1\n## Heading 2\n### Sub-heading 2" > "./$machine/4-privilege-escalation/"$machine"_privilege-escalation.md"

