#!/usr/bin/env bash

#!/bin/bash
source .bashrc 
#PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/run/current-system/sw/bin:/usr/bin
#export PATH
#LOGFILE=~/logfile.log

#echo "Running script at $(date)" >> $LOGFILE
#echo "Running as user: $(whoami)" >> $LOGFILE
#grep --version >> $LOGFILE 2>&1
#date >> $LOGFILE 2>&1
#ping -c 1 google\.com >> $LOGFILE 2>&1

#{\033[30;37m%}  identity2@bsd:~ $ cat logfile.log 
#Running script at Sat Nov  2 11:03:26 UTC 2024
#Running as user: identity2
##grep (BSD grep, GNU compatible) 2.6.0-FreeBSD
#Sat Nov  2 11:03:26 UTC 2024
#PING(56=40+8+8 bytes) 2a01:4f8:252:3e22::52 --> 2a00:1450:4001:808::200e
#16 bytes from 2a00:1450:4001:808::200e, icmp_seq=0 hlim=118 time=5.157 ms
#%{\033[30;37m%}  identity2@bsd:~ $ cat logfile.log 
#Running script at Sat Nov  2 11:03:26 UTC 2024
#Running as user: identity2
#grep (BSD grep, GNU compatible) 2.6.0-FreeBSD
#Sat Nov  2 11:03:26 UTC 2024
#PING(56=40+8+8 bytes) 2a01:4f8:252:3e22::52 --> 2a00:1450:4001:808::200e
#16 bytes from 2a00:1450:4001:808::200e, icmp_seq=0 hlim=118 time=5.157 ms


# Calculate ping averages Use awk 
overall_avg=$(awk '
    BEGIN { sum = 0; count = 0 }
    $1 ~ /^[0-9]+(\.[0-9]+)?$/ { sum += $1; count++ }
    END {
        if (count > 0)
            printf "%.2f", sum / count
        else
            print "NA"
    }
' "${HOME}/.local/ping.txt")
#echo "Overall average: $overall_avg"

# Generate output, C_ID is set with command as a label 
{
printf "\n<pre>"
printf "   <u>%-10.10s %-3s %-3s %-3s %-3s %-3s %-3s</u>\n"\
    "Hostname" "Os" "Lua" "Php" "Rb" "Gem" "Sh"
           
printf "]%s %-10.10s %-3s %-3s %-3s %-3s %-3s %-3s\n"\
    "${C_ID:-N}" \
	"${HOSTNAME} $(cat /proc/sys/kernel/hostname)" \
    "$(uname | cut -c -3 )" \
    "$(lua -v 2>/dev/null | awk 'NR==1 {print $2}'|cut -d. -f1,2 || echo "<s>lua</s>")" \
    "$(php -v 2>/dev/null | awk 'NR==1 {print $2}'|cut -d. -f1,2 || echo "<s>php</s>")" \
    "$(ruby -v 2>/dev/null| awk 'NR==1 {print $2}'|cut -d. -f1,2 || echo "<s>rb</s>")" \
    "$(gem -v 2>/dev/null | cut -d. -f1,2 || echo "<s>gem</s>")" \
    "$(basename "$SHELL")" 
    # D, P ok $HOSTNAME.... C, E, J, O, T, S  OK cat /proc....

printf "|%s %s %s %s %s %s %s %s %s %s %s\n" \
	"${C_ID:-N}" \
	"$(command -v w3m      >/dev/null 2>&1 && echo "w3m" || echo "<s>w3m</s>"  )" \
	"$(command -v lynx     >/dev/null 2>&1 && echo "lynx"|| echo "<s>lynx</s>" )" \
	"$(command -v git      >/dev/null 2>&1 && echo "git" || echo "<s>git</s>"  )" \
    	"$(command -v jekyll   >/dev/null 2>&1 && echo "jek" || echo "<s>jek</s>"  )" \
	"$(command -v newsboat >/dev/null 2>&1 && echo "nwsb"|| echo "<s>nwsb</s>" )" \
 	"$(command -v weechat  >/dev/null 2>&1 && echo "wee" || echo "<s>wee</s>"  )" \
  	"$(command -v tldr     >/dev/null 2>&1 && echo "tldr"|| echo "<s>tldr</s>" )" \
  	"$(command -v eza      >/dev/null 2>&1 && echo "eza" || echo "<s>eza</s>"  )" \
  	"$(command -v fzf      >/dev/null 2>&1 && echo "fzf" || echo "<s>fzf</s>"  )" \
   	"$(command -v ${HOME}/.local/bin/tgpt >/dev/null 2>&1 && echo "tgpt" || echo "<s>tgpt</s>")"
    
      	#"$(command -v exa      >/dev/null 2>&1 && echo "exa" || echo "<s>exa</s>"  )" \
 
printf "[%s %s\n" \
	"${C_ID:-N}" \
	"$(grep "^$(whoami):" /etc/passwd | \
	sed 's/identit//g; s/id2/d2/g; s/aaa/aa/g; s/in//; s/sr//; s/ome//; s/nfo//; s/kg//; s/ocal//; s/,,,//; s/User \&// ; s/:100:/: 100:/')" 

#!/bin/bash

# Check if .local/bin is in the PATH
if [[ "$PATH:" == *":/home/$USER/.local/bin:"* ]]; then
    printf "(%s .local/bin is in the PATH\n" "${C_ID:-N}"
else
    printf "(%s .local/bin is not in the PATH\n" "${C_ID:-N}"
fi

tiny_path=$( echo "$PATH" | sed -e 's/current-system/c-s/g' -e 's/bin/b/g' -e 's/usr/u/g' -e 's/local/l/g' -e 's/games/g/g' -e 's/home/h/g' -e 's/identity/I/g' )
printf ")%s %s\n" "${C_ID:-N}" "$tiny_path" 
 
#printf "   <u>%-8s %-8s|%-3s %-3s %-3s %-3s</u>\n" \
#    "@H.K." "@Site" "dns" "h.k" "ave" "Ping"	

printf ">%s hk%-8s lo%-8s %-3s dns%-3s hk%-3s ave%-3s\n" \
    "${C_ID:-N}" \
    "$(TZ=UTC-8 date +'%H:%M/%d' 2>/dev/null || date +'%H:%M/%d')" \
    "$(date +'%H:%M/%d')" \
    "$(ping -c 1 -w 1 8.8.8.8 >/dev/null 2>&1 && ping -c 3 8.8.8.8 2>/dev/null \
       	| awk -F'/' 'END {printf "%.0f\n", $5}' || echo "NA")" \
    "$(ping -c 1 -w 1 123.255.88.1 >/dev/null 2>&1 && ping -c 3 123.255.88.1 2>/dev/null \
        | awk -F'/' 'END {printf "%.0f\n", $5}' || echo "NA")" \
    "$overall_avg" \
    "$total_count"
    #123.255.91.198 an alternate 203.104.103.86 Japan Net Info Ctr (JPNIC)
    	
if [ -d /home/i/identity ]; then
	printf "</pre>\n<p>\n<span style='color:red;'>no last access info</span>\n<br>"
elif [ -d /home/aaa/store ]; then
    printf "</pre>\n<p>\n<span style='color:red;'>access list off for aaa</span>\n<br>"
else
	# Get the date 4 days ago in YYYY-MM-DD format Try Linux, then fall back to current date
	four_days_ago=$(date -d '-4 days' +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d)
	current_user=${USER:-$(whoami)}
	# Fetch login times for the current user in the last 4 days
	last_access=$(last -t "$four_days_ago" "$current_user" 2>/dev/null |
    	awk -F'[()]' '{print $2}' |  # Extract timestamps
    	tr '\n' ' ' |                # Join lines
    	sed 's/00:0[0-9]//g; s/00//g; s/ 0/ /g')  # Remove leading zeros
	printf "</pre>\n<p>\n<span style='color:red;'>%s\n</span>\n<br>" \
 		"$last_access"
fi

printf "\n%s\n</p>\n</div>\n\n\n\n" "$(crontab -l | grep '* * '|sed 's/>\/dev\/null 2>&1/<br>/')"

} > ~/public_html/a.txt

cat ~/public_html/a.txt

#ps -p $$ – Display your current shell name reliably.
#echo "$SHELL" – Print the shell for the current user but not necessarily the shell that is running at the movement.
#echo $0 – Another reliable and simple method to get the current shell interpreter name on Linux or Unix-like systems.
#readlink /proc/$$/exe – Another option to get the current shell name reliably on Linux operating systems.
#cat /etc/shells – List pathnames of valid login shells currently installed
#NO RESULT grep "^$USER" /etc/passwd – Print the default shell name. The default shell runs when you open a terminal window.
